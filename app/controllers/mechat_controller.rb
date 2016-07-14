class MechatController < ApplicationController
  before_action :authenticate_user!
  layout 'new_layout'

  def index
  end
end
