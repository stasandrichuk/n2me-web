class PagesController < ApplicationController
  def index
  end

  def events
    category = Category.find_by_title('Events')
    @events = category.media
  end
end
