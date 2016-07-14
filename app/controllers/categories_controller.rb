class CategoriesController < ApplicationController
  before_filter :authenticate_user!

  layout 'new_layout'

  def index
    @categories = Category.root_categories
    render 'categories/index_new', layout: 'new_layout'
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
    @oan = MPX::Media.find_by_number('1428037766')
    @awe = MPX::Media.find_by_number('147013915')
    @media = @category.media.where(language: current_language).page(params[:page] || 1).per(MPX::RemoteResource::PER_PAGE)

    render 'categories/show_new'
  end

  def music
    request_str = Listing.get_medianet_uri
    page = 1
    page_size = 20
    
    if not params[:search].blank?
      title = params[:search]
      title_for_uri = title
      title_for_uri = Listing.replace_space title_for_uri
      request_str = request_str + '&method=search.gettracks' + '&title=' + title_for_uri + '&page=' + page.to_s + '&pageSize=' + page_size.to_s
    else
      request_str = request_str + '&method=search.gettracks' + '&page=' + page.to_s + '&pageSize=' + page_size.to_s
    end
      
    begin
      response = HTTParty.get(request_str, timeout: 600)
    rescue Net::ReadTimeout
      nil
    end

    track_list = JSON.parse(response.body)

    if track_list['Success'] == true && track_list['TotalResults'] > 0
      gon.success = true
      gon.track_list = track_list
      if (page - 1) * page_size + 1 <= track_list['TotalResults'] 
        gon.more_flag = true
      end 
      gon.page = page
      if not (defined?(title)).nil?
        gon.title = title
      end
    else
      gon.success = false
    end 
    # else
    #   gon.success = false
    # end

  end

  def more_musics

    title = params[:title]
    title_for_uri = title
    title_for_uri = Listing.replace_space title_for_uri

    request_str = Listing.get_medianet_uri
    
    page = params[:page].to_i + 1
    page_size = 20

    request_str = request_str + '&method=search.gettracks' + '&title=' + title_for_uri + '&page=' + page.to_s + '&pageSize=' + page_size.to_s

    begin
      response = HTTParty.get(request_str, timeout: 600)
    rescue Net::ReadTimeout
      nil
    end

    track_list = JSON.parse(response.body)

    @data = Hash.new

    if track_list['Success'] == true && track_list['TotalResults'] > 0
      @data['success'] = true
      @data['track_list'] = track_list
      if (page - 1) * page_size + track_list['ResultsReturned'] == track_list['TotalResults'] 
        @data['more_flag'] = false
      else
        @data['more_flag'] = true 
      end 
      @data['page'] = page
      @data['title'] = title
    else
      @data['success'] = false
    end 

    render json: @data
  end

  def more_musics

    title = params[:title]
    title_for_uri = title
    title_for_uri = Listing.replace_space title_for_uri

    request_str = Listing.get_medianet_uri
    
    page = params[:page].to_i + 1
    page_size = 20

    request_str = request_str + '&method=search.gettracks' + '&title=' + title_for_uri + '&page=' + page.to_s + '&pageSize=' + page_size.to_s

    begin
      response = HTTParty.get(request_str, timeout: 600)
    rescue Net::ReadTimeout
      nil
    end

    track_list = JSON.parse(response.body)

    @data = Hash.new

    if track_list['Success'] == true && track_list['TotalResults'] > 0
      @data['success'] = true
      @data['track_list'] = track_list
      if (page - 1) * page_size + track_list['ResultsReturned'] == track_list['TotalResults'] 
        @data['more_flag'] = false
      else
        @data['more_flag'] = true 
      end 
      @data['page'] = page
      @data['title'] = title
    else
      @data['success'] = false
    end 

    render json: @data
  end

end
