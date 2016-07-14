$(document).ready(function(){
	var tv_listing;
	var start_t;
	var channel_list;
	var all_channels;
	var preference;
	var media_numbers;

	function init_date_picker() {
		var tmp_html = '';	
		var loop_date = moment(start_t);

		for (var i = 0; i < 14; i++) {
			tmp_html = tmp_html + "<option value='" + loop_date.format('YYYY-MM-DD HH:mm:ss Z') + "'>" + loop_date.format("dddd, MMM D") + "</option>";
			loop_date = moment(loop_date).add(1, 'day');
		}

		$('#listings-date-picker-date-select').html(tmp_html);

		$('#listings-date-picker-date-select option[value="' + moment(start_t).format('YYYY-MM-DD HH:mm:ss Z') + '"]').attr("selected", "selected");
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

	function click_for_detail() {
		var c_list_id = $(this).attr('data-list-id');
		var ch_html;
		var pro_html;
		var web_link = 'http://n2me-web.herokuapp.com/media/';
		web_link = web_link + media_numbers[tv_listing[c_list_id].s_number]

		ch_html = '<span><img src="https://cdn.tvpassport.com/image/station/100x100/' + tv_listing[c_list_id].logo_file_name + '" style="width: 100px; height: 100px"></span><span class="listings-channel-number-name"><span class="listings-channel-number-name-inner"><span class="listings-channel-number">' + tv_listing[c_list_id].s_number + '</span><span class="listings-channel-name">' + tv_listing[c_list_id].callsign + '</span></span></span><a href="' + web_link + '" class="custom btn btn-primary btn-lg gradient pull-right"><i class="fa fa-desktop fa-fw listings-button-icon"></i> WATCH LIVE</a>';

		$('#pro_info .channel-info').html(ch_html);

		pro_html = "<div><span style='font-size: 20px'>" + (tv_listing[c_list_id].episode_title == '' ? tv_listing[c_list_id].show_name : tv_listing[c_list_id].episode_title) + "</span><span class='pull-right " + (tv_listing[c_list_id].new == true ? 'tag' : '') + "'>" + (tv_listing[c_list_id].new == true ? 'NEW' : '') + "</span><span class='pull-right " + (tv_listing[c_list_id].live == true ? 'tag' : '') + "'>" + (tv_listing[c_list_id].live == true ? 'LIVE' : '') + "</span><span class='pull-right " + (tv_listing[c_list_id].rating == '' ? '' : 'tag') + "'>" + tv_listing[c_list_id].rating + "</span></div>"

		pro_html = pro_html + "<div style='margin-top: 15px'>Air Time: " + moment(tv_listing[c_list_id].list_date_time).format('h:mm A') + " (" + moment.duration(tv_listing[c_list_id].duration, "minutes").format("h [hr] m [min]") + ")" + "</div>";
		pro_html = pro_html + "<div style='margin-top: 15px'>" + tv_listing[c_list_id].description + "</div>";

		// if(moment().diff(moment(tv_listing[c_list_id].list_date_time).add(tv_listing[c_list_id].duration, 'm')) < 0) {
		// 	pro_html = pro_html + "<div style='margin-top: 15px'><button type='button' class='btn btn-primary' style='margin-right: 20px'>WATCHLIST</button><button type='button' class='btn btn-danger'>RECORD</button></div>";
		// }
		$('#pro_info .pro-info').html(pro_html);

		$('#pro_info').modal('show');
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

	function initialize() {
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#utc_locale').val(moment().utcOffset());

		// tv_listing = <"%= raw @tv_listing.to_json %>";
		// start_t = "<%= raw @start_t %>"
		// all_channels = "<%= raw @all_channels.to_json %>";
		// channel_list = "<%= raw @favorite_channels.to_json %>";
		// preference 	  = "<%= raw @preference.to_json %>";
		// media_numbers = "<%= raw MEDIA_NUMBERS.to_json %>";

		start_t 	  = gon.start_t;
		all_channels  = gon.all_channels;
		tv_listing 	  = gon.tv_listing;
		channel_list  = gon.favorite_channels;
		media_numbers = gon.media_numbers;
		preference 	  = gon.preference;

		init_date_picker();
		$('.listings-picker-select').attr('disabled', 'disabled');
		$('#listings-date-time-picker-go').attr('disabled', 'disabled');
		$("#listings-date-picker-date-select").select2({width: '100%'});
		$("#listings-date-picker-time-select").select2({width: '65%'});

		$('.date-board p').html(gon.search_word);

		display_favorite_channels();
	}

	initialize();

	function display_tv_listing() {
		var tmp_html = '';
		if(tv_listing.length == 0) {
			tmp_html = tmp_html + '<div class="center">No data to display</div>';
			$('#yield-area').addClass('no-data-board');
		} else {
			tmp_html = tmp_html + '<ul>';
			var loop_date = moment(tv_listing[0].list_date_time).set({'hour': 0, 'minute': 0, 'second': 0});
			tmp_html = tmp_html + "<li class='listings-timebar'>" + loop_date.format('dddd, MMMM D, YYYY') + "</li>"

			for (var i in tv_listing) {
				if(loop_date.diff(moment(tv_listing[i].list_date_time).set({'hour': 0, 'minute': 0, 'second': 0})) != 0) {
					loop_date = moment(tv_listing[i].list_date_time).set({'hour': 0, 'minute': 0, 'second': 0});
					tmp_html = tmp_html + "<li class='listings-timebar'>" + loop_date.format('dddd, MMMM D, YYYY') + "</li>"

				} 

				tmp_html =  tmp_html + '<li data-channel-number="' + tv_listing[i].channel_number + '" data-channel-source="' + tv_listing[i].s_id + '" data-channel-name="' + tv_listing[i].callsign + '"><a href="' + tv_listing[i].web_link + '" class="listings-channel"><span><img src="https://cdn.tvpassport.com/image/station/100x100/' + tv_listing[i].logo_file_name + '" style="width: 30px; height: 20px"></span><span class="listings-channel-number-name"><span class="listings-channel-number-name-inner"><span class="listings-channel-number">' + tv_listing[i].s_number + '</span><span class="listings-channel-name">' + tv_listing[i].callsign + '</span></span></span></a><a href="#" class="listings-program" data-callsign="' + tv_listing[i].callsign + '" data-chan-num="' + tv_listing[i].s_number + '" data-list-id="' + i + '"><span class="listings-program-inner"><span class="listings-program-title truncate">' + tv_listing[i].episode_title + '</span><span class="listings-program-time">' + moment(tv_listing[i].list_date_time).format('h:mm A') + ' (' + moment.duration(tv_listing[i].duration, "minutes").format("h [hr] m [min]") + ')</span></span></a></li>';
			}

			tmp_html = tmp_html + '</ul>';
		}

		
		$('#yield-area').html(tmp_html);
	}

	display_tv_listing();
	
	$('#listings-search-submit').on("click", function(){
		if($("#listings-search-term").val() == '') return;
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#search_word').val(gon.search_word);

		$('#tvForm').attr("action", "show");
		$('#tvForm').submit();
	});

	$('#gridSystemModal .btn-primary').on('click', function(){
		$('#favorite_changed').val(true);
		$('#search_word').val(gon.search_word);
		$('#gridSystemModal').modal('hide');
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#tvForm').attr("action", "show");
		$('#tvForm').submit();	
	});

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

	$('.listings-program').on('click', click_for_detail);

	$('#listings-preferences-button').on('click', display_preference);

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
		$('#search_word').val(gon.search_word);			

		$('#st_filter_hidden').val(st_filter_str);
		$('#tvForm').attr("action", "show");

		$('#tvForm').submit();	
	});

	$('#listings-search-term').on('keypress', function(event) {
		if($("#listings-search-term").val() == '' || event.keyCode != 13) return;
		$('#cur_now').val(moment().format('YYYY-MM-DD HH:mm:ss Z'));
		$('#search_word').val(gon.search_word);

		$('#tvForm').attr("action", "show");
		$('#tvForm').submit();
	});
});