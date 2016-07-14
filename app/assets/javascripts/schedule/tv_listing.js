$(document).ready(function(){
		
	// ---- Start: Declaration of variables
	var js_tv_list;		
	var start_t;
	var search_time;
	var search_date_t;
	var tv_listing;		
	var channel_list;
	var select_time_val;
	var start_chan;
	var end_chan;
	var base_start_t; 
	var base_end_t;
	var all_channels;
	var media_numbers;
	var preference;
	var time_span;
	var grid_height;
	var selected_channel;
	// ---- End: Declaration of variables

	function init_date_picker() {
		var tmp_html = '';	
		var loop_date = moment(start_t);

		for (var i = 0; i < 14; i++) {
			tmp_html = tmp_html + "<option value='" + loop_date.format('YYYY-MM-DD HH:mm:ss Z') + "'>" + loop_date.format("dddd, MMM D") + "</option>";
			loop_date = moment(loop_date).add(1, 'day');
		}

		$('#listings-date-picker-date-select').html(tmp_html);

		$('#listings-date-picker-date-select option[value="' + moment(search_date_t).format('YYYY-MM-DD HH:mm:ss Z') + '"]').attr("selected", "selected");
	}

	function init_time_picker() {
		$('#listings-date-picker-time-select option[value="' + select_time_val + '"]').attr("selected", "selected");
	}

	function display_favorite_channels() {
		var tmp_html = '';
		
		for (var i = 0; i < all_channels.length; i++) {
			var glyphicon;
			var val;
			glyphicon = 'glyphicon-plus';
			val = false;

			for(var j = 0; j < channel_list.length; j++) {
				if((channel_list[j].s_number == all_channels[i].s_number) && (channel_list[j].s_id == all_channels[i].s_id)) {
					glyphicon = 'glyphicon-ok';
					val = true;
					break;
				}
			}

			tmp_html = tmp_html + '<div class="col-md-12 row-padding" data-callsign="' + all_channels[i].callsign + '" data-s-num="' + all_channels[i].s_number + '"><span style="margin-right: 10px"><img src="https://cdn.tvpassport.com/image/station/100x100/' + all_channels[i].logo_file_name + '" style="width: 30px; height: 20px"></span><span class="keys">' + all_channels[i].callsign + '</span><span class="keys"> ' + all_channels[i].s_number + '</span><span class="pull-right glyphicon ' + glyphicon + '"></span><input type="hidden" name="status[' + all_channels[i].s_id.toString() + '_' + all_channels[i].s_number + ']" value=' + val + '></div>';	
		}

		$('#searchable-container').html(tmp_html);

		$('#searchable-container .glyphicon').on('click', function(){
			if($(this).hasClass('glyphicon-ok')) {
				$(this).removeClass('glyphicon-ok');
				$(this).addClass('glyphicon-plus');
				$(this).parent().find("input").attr('value', false);
			} else {
				$(this).removeClass('glyphicon-plus');
				$(this).addClass('glyphicon-ok');	
				$(this).parent().find("input").attr('value', true);
			}	
		});
		$('#searchable-container', $("#gridSystemModal")).searchable({
	        searchField: '#container-search',
	        selector: '.col-md-12.row-padding',
	        childSelector: 'span.keys',
	        show: function( elem ) {
	            elem.slideDown(100);
	        },
	        hide: function( elem ) {
	            elem.slideUp( 100 );
	        }
	    });
	}

	function display_preference() {
		$("#grid_preferences input[name='initial_time'][value='" + preference.initial_time + "']").prop('checked', true);
		$("#grid_preferences input[name='time_span'][value='" + preference.time_span + "']").prop('checked', true);
		$("#grid_preferences input[name='grid_height'][value='" + preference.grid_height + "']").prop('checked', true);

		$("#grid_preferences input[name='station_filter']").each(function(){
			$(this).prop('checked', false);	
		});
		var arr = preference.station_filter.split(',');
		for(var i in arr) {
			$("#grid_preferences input[name='station_filter'][value='" + arr[i] + "']").prop('checked', true);		
		}

	}

	function mark_played_channel(data_src) {
		$('.play-icon').remove();
		$('.backcolor-played').addClass('backcolor-origin');
		$('.backcolor-played').removeClass('backcolor-played');
		$('#' + data_src + ' .channel-board').removeClass('backcolor-origin');
		$('#' + data_src + ' .channel-board').addClass('backcolor-played');
		var tmp_html = "<div class='pull-right play-icon'><i class='fa fa-play fa-3x'></i></div>";
		$('#' + data_src + ' .channel-board').append(tmp_html);
	}

	function initialize() {
		$('#utc_locale').val(moment().utcOffset());
		
		js_tv_list = {}; 
		// start_t 		= "<%= raw @start_t %>";
		// search_time 	= "<%= raw @search_time %>";
		// search_date_t 	= "<%= raw @search_date_t %>";
		// select_time_val = "<%= raw @select_time_val %>";

		// all_channels  = <%= raw @all_channels.to_json %>;
		// tv_listing 	  = <%= raw @tv_listing.to_json %>;
		// channel_list  = <%= raw @favorite_channels.to_json %>;
		// media_numbers = <%= raw MEDIA_NUMBERS.to_json %>;
		// preference 	  = <%= raw @preference.to_json %>;
		start_t 		= gon.start_t;
		search_time 	= gon.search_time;
		search_date_t 	= gon.search_date_t;
		select_time_val = gon.select_time_val;

		all_channels  = gon.all_channels;
		tv_listing 	  = gon.tv_listing;
		channel_list  = gon.favorite_channels;
		media_numbers = gon.media_numbers;
		preference 	  = gon.preference;

		time_span 	  = parseInt(preference.time_span);
		grid_height	  = parseInt(preference.grid_height);

		start_chan = 0;
		end_chan   = grid_height - 1;

		init_date_picker();
		init_time_picker();
		$("#listings-date-picker-date-select").select2({width: '100%'});
		$("#listings-date-picker-time-select").select2({width: '65%'});

		$('.grid-view').css('height', 100 * grid_height);
		$(".side-arrow-board").each(function() {
			$(this).css('height', 170 + 100 * grid_height);
		});

		channel_list.forEach(function(channel){
			if (Object.keys(js_tv_list).indexOf(channel.callsign) === -1) {
				js_tv_list[channel.callsign] = [];
			}

			js_tv_list[channel.callsign][channel.s_number.toString()] = [];
		});

		tv_listing.forEach(function(tv_channel) {

			js_tv_list[tv_channel.callsign][tv_channel.s_number.toString()].push(tv_channel);
		});
		
		
		if(channel_list.length < grid_height) end_chan = channel_list.length - 1;

		start_t = moment(start_t);
		search_date_t = moment(search_date_t);
		if(moment(search_time).hour() > 21)
			search_time = moment(search_time).hour(21);
		else
			search_time   = moment(search_time);
		end_t = moment(search_time).add(time_span, 'h');

		display_favorite_channels();
		// display_preference();
	}

	initialize();

			
	$('.date-board span').html("Listings for " + moment(search_date_t).format("Do MMMM")); 

	base_start_t = moment(search_date_t); 
	base_end_t   = moment(base_start_t).add(24, 'h');

	function display_time_board(){
		var display_time = moment(search_time);
		var tmp_html = '';

		for(var i = 0; i < time_span; i++) {
			tmp_html = tmp_html + '<div class="col-xs-' + (12 / time_span) + ' each-time"><span class="time">' + moment(display_time).format("h") + '</span><span class="twelve">' + display_time.format("A") + '</span></div>';
			display_time = moment(display_time).add(1, 'h');
		}

		$('.time-board').html(tmp_html);

		// $('.time-board .each-time').each(function(){
		// 	$(this).find('.time').html(moment(display_time).format("h"));
		// 	$(this).find('.twelve').html(display_time.format("A"));
		// 	display_time = moment(display_time).add(1, 'h');
		// });
	}

	display_time_board();
	
	function display_tv_listing(start, end) {
		$('.grid-view').html('');

		for(var c = start; c <= end; c++) {
			var channel = js_tv_list[channel_list[c].callsign][channel_list[c].s_number];
			var cur_t;
			var next_t;
			var web_link = 'http://n2me-web.herokuapp.com/media/';

			// if(channel_list[c].weblink == "") 
			// 	web_link = "#"
			// else
			// 	web_link = channel_list[c].weblink;
			web_link = web_link + media_numbers[channel_list[c].s_number]

			// var tmp_html = "<div class='row' id='" + channel_list[c].s_id.toString() + "_" + channel_list[c].s_number + "'><div class='col-xs-3 channel-board'><div class='channel_info'><p class='channel_name'>" + channel_list[c].callsign + "</p><span>" + channel_list[c].s_number + "</span><p><a href='" + web_link + "'>watch now</a></p></div></div><div class='col-xs-9 program-board'></div></div>";
			var tmp_html = "<div class='row' id='" + channel_list[c].s_id.toString() + "_" + channel_list[c].s_number + "'><div class='col-xs-3 channel-board backcolor-origin'><div class='channel_info'><p class='channel_name'>" + channel_list[c].callsign + "</p><span>" + channel_list[c].s_number + "</span><p><a data-media-num=" + media_numbers[channel_list[c].s_number] + " data-src='" + channel_list[c].s_id.toString() + "_" + channel_list[c].s_number + "'>watch now</a></p></div></div><div class='col-xs-9 program-board'></div></div>";

			$(tmp_html).appendTo(".grid-view");

			for(var i in channel)
			{
				cur_t = moment(channel[i].locale_time, "YYYY-MM-DD HH:mm:ss");
				next_t = moment(cur_t).add(channel[i].duration, 'm');
				
			    if(next_t.diff(search_time) > 0 && cur_t.diff(end_t) < 0) {
			    	if(cur_t.diff(search_time) < 0) cur_t = moment(search_time, "YYYY-MM-DD HH:mm:ss");
			    	var tmp_html;
			    	var div_width_percent;
			    	var right_border = '';
			    	if(next_t.diff(end_t) >= 0) {
			    		div_width_percent = end_t.diff(cur_t, "m") / (60.0 * time_span) * 100;
			    	}
			    	else {
			    		div_width_percent = next_t.diff(cur_t, "m") / (60.0 * time_span) * 100;   	
			    		right_border = ' right-border';	
			    	}
			    	tmp_html = "<div class='pull-left" + right_border + "' style='width: " + div_width_percent + "%'><a href='#' class='for-detail' data-target='#pro_info' data-callsign='" + channel_list[c].callsign + "' data-chan-num='" + channel_list[c].s_number + "' data-list-id='" + i + "'><p class='show-type truncate'>" + channel[i].show_type + "</p><p class='episode-title truncate'>" + channel[i].episode_title + "</p><p class='duration truncate'>" + moment(channel[i].locale_time, "YYYY-MM-DD HH:mm:ss").format('h:mmA') + "-" + moment(next_t).format('h:mmA') + "</p></a></div>";

			    	$(tmp_html).appendTo('#' + channel_list[c].s_id.toString() + "_" + channel_list[c].s_number + ' .program-board');
			    }
			}
		};
	};
	
	display_tv_listing(start_chan, end_chan);


	function clear_program_board(start, end) {
		for(var c = start; c <= end; c++) {
			$('#' + channel_list[c].s_id.toString() + "_" + channel_list[c].s_number + ' .program-board').html('');
		};	
	};

	// When clicking left arrow link, it will display tv listing one hour ago from current time
	$('.glyphicon-triangle-left').click(function(){
		
		if(base_start_t.diff(search_time) == 0) return;
		
		search_time = moment(search_time).subtract(1, 'h');
		end_t 	= moment(end_t).subtract(1, 'h');
		
		clear_program_board(start_chan, end_chan);
		display_time_board();
		display_tv_listing(start_chan, end_chan);	
		$('.program-board .for-detail').on('click', click_for_detail);		
	});

	// When clicking right arrow link, it will display tv listing one hour after from current time
	$('.glyphicon-triangle-right').click(function(){
		if(base_end_t.diff(end_t) == 0) return;
		search_time = moment(search_time).add(1, 'h');
		end_t 	= moment(end_t).add(1, 'h');

		clear_program_board(start_chan, end_chan);
		display_time_board();
		display_tv_listing(start_chan, end_chan);
		$('.program-board .for-detail').on('click', click_for_detail);
	});	

	// When clicking top arrow link, it will move to the previous page
	$('.glyphicon-triangle-top').click(function(){
		if(start_chan == 0) return;

		start_chan = start_chan - grid_height;
		end_chan = end_chan - (end_chan % grid_height) - 1;
		
		clear_program_board(start_chan, end_chan);
		display_time_board();
		display_tv_listing(start_chan, end_chan);
		mark_played_channel(selected_channel);
		$('.program-board .for-detail').on('click', click_for_detail);
		$('.channel-board .channel_info a').on('click', play_video_feed);
	});	

	// When clicking bottom arrow link, it will move to the next page
	$('.glyphicon-triangle-bottom').click(function(){
		if(end_chan == channel_list.length - 1) return;

		start_chan = start_chan + grid_height;
		if(end_chan +  grid_height > channel_list.length) 
			end_chan = channel_list.length - 1;
		else
			end_chan = end_chan + grid_height;

		clear_program_board(start_chan, end_chan);
		display_time_board();
		display_tv_listing(start_chan, end_chan);
		mark_played_channel(selected_channel);
		$('.program-board .for-detail').on('click', click_for_detail);
		$('.channel-board .channel_info a').on('click', play_video_feed);
	});		


	$('#listings-search-submit').on("click", function(){
		if($("#listings-search-term").val() == '') return;
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#tvForm').attr("action", "schedule/show");
		$('#tvForm').submit();
	});

	// When clicking 'GO' button for search with date and time, it will submit form data to the back-end
	$("#listings-date-time-picker-go").click(function(){
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#tvForm').submit();
	});

	$('.listings-favorites-bulk-add').on('click', function(event){
		event.preventDefault();
		$('#searchable-container .glyphicon').each(function(){
			if($(this).hasClass('glyphicon-plus')) {
				$(this).removeClass('glyphicon-plus');
				$(this).addClass('glyphicon-ok');
				$(this).parent().find("input").attr('value', true);
			}
		});	
	});


	$('.listings-favorites-bulk-remove').on('click', function(event){
		event.preventDefault();
		$('#searchable-container .glyphicon').each(function(){
			if($(this).hasClass('glyphicon-ok')) {
				$(this).removeClass('glyphicon-ok');
				$(this).addClass('glyphicon-plus');
				$(this).parent().find("input").attr('value', false);
			}
		});	
	});


	function click_for_detail() {
		var id = $(this).attr('data-callsign');
		var c_n = $(this).attr('data-chan-num');
		var c_list_id = $(this).attr('data-list-id');
		var ch_html;
		var pro_html;
		var web_link = 'http://n2me-web.herokuapp.com/media/';
		web_link = web_link + media_numbers[js_tv_list[id][c_n][c_list_id].s_number]

		ch_html = '<span><img src="https://cdn.tvpassport.com/image/station/100x100/' + js_tv_list[id][c_n][c_list_id].logo_file_name + '" style="width: 100px; height: 100px"></span><span class="listings-channel-number-name"><span class="listings-channel-number-name-inner"><span class="listings-channel-number">' + js_tv_list[id][c_n][c_list_id].s_number + '</span><span class="listings-channel-name">' + js_tv_list[id][c_n][c_list_id].callsign + '</span></span></span><a href="' + web_link + '" class="custom btn btn-primary btn-lg gradient pull-right"><i class="fa fa-desktop fa-fw listings-button-icon"></i> WATCH LIVE</a>';
		
		$('#pro_info .channel-info').html(ch_html);

		pro_html = "<div><span style='font-size: 20px'>" + (js_tv_list[id][c_n][c_list_id].episode_title == '' ? js_tv_list[id][c_n][c_list_id].show_name : js_tv_list[id][c_n][c_list_id].episode_title) + "</span><span class='pull-right " + (js_tv_list[id][c_n][c_list_id].new == true ? 'tag' : '') + "'>" + (js_tv_list[id][c_n][c_list_id].new == true ? 'NEW' : '') + "</span><span class='pull-right " + (js_tv_list[id][c_n][c_list_id].live == true ? 'tag' : '') + "'>" + (js_tv_list[id][c_n][c_list_id].live == true ? 'LIVE' : '') + "</span><span class='pull-right " + (js_tv_list[id][c_n][c_list_id].rating == '' ? '' : 'tag') + "'>" + js_tv_list[id][c_n][c_list_id].rating + "</span></div>"

		pro_html = pro_html + "<div style='margin-top: 15px'>Air Time: " + moment(js_tv_list[id][c_n][c_list_id].locale_time, "YYYY-MM-DD HH:mm:ss").format('h:mm A') + " (" + moment.duration(js_tv_list[id][c_n][c_list_id].duration, "minutes").format("h [hr] m [min]") + ")" + "</div>";
		pro_html = pro_html + "<div style='margin-top: 15px'>" + js_tv_list[id][c_n][c_list_id].description + "</div>";

		// if(moment().diff(moment(js_tv_list[id][c_n][c_list_id].list_date_time).add(js_tv_list[id][c_n][c_list_id].duration, 'm')) < 0) {
		// 	pro_html = pro_html + "<div style='margin-top: 15px'><button type='button' class='btn btn-primary' style='margin-right: 20px'>WATCHLIST</button><button type='button' class='btn btn-danger'>RECORD</button></div>";
		// }
		$('#pro_info .pro-info').html(pro_html);

		$('#pro_info').modal('show');
	}

	

	$('.program-board .for-detail').on('click', click_for_detail);

	$('#listings-favorites-button').on('click', function() {
		$('#searchable-container .col-md-12.row-padding').each(function(){
			var exist = false;
			for(var i = 0; i < channel_list.length; i++) {
				if(channel_list[i].callsign == $(this).attr('data-callsign') && channel_list[i].s_number == $(this).attr('data-s-num')) {
					exist = true;
					break;
				}
			}

			if(exist) {
				$(this).find('span:nth-child(4)').attr('class', 'pull-right glyphicon glyphicon-ok');
			} else {
				$(this).find('span:nth-child(4)').attr('class', 'pull-right glyphicon glyphicon-plus');
			}
		});	
	});

	// $('#listings-preferences-button').on('click', function(){
	// 	$("#grid_preferences input[name$='initial_time'][value='" + preference.initial_time + "']").prop('checked', true);
	// 	$("#grid_preferences input[name$='time_span'][value='" + preference.time_span + "']").prop('checked', true);
	// 	$("#grid_preferences input[name$='grid_height'][value='" + preference.grid_height + "']").prop('checked', true);
	// });

	$('#listings-preferences-button').on('click', display_preference);

	$('#gridSystemModal .btn-primary').on('click', function(){
		$('#favorite_changed').val(true);
		$('#gridSystemModal').modal('hide');
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#tvForm').submit();	
	});

	$('#grid_preferences .btn-primary').on('click', function(){
		var st_filter_arr = [];
		$("#grid_preferences input[name='station_filter']:checked").each(function(){
			st_filter_arr.push($(this).val());
		});
		var st_filter_str = st_filter_arr.join(",");
		if(st_filter_str == preference.station_filter && $("#grid_preferences input[name='initial_time']:checked").val() == preference.initial_time && $("#grid_preferences input[name='time_span']:checked").val() == preference.time_span && $("#grid_preferences input[name='grid_height']:checked").val() == preference.grid_height) {
			$('#grid_preferences').modal('hide');
			return;
		}

		$('#preference_changed').val(true);
		$('#grid_preferences').modal('hide');
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		
		$('#st_filter_hidden').val(st_filter_str);
		$('#tvForm').submit();	
	});

	$('#listings-search-term').on('keypress', function(event) {
		if($("#listings-search-term").val() == '' || event.keyCode != 13) return;
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#tvForm').attr("action", "schedule/show");
		$('#tvForm').submit();	
	});

	function play_video_feed() {
		var media_number = $(this).attr('data-media-num');
		selected_channel = $(this).attr('data-src');
		// event.preventDefault();
		return $.ajax({
		    url: "schedule/video_feed?number=" + media_number,
		    dataType : "html",
		    type: "GET",
		    success: function(data, event, status, xhr) {
		    	$('.video-area').html(data);
				mark_played_channel(selected_channel);	 	
	      	},
	      	error: function(event, data, status, xhr) {
	      
	      	}
		});		
	}

	$('.channel-board .channel_info a').on('click', play_video_feed);
});