class Listing < ActiveRecord::Base
  # ==== return a lineup URI with the API Key
	def self.get_site_uri
		@lineups_search = 'http://api.tvmedia.ca/tv/v4/lineups?api_key=' + ENV['TV_MEDIA_API_KEY'] + '&'
	end

  # ==== return a tv listings URI with lineup ID
	def self.get_lineup_tv_listings lineup
		'http://api.tvmedia.ca/tv/v4/lineups/' + lineup + '/listings?api_key=' + ENV['TV_MEDIA_API_KEY'] + '&'
	end

	def self.get_lineup_info_uri lineup
		'http://api.tvmedia.ca/tv/v4/lineups/' + lineup + '?api_key=' + ENV['TV_MEDIA_API_KEY'] + '&detail=brief'
	end

  # ==== format time for HTTP request URI
	def self.format_time time
		time = time.strftime('%Y-%m-%d %H:%M')
		time = replace_space time
		replace_colon time
	end

	# ==== replace a blank space with %20 for HTTP request URI
	def self.replace_space str
		str = str.gsub(/[ ]/, '%20')
	end

	# ==== replace a colon with %3A for HTTP request URI
	def self.replace_colon str
		str = str.gsub(/[:]/, '%3A')
	end

	# ==== replace a comma with %2C for HTTP request URI
	def self.replace_comma str
		str = str.gsub(/[,]/, '%2C')
	end

  def self.get_medianet_uri	
    "http://api.mndigital.com?apiKey=" + ENV['MND_PRODUCTION_API_KEY'] + "&rights=purchase&includeExplicit=true&format=json"
  end
end
