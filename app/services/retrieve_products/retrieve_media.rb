class RetrieveProducts
  class RetrieveMedia
    ENDPOINT = 'https://data.media2.theplatform.com/media/data/Media/'.freeze

    Result = ImmutableStruct.new(:media_retrieved?, :error_message, :raw)

    def initialize(http)
      self.http = http
    end

    def self.build
      new HTTParty
    end

    def call(product_item)
      id = product_item.mpxid.gsub(/\A.+\/(\d+)\z/, '\1').to_i

      result = begin
                 http.get("#{ENDPOINT}#{id}", query: {
                            'token' => ENV['THEPLATFORM_TOKEN'],
                            'schema' => '1.2',
                            'form' => 'cjson'
                          })
               rescue
                 nil
               end

      if result && result.parsed_response['isException'].nil?
        Result.new(media_retrieved: true, raw: result.parsed_response)
      else
        Result.new(media_retrieved: false, error_message: 'Failed to retrieve Media')
      end
    end

    private

    attr_accessor :http
  end
end
