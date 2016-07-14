class MPX::FileManagement
  ENDPOINT = 'http://fms.theplatform.com/web/FileManagement'.freeze
  SCHEMA = '1.5'.freeze

  def self.link_file(media_id, file_url = nil)
    unless file_url
      puts "!! Cannot link empty file to media #{media_id}"
      return
    end
    full_url = self::ENDPOINT + '/linkNewFile?' + {
      schema: self::SCHEMA,
      token: ENV['MPX_TOKEN'],
      form: 'json',
      '_mediaId' => media_id,
      '_sourceUrl' => file_url
    }.to_query
    response = HTTParty.get(full_url)
  end
end
