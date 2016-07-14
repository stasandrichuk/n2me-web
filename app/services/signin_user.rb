class SigninUser
  Result = ImmutableStruct.new(:user_signedin?, :error_message)

  def initialize(signin_pluser, get_pluser)
    self.signin_pluser = signin_pluser
    self.get_pluser = get_pluser
  end

  def self.build
    new SigninPluser.build, GetPluser.build
  end

  def call(user_params, user)
    return Result.new(user_signedin: true) if check_token(user)

    result = signin_pluser.call(user_params)

    if result.pluser_signedin?
      user.update_attribute :mpx_token, result.token
      Result.new(user_signedin: true)
    else
      Result.new(user_signedin: false, error_message: result.error_message)
    end
  end

  private

  attr_accessor :signin_pluser, :get_pluser

  def check_token(user)
    get_pluser.call(user.mpx_token).pluser_gotten?
  end
end
