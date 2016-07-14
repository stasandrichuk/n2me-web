require 'thread/pool'
namespace :mpx do
  desc 'Download games from MPX'
  task :download_games => :environment do
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
    error_raised = false
    error_message = ''
    ["1468997596", "1469509618", "1468997598", "1468997599", "1469509617",
     "1468997600", "1468997602", "1468997601", "1422405926"].each do |cat_number|
      category = MPX::Category.mpx_find_by_number(cat_number)
      puts "Loading category #{category.title}"
      media = category.media
      begin
        media.each do |m|
          if m.file_url.blank?
            puts "skip empty game"
            next
          end
          pool.process do
             ActiveRecord::Base.connection_pool.with_connection do
              download_game(m)
            end
          end
          pool.wait(:idle)
        end
      rescue Exception => e
        error_raised = true
        error_message = e.message
        puts "!!!!!!!!!!!!!!! #{e.message}"
        p e.backtrace
      end
    end
    sleep(3)
    pool.wait(:done)
    pool.shutdown
    
    if error_message.present?
      puts "Failed #{error_message}"
    else
      puts "Job done, media downloaded."
    end
  end

  def download_game(m)
    new_medium = Medium.find_by(number: m.number)
    if new_medium.present? && m.attributes['media$categories'].present?
      attach_categories(new_medium, m)
    end
    
    if new_medium.present?
      puts "Game already exists"
      return
    end

    new_medium = Game.create(title: m.title, number: m.number, is_a_game: true,
                               embedded_code: m.file_url, description: m.description)

    if m.attributes['media$categories'].present?
      attach_categories(new_medium, m)
    end


    if m.thumbnail_url.present?
      begin
        new_medium.save
        new_medium.picture.download! m.thumbnail_url
        new_medium.picture.store!
        new_medium.save
      rescue Exception => e
        puts "Cannot download thumbnail, #{e.message}"
      end
    end
    
    new_medium.save
    puts "Game saved: #{new_medium.title}"
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