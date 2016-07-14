class MPX::Category < MPX::RemoteResource
  ENDPOINT = 'http://data.media2.theplatform.com/media/data/Category'.freeze
  SCHEMA = '1.0'.freeze
  LOCAL = 'Category'.freeze

  def self.root_categories
    MPX::Category.all.select do |c|
      c.attributes['plcategory$parentId'].empty? &&
        !(c.attributes['title'].to_s =~ /books|games/i)
    end
  end

  def title
    attributes.title.to_s.sub(/\A\w--/, '')
  end

  def media(params = {})
    @media ||= MPX::Media.all(params.merge(byCategoryIds: number))
  end

  def categories
    @categories ||= MPX::Category.all.select do |cat|
      cat.attributes['plcategory$parentId'] == id
    end
  end

  def thumbnail_url
    return description if description.present?
    @thumbnail_url ||= media.find { |m| m.thumbnail_url.present? }.try :thumbnail_url
  end
end
