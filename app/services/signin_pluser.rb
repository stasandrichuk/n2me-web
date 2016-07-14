class SigninPluser
  ENDPOINT = 'https://euid.theplatform.com/idm/web/Authentication/signIn'.freeze

  Result = ImmutableStruct.new(:pluser_signedin?, :error_message, :token)

  def initialize(http)
    self.http = http
  end

  def self.build
    new HTTParty
  end

  def call(user_params)
    result = begin
               http.get(ENDPOINT, query: {
                          'userName' => "#{ENV['THEPLATFORM_DIRECTORY_PID']}/#{user_params[:email]}",
                          'password' => user_params[:password],
                          'schema' => '1.1',
                          'form' => 'json'
                        })
             rescue
               nil
             end

    if result && (response = result.parsed_response['signInResponse'])
      Result.new(pluser_signedin: true, token: response['token'])
    else
      Result.new(pluser_signedin: false, error_message: 'Failed to sign in MPX user')
    end
  end

  private

  attr_accessor :http
end
