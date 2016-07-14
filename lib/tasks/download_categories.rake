namespace :mpx do
  desc 'Download categories from MPX'
  task :download_categories => :environment do
    page = 1
    loop do
      puts "Loading page #{page}"
      cats = MPX::Category.all(page: page)
      break if cats.empty?
      page += 1

      # process categories
      cats.each do |cat|
        download_category(cat)
      end
    end
    puts "Job done, categories downloaded."
  end

  def download_category(cat)
    new_cat = Category.create(title: cat.title, number: cat.number)
    if cat.description.present?
      new_cat.picture.download! cat.description
      new_cat.picture.store!
      new_cat.save
    end
    # check for parent category
    parent_mpx = cat.attributes["plcategory$parentId"]
    new_cat.category_id = find_or_create_parent_category(parent_mpx).id if parent_mpx.present?
    new_cat.save
    puts "Category saved: #{new_cat.title}"
    new_cat
  end

  def find_or_create_parent_category(parent_mpx)
    parent_number = extract_number(parent_mpx)
    raise 'WTF' if parent_mpx.blank?
    local_cat = Category.find_by(number: parent_number)
    return local_cat if local_cat.present?
    download_category(MPX::Category.find_by_number(parent_number))
  end

  def extract_number(mpx_id)
    mpx_id[/[^\/]+$/]
  end
end