module CreateUser
  class CreatePluser
    Result = ImmutableStruct.new(:pluser_created?, :error_message, :id)

    def initialize(tpdata)
      self.tpdata = tpdata
    end

    def self.build
      new ThePlatform::Data
    end

    def call(user)
      body = { '$xmlns': { 'pluser': 'http://xml.theplatform.com/auth/data/User' },
               'pluser$ownerId' => ENV['THEPLATFORM_ACCOUNT'],
               'pluser$userName' => user.email,
               'pluser$email' => user.email,
               'pluser$password' => user.password }.to_json
      params = { form: 'json', schema: '1.0', account: ENV['THEPLATFORM_ACCOUNT'] }

      result = begin
                 tpdata.euid.post("User/#{ENV['THEPLATFORM_DIRECTORY_PID']}", body, params)
               rescue
                 nil
               end

      if result && result.parsed_response['id']
        Result.new(pluser_created: true, id: result.parsed_response['id'])
      else
        Result.new(pluser_created: false, error_message: 'Failed to create MPX user')
      end
    end

    private

    attr_accessor :tpdata
  end
end
