class MediaController < ApplicationController
  before_filter :authenticate_user!
  layout 'new_layout'

  def index
    @category = MPX::Category.find_by_number(params[:category_id])
    @oan = MPX::Media.find_by_number('1428037766')
    @awe = MPX::Media.find_by_number('147013915')
    @media = @category.media.page(params[:page] || 1).per(MPX::RemoteResource::PER_PAGE)
    render 'media/new/index'
  end

  def show
    @mobile = params[:html5] || request.user_agent =~ /mobile/i
    @media = MPX::Media.find_by_number(params[:number])
    if params[:modal].present?
      render 'media/new/modal', layout: 'modal'
      return
    end

    if @media.category_name =~ /Events/
      render_event; return;
    end
    current_user.push_media_to_history(@media.number) if current_user.present?
    if @media.is_a_game
      render 'media/new/show_game'; return;
    end
    if @media.number == '625732748355'
      render 'media/new/mr_pink', :layout => 'pages'; return;
    end
    render 'media/new/show'
  end

  private

  def render_event
    @results = Events.where("start_date < ? AND end_date > ? AND media_id = ?", Time.now, Time.now, @media.number)
    if @results.first.nil?
      @hasCurrentEvent = false
    else
      @hasCurrentEvent = true
      @currentEvent = @results.first
    end
    @results = Events.where("end_date > ? AND media_id = ?", Time.now, @media.number).order(:start_date).limit(1)
    if @results.first.nil?
      @hasNextEvent = false
    else
      @hasNextEvent = true
      @nextEvent = @results.first
    end
    render 'media/show_event'
  end

end
