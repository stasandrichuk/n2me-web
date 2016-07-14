class GetPluser
  ENDPOINT = 'https://euid.theplatform.com/idm/web/Self/getSelf'.freeze

  Result = ImmutableStruct.new(:pluser_gotten?, :error_message, :details)

  def initialize(http)
    self.http = http
  end

  def self.build
    new HTTParty
  end

  def call(token)
    result = begin
               http.get(ENDPOINT, query: {
                          'token' => token,
                          'schema' => '1.0',
                          'form' => 'json'
                        })
             rescue
               nil
             end

    if result && (response = result.parsed_response['getSelfResponse'])
      Result.new(pluser_gotten: true, details: response)
    else
      Result.new(pluser_gotten: false, error_message: 'Failed to get self MPX user')
    end
  end

  private

  attr_accessor :http
end
