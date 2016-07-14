class MPX::ResourceService
  def initialize(endpoint, schema, token = ENV['MPX_TOKEN'])
    @endpoint = endpoint
    @schema = schema
    @token = token
  end

  def fetch(options = {})
    options[:range] = entries_range(options.delete(:page).to_i, options.delete(:limit))

    options = { form: 'json', schema: @schema, token: @token }.merge(options)
    full_url = "#{@endpoint}?" + options.to_query
    puts "*** #{full_url}" if Rails.env.development?
    response = Rails.cache.fetch(full_url, expires_in: 15.minutes) do
      response = HTTParty.get(full_url).body
    end
    Oj.load(response)
  end

  def self.create_resource(klass, attributes)
    payload = { "$xmlns": {
      "media": 'http://search.yahoo.com/mrss/',
      "pl": 'http://xml.theplatform.com/data/object',
      "plmedia": klass::IDENTITY
    } }
    payload.merge! attributes.merge(ownerId: ENV['THEPLATFORM_ACCOUNT'])
    url = klass::ENDPOINT + '?' + { token: ENV['MPX_TOKEN'], schema: klass::SCHEMA, form: 'json' }.to_query
    response = HTTParty.post(
      url, body: payload.to_json,
           headers: { 'Content-Type' => 'text/plain; charset=utf-8' }
    )
    Oj.load(response.body)
  end

  private

  def entries_range(page, limit = nil)
    return "1-#{limit}" if limit.to_i > 0
    per_page = MPX::RemoteResource::PER_PAGE
    if page < 2
      range = "1-#{per_page}"
    else
      start = per_page * (page - 1) + 1
      range = "#{start}-#{start + per_page - 1}"
    end
  end
end
