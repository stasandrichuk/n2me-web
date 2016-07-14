require 'thread/pool'
namespace :mpx do
  desc 'Download media (only video) from MPX'
  task :download_media => :environment do
    # preload classes
    MPX::ResourceService
    MPX::RemoteResource
    MPX::RemoteResource::PER_PAGE = 500
    MPX::Media
    Medium
    MediaCategory
    Category
    #
    pool = Thread.pool(10)
    page = 1
    error_raised = false
    error_message = ''
    loop do
      puts "Loading page #{page}"
      media = MPX::Media.all(page: page)
      break if media.empty? || error_raised
      page += 1

      # process categories
      pool.process do
        begin
          ActiveRecord::Base.connection_pool.with_connection do
            media.each do |m|
              if m.category_name.to_s =~ /Book|Games/i || m.file_url.to_s =~ /ebooks|\.pdf/
                puts "skip #{m.category_name}: #{m.title}"
                next
              end

              if m.file_url.blank? && m.description.blank?
                puts "skip empty media"
                next
              end
              download_media(m)
            end
          end
        rescue Exception => e
          error_raised = true
          error_message = e.message
          puts "!!!!!!!!!!!!!!! #{e.message}"
          p e.backtrace
        end
      end
      pool.wait(:idle)
    end
    pool.shutdown
    if error_message.present?
      puts "Failed #{error_message}"
    else
      puts "Job done, media downloaded."
    end
  end

  def download_media(m)
    new_medium = Medium.create(title: m.title, number: m.number)
    if m.attributes['media$categories'].present?
      attach_categories(new_medium, m)
    end

    if m.thumbnail_url.present?
      begin
        new_medium.picture.download! m.thumbnail_url
        new_medium.picture.store!
        new_medium.save
      rescue Exception => e
        puts "Cannot download thumbnail, #{e.message}"
      end
    end

    if m.file_url.present?
      new_medium.source_url = m.file_url
      new_medium.description = m.description
    else
      new_medium.embedded_code = m.description
    end

    new_medium.save
    puts "Media saved: #{new_medium.title}"
    new_medium
  end

  def attach_categories(medium, m)
    m.attributes['media$categories'].each do |category|
      title = category['media$name'].split('/').last.to_s.gsub(/\A\w--/, '')
      next if title.blank?
      local_cat = Category.find_by(title: title)
      next if local_cat.blank?
      MediaCategory.create(medium_id: medium.id, category_id: local_cat.id)
    end
  end

end