require 'httparty'
require 'json'
require 'yaml'
require 'pp'

class SchedulesController < ApplicationController
	before_filter :authenticate_user!
	before_action :get_all_channels

	layout 'new_layout'
	
	def index
		
		# ==== Start: Change User Preference
		#
		#   If user changes preferences, it will be saved into DB
		if params[:preference_changed].eql? "true"
			update_preference = current_user.preference
			
			update_preference.update(initial_time: params[:initial_time], time_span: params[:time_span].to_i, grid_height: params[:grid_height].to_i, station_filter: params[:st_filter_hidden])
		end 
		# ==== End: Change User Preference

		user_preference

		# ==== Start: Get Params And Make Necessary Time Variables
		# 
		#   Time Variables suffixed with _t are used for moment js: e.g. 2016-05-25 22:00:00
		#   Time Variables without suffix are used for HTTP request: e.g. 2016-05-25%2022%3A00
		if not params[:utc_offset].blank?
			@utc_offset = params[:utc_offset].to_i
		end

		if not params[:utc_locale].blank?
			@utc_offset = params[:utc_locale].to_i
		end

		if not params[:now].blank? 
			@now = params[:now]
			@start = Time.parse(@now).change(:hour => 0, :min => 0, :sec => 0)
		end

		if not params[:cur_now].blank? 
			@now = params[:cur_now]
			@start = Time.parse(@now).change(:hour => 0, :min => 0, :sec => 0)
		end
		
		
		@select_time_val = '00'
		@start_t = @start
		@start = Listing.format_time @start

		if not params[:listings_date_picker_date_select].blank? 
			@search_date = Time.parse(params[:listings_date_picker_date_select])
		else
			@search_date = @start_t
		end

		if not params[:listings_date_picker_time_select].blank?
			if params[:listings_date_picker_time_select].eql? "now"
				@search_time = @search_date.change(:hour => Time.parse(@now).hour, :min => 0, :sec => 0)
			else
				@search_time = @search_date + (60*60*params[:listings_date_picker_time_select].to_i)
			end
			@select_time_val = params[:listings_date_picker_time_select]
		else
			# @search_time = @search_date
			if @preference.initial_time.eql? "now"
				@search_time = @search_date.change(:hour => Time.parse(@now).hour, :min => 0, :sec => 0)	
				@select_time_val = 'now'
			else
				show_hour = 12 + @preference.initial_time.to_i
				@search_time = @search_date.change(:hour => show_hour, :min => 0, :sec => 0)
				@select_time_val = show_hour.to_s
			end
		end


		@end = @search_date + (60 * 60 * 24)
		@end_t = @end

		@search_date_t = @search_date
		@search_date   = Listing.format_time @search_date

		# ==== End: Get Params And Make Necessary Time Variables


		# ==== Start: Add User Favorite Channels
		#
		#   If user changes favorite channels, it will be saved into DB
		if params[:favorite_changed].eql? "true"
			current_user.stations.destroy_all
			@all_channels.each do |ch|
				if params[:status][ch.s_id.to_s + '_' + ch.s_number].eql? "true"
					current_user.stations << ch
				end
			end
		end 
		# ==== End: Add User Favorite Channels

		
		# ==== Start: Read DB data which contains tv listings
		#
		#   @tv_listing instance keeps tv listings data.
		@tv_listing = []

		@utc_start = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)
		@utc_one_day_ago = @utc_start - 1.day

		
		if (@utc_offset < 0 && @search_date_t.strftime('%Y-%m-%d') < @utc_start.strftime('%Y-%m-%d')) || (@utc_offset > 0 && @search_date_t.strftime('%Y-%m-%d') == @utc_start.strftime('%Y-%m-%d'))
			updated_date = @utc_one_day_ago
		else
			updated_date = @utc_start
		end 

		st_types_arr = @preference.station_filter.split(/[,]/)
		sql_for_st_types = " AND ("
		st_types_arr.each_with_index do |st_type, i|
			if i == st_types_arr.length - 1
				sql_for_st_types = sql_for_st_types + "(station_type ILIKE " + "'%" + st_type.to_s + "%'))"
			else
				sql_for_st_types = sql_for_st_types + "(station_type ILIKE " + "'%" + st_type.to_s + "%') OR "
			end
		end

		user_favorite_channels st_types_arr

		sql_for_channels = ""
		if not @favorite_channels.blank?
			sql_for_channels = " AND ("
			@favorite_channels.each_with_index do |ch, index|
				if index == @favorite_channels.length - 1
					sql_for_channels = sql_for_channels + "(s_id=" + ch.s_id.to_s + " AND s_number='" + ch.s_number.to_s + "'))"
					break	
				end
				sql_for_channels = sql_for_channels + "(s_id=" + ch.s_id.to_s + " AND s_number='" + ch.s_number.to_s + "') OR "
			end
		end

		if not sql_for_channels.eql? ''
			@tv_listing = Listing.select("*, list_date_time + interval '1 minute' * " + @utc_offset.to_s + " AS locale_time").where("updated_date = ? AND list_date_time + interval '1 minute' * listings.duration > ? AND list_date_time < ?" + sql_for_channels + sql_for_st_types, @utc_one_day_ago, @search_date_t.getlocal("+00:00"), @end_t.getlocal("+00:00")).order("s_id ASC, s_number ASC, list_date_time ASC")
		end

		# ==== End: Read DB data which contains tv listings

		gon.start_t 	      = @start_t
		gon.search_time       = @search_time
		gon.search_date_t     = @search_date_t
		gon.select_time_val   = @select_time_val
		gon.all_channels      = @all_channels
		gon.tv_listing		  = @tv_listing
		gon.favorite_channels = @favorite_channels
		gon.media_numbers	  = MEDIA_NUMBERS
		gon.preference 		  = @preference
	end

	def show

		# ==== Start: Change User Preference
		#
		#   If user changes preferences, it will be saved into DB
		if params[:preference_changed].eql? "true"
			update_preference = current_user.preference
			
			update_preference.update(initial_time: params[:initial_time], time_span: params[:time_span].to_i, grid_height: params[:grid_height].to_i, station_filter: params[:st_filter_hidden])
		end 
		# ==== End: Change User Preference
		
  		
  		if not params[:cur_now].blank? 
			@now = params[:cur_now]
			@start_t = Time.parse(@now).change(:hour => 0, :min => 0, :sec => 0).strftime('%Y-%m-%d %H:%M:%S')
			@search_time = Time.parse(@now).getlocal("+00:00")
		end

		if not params[:utc_locale].blank?
			@utc_offset = params[:utc_locale].to_i
		end
		
		user_preference

		@tv_listing = []

		if params[:favorite_changed].eql? "true"
			current_user.stations.destroy_all
			@all_channels.each do |ch|
				if params[:status][ch.s_id.to_s + '_' + ch.s_number].eql? "true"
					current_user.stations << ch
				end
			end
		end 

		# Get A Keyword Param For Movie Search By A Name
		if not params[:search_word].blank?
	  		@search_word = params[:search_word]
	  	end

		if not params[:listings_search_term].blank?
	  		@search_word = params[:listings_search_term]
	  	end

  		@utc_start = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)

  		utc_one_day_ago = @utc_start - (60 * 60 * 24)

  		st_types_arr = @preference.station_filter.split(/[,]/)
		sql_for_st_types = " AND ("
		st_types_arr.each_with_index do |st_type, i|
			if i == st_types_arr.length - 1
				sql_for_st_types = sql_for_st_types + "(station_type ILIKE " + "'%" + st_type.to_s + "%'))"
			else
				sql_for_st_types = sql_for_st_types + "(station_type ILIKE " + "'%" + st_type.to_s + "%') OR "
			end
		end

		user_favorite_channels st_types_arr

		sql_for_channels = ""

		if not @favorite_channels.blank?
			sql_for_channels = " AND ("
			@favorite_channels.each_with_index do |ch, index|
				if index == @favorite_channels.length - 1
					sql_for_channels = sql_for_channels + "(s_id=" + ch.s_id.to_s + " AND s_number='" + ch.s_number.to_s + "'))"
					break	
				end
				sql_for_channels = sql_for_channels + "(s_id=" + ch.s_id.to_s + " AND s_number='" + ch.s_number.to_s + "') OR "
			end
		end

		if not sql_for_channels.eql? ''
			@tv_listing = Listing.where("episode_title ILIKE ? AND updated_date = ? AND list_date_time + interval '1 minute' * listings.duration > ?" + sql_for_channels + sql_for_st_types, '%' + @search_word + '%', utc_one_day_ago.strftime('%Y-%m-%d'), @search_time).order("list_date_time ASC, s_id ASC")  		
		end

		gon.start_t			  = @start_t
		gon.all_channels      = @all_channels
		gon.tv_listing 		  = @tv_listing
		gon.favorite_channels = @favorite_channels
		gon.media_numbers     = MEDIA_NUMBERS
		gon.preference 		  = @preference
		gon.search_word		  = @search_word
	end

	def video_feed
		@mobile = params[:html5] || request.user_agent =~ /mobile/i
	    @media = MPX::Media.find_by_number(params[:number])
	    render 'media/new/modal', :layout => false
	end

	private
	def user_favorite_channels st_types_arr
		sql_for_st_types = ""
		st_types_arr.each_with_index do |st_type, i|
			if i == st_types_arr.length - 1
				sql_for_st_types = sql_for_st_types + "(station_type ILIKE " + "'%" + st_type.to_s + "%')"
			else
				sql_for_st_types = sql_for_st_types + "(station_type ILIKE " + "'%" + st_type.to_s + "%') OR "
			end
		end

		@favorite_channels = current_user.stations.where(sql_for_st_types).order("s_id ASC, id ASC")
	end

	def get_all_channels
		@all_channels = Station.all.order("s_id ASC, id ASC")
	end

	def user_preference
		@preference = current_user.preference
	end

end
