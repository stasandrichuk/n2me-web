require 'json'
desc "Upgrade tv listings every day"
task tv_listings: :environment do
	tv_users = User.all
	all_channels = Station.all.order("s_id ASC, id ASC")
  	tv_users.each do |u|
  		if u.preference.nil?
  			preference_settings = Preference.new(initial_time: 'now', station_filter: 'broadcast,cable,community', time_span: 3, grid_height: 7)
    		u.preference = preference_settings
  		end

  		if u.stations.first.nil?
  			u.stations << all_channels
  		end
  	end

  	


	if not Lineup.exists?
			
		FAVORITE_LINEUPS.each_with_index do |item, index|
		
			request_str = Listing.get_lineup_info_uri item
			response = HTTParty.get(request_str)
			lineup_data = JSON.parse(response.body)
			new_lineup = Lineup.create(l_id: lineup_data['lineupID'], lineup_name: lineup_data['lineupName'], lineup_type: lineup_data['lineupType'], provider_id: lineup_data['providerID'], provider_name: lineup_data['providerName'], service_area: lineup_data['serviceArea'], country: lineup_data['country'])
			
			lineup_data['stations'].each do |st|
				if Station.find_by(s_id: st['stationID'], s_number: st['number']).blank? && (FAVORITE_CHANNELS[index].include? st['number'])
					new_station = Station.create(s_number: st['number'], channel_number: st['channelNumber'], sub_channel_number: st['subChannelNumber'], s_id: st['stationID'], name: st['name'], callsign: st['callsign'], network: st['network'], station_type: st['stationType'], ntsc_tsid: st['NTSC_TSID'], dtv_tsid: st['DTV_TSID'], twitter: st['Twitter'], weblink: st['webLink'], logo_file_name: st['logoFilename'], station_hd: st['stationHD'])
					new_lineup.stations << new_station	
				end
				
			end

		end	
	end

	utc_start_t = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)
	utc_start = utc_start_t
	utc_one_day_ago = utc_start - 1.day
	utc_one_day_ago_t = utc_one_day_ago
	utc_two_days_ago = utc_start - 2.days

	if Listing.where("updated_date = ?", utc_start_t.strftime('%Y-%m-%d %H:%M:%S')).first.nil?
		FAVORITE_LINEUPS.each_with_index do |it, index|
			relative_stations = Lineup.find_by(l_id: it).stations
			stations_uri = ''

			if relative_stations.blank?
				next
			else
				relative_stations.each_with_index do |s, s_index|
					if index == relative_stations.length - 1
						stations_uri = stations_uri + s[:s_id].to_s
					else
						stations_uri = stations_uri + s[:s_id].to_s + '%2C'
					end
				end
			end		

			utc_end = utc_start_t + (60 * 60 * 24 * 14)
			utc_start = Listing.format_time utc_start_t
			utc_end   = Listing.format_time utc_end
			request_str = Listing.get_lineup_tv_listings it
			
			request_str = request_str + 'start=' + utc_start + '&end=' + utc_end + '&station=' + stations_uri + '&pretty=1'
			
			begin
				response = HTTParty.get(request_str, timeout: 3000)
			rescue Net::ReadTimeout
				nil
			end

			begin
				tmp = JSON.parse(response.body)	
			rescue Exception => e
				puts e.message
				return
			end
			
			tmp.each do |item| 
				Listing.create(s_number: item['number'], channel_number: item['channelNumber'], sub_channel_number: item['subChannelNumber'], s_id: item['stationID'], callsign: item['callsign'], logo_file_name: item['logoFilename'], list_date_time: item['listDateTime'], duration: item['duration'], show_id: item['showID'], series_id: item['seriesID'], show_name: item['showName'], episode_title: item['episodeTitle'], repeat: item['repeat'], new: item['new'], live: item['live'], hd: item['hd'], descriptive_video: item['descriptiveVideo'], in_progress: item['inProgress'], show_type: item['showType'], star_rating: item['starRating'], description: item['description'], league: item['league'], team1: item['team1'], team2: item['team2'], show_picture: item['showPicture'], l_id: it, updated_date: utc_start_t, web_link: item['webLink'], name: item['name'], station_type: item['stationType'], listing_id: item['listingID'], episode_number: item['episodeNumber'], parts: item['parts'], part_num: item['partNum'], series_premiere: item['seriesPremiere'], season_premiere: item['seasonPremiere'], series_finale: item['seriesFinale'], season_finale: item['seasonFinale'], rating: item['rating'], guest: item['guest'], director: item['director'], location: item['location'])
			end
		end
	end

	if Listing.where("updated_date = ?", utc_one_day_ago_t.strftime('%Y-%m-%d %H:%M:%S')).first.nil?
		FAVORITE_LINEUPS.each_with_index do |it, index|
			relative_stations = Lineup.find_by(l_id: it).stations
			stations_uri = ''

			if relative_stations.blank?
				next
			else
				relative_stations.each_with_index do |s, s_index|
					if index == relative_stations.length - 1
						stations_uri = stations_uri + s[:s_id].to_s
					else
						stations_uri = stations_uri + s[:s_id].to_s + '%2C'
					end
				end
			end		
			
			utc_end = utc_one_day_ago_t + (60 * 60 * 24 * 14)
			utc_one_day_ago = Listing.format_time utc_one_day_ago_t
			utc_end   = Listing.format_time utc_end

			request_str = Listing.get_lineup_tv_listings it
			request_str = request_str + 'start=' + utc_one_day_ago + '&end=' + utc_end + '&station=' + stations_uri + '&pretty=1'

			begin
				response = HTTParty.get(request_str, timeout: 3000)
			rescue Net::ReadTimeout
				nil
			end

			tmp = JSON.parse(response.body)
			
			tmp.each do |item| 
				Listing.create(s_number: item['number'], channel_number: item['channelNumber'], sub_channel_number: item['subChannelNumber'], s_id: item['stationID'], callsign: item['callsign'], logo_file_name: item['logoFilename'], list_date_time: item['listDateTime'], duration: item['duration'], show_id: item['showID'], series_id: item['seriesID'], show_name: item['showName'], episode_title: item['episodeTitle'], repeat: item['repeat'], new: item['new'], live: item['live'], hd: item['hd'], descriptive_video: item['descriptiveVideo'], in_progress: item['inProgress'], show_type: item['showType'], star_rating: item['starRating'], description: item['description'], league: item['league'], team1: item['team1'], team2: item['team2'], show_picture: item['showPicture'], l_id: it, updated_date: utc_one_day_ago_t, web_link: item['webLink'], name: item['name'], station_type: item['stationType'], listing_id: item['listingID'], episode_number: item['episodeNumber'], parts: item['parts'], part_num: item['partNum'], series_premiere: item['seriesPremiere'], season_premiere: item['seasonPremiere'], series_finale: item['seriesFinale'], season_finale: item['seasonFinale'], rating: item['rating'], guest: item['guest'], director: item['director'], location: item['location'])
			end
		end	
	end

	Listing.where("updated_date <= ?", utc_two_days_ago.strftime('%Y-%m-%d %H:%M:%S')).destroy_all
end
