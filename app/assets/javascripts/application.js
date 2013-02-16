// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.button
//= require jquery.ui.datepicker
//= require jquery.ui.mouse
//= require jquery.ui.dialog
//= require jquery.ui.effect-fade
//= require jquery.ui.selectable
//= require jquery.ui.sortable
//= require jquery.ui.tooltip
//= require_tree .
$(document).ready(function(){
	$(".chzn-select").chosen();	
	var pretty = $('.pretty').html();
	
	var accounttype1 = $('#accounttype').html();
	if (accounttype1 != 'Temp'){
		$('#trial').hide();
	}
	/*
	if (pretty != undefined){
		$('.pretty').tooltip({ 
			track: true, 
			delay: 0, 
			showURL: false, 
			showBody: " - ", 
			extraClass: "pretty fancy", 
			fixPNG: true, 
			opacity: 0.95, 
			left: -120 
		});	
	}
	*/
	

	bodywidth =  $(window).width();
	bodyheight =  $(window).height();
	bodysize = bodywidth+'px '+bodyheight+'px';
	console.log(bodysize);
	//$('body').css('background', 'url("/assets/background3.jpg") left top fixed').css('background-size', bodysize);
	
	$(document).mousemove(function(e){
	var w = $('ul').width();
	 $('#position').html("X Axis : " + e.pageX + " Y Axis : " + e.pageY +'  width:'+w+' center: '+w/2+'  vwidth:'+bodywidth+' bcenter: '+bodywidth/2);
	});
	
	
	
	$('#centralnav').fadeTo(0,0);
	
	$(document).on('mouseover','#centralnav', function(){
		$(this).fadeTo(0,1);
	});
	
	$(document).on('mouseout' ,'#centralnav', function(){
		$(this).fadeTo(0,0);
	});
	
	
	$(document).on('hover','.cnav', function(){
		$(this).css('opacity', '0.7');
		
	});
	
	$(document).on('mouseout','.cnav', function(){
		$(this).css('opacity', '0.6');
	});	
	
	
	$(document).on('mouseover','.actions input', function(){
		var data = $(this).attr('data');
		$(this).attr('src', '/assets/'+data+'-over.png');
	});
	
	$(document).on('mouseout','.actions input', function(){
		var data = $(this).attr('data');
		$(this).attr('src', '/assets/'+data+'.png');
	});
	
	$(document).on('click', '.actions input', function(){
		var data = $(this).attr('data');
		$(this).attr('src', '/assets/'+data+'-over.png');
	});
	
	

	var analysis_img = $('#analysis_img').html();
	if (analysis_img != undefined){
		if (bodywidth>=1250 && bodywidth<1400){
			$('#analysis_img').css('left', bodywidth/2-175).css('top', bodyheight/2);
			$('#analysis_img').children('img').css('width','250px').css('height', '250px');
		}
		else if (bodywidth>=800 && bodywidth<1000){
			$('#analysis_img').css('left', bodywidth/2-120).css('top', bodyheight/2);
			$('#analysis_img').children('img').css('width','250px').css('height', '250px');
			$('.identifier').css('font-weight', 'normal');
		}
		else if (bodywidth>=1400){
			$('#analysis_img').css('left', bodywidth/2-150).css('top', bodyheight/2-50);
			$('#analysis_img').children('img').css('width','300px').css('height', '300px');
		}
	}
	
	var json = '';
	var playerkey = new Array();
	var playerid = new Array();
	var playername = new Array();
	var player = new Array();
	var removable_playerkey = new Array();
	var removable_playername = new Array();
	var removable_playerid = new Array();
	
	if($('#country_select option:selected').val() == -2) {
		$('.player').hide();
	}
	
	$('#country_select').change(function(){
		countrykey = $('#country_select option:selected').val();
		formatkey = $('#format_select option:selected').val();
		$('.player').hide();
		players = $('[data-country="'+countrykey+'"]');
		console.log(players);
		console.log(formatkey);
		players.each(function(){
			if ( $(this).attr('data-format')== formatkey  ){
				//console.log($(this).parent());
				$(this).parent().show();
			}
		
		});
	});
	
	
	$('#format_select').change(function(){
		countrykey = $('#country_select option:selected').val();
		formatkey =  $('#format_select option:selected').val();
		$('.player').hide();
		players = $('[data-country="'+$('#country_select option:selected').val()+'"]');
		console.log(players);
		console.log(formatkey);
		players.each(function(){
			if ( $(this).attr('data-format')== formatkey  ){
				$(this).parent().show();
			}
		
		});
	});
	
	
    $('.selection_window').selectable({
        filter:'tr',
        selected: function(event, ui){
			data = ($(this).find('.ui-selected'));
			$.each(data, function(index, element){
					playerkey[index]=$(element).find('[data-id]').attr('data-id');
					playerid[index]=$(element).find('.playerid').html();
					playername[index] = $(element).find('[data-id]').html();
					player[index] = new Array();
					player[index][0] = playerkey[index]
					player[index][1] = playername[index]
					player[index][2] = playerid[index]
			});
			            
        }
	});
	
	
	$(document).on("click" ,'#intheteam', function(){
		$.each(player, function(index, player){
			$('#removable_players_table').append('<tr><td class="removable_playerid">'+player[2]+'</td><td class="removable_playername" data-pid="'+player[2]+'">'+player[1]+'</td></tr>');
			$('[data-id="'+player[2]+'"]').parent().hide();
		});
		player = new Array();
	});
	
	
    $('.selected_window').selectable({
        filter:'tr',
        selected: function(event, ui){
		
			$.each(playerkey, function(index, playerkey){
				removable_playerkey=$(this).find('.ui-selected').find('[data-pid]').attr('data-pid');
				removable_playername = $(this).find('.ui-selected').find('[data-pid]').html();	
				removable_playerid=$(this).find('.ui-selected').find('.removable_playerid').html();

			});
        }
	});
	
    $('.selected_window').selectable({
        filter:'tr',
        selected: function(event, ui){
			data = ($(this).find('.ui-selected'));
			
			$.each(data, function(index, element){
				removable_playerkey[index]=$(element).find('[data-pid]').attr('data-pid');
				removable_playername[index] = $(element).find('[data-pid]').html();
				removable_playerid[index]=$(element).find('.removable_playerid').html();
				player[index] = new Array();
				player[index][0] = removable_playerkey[index]
				player[index][1] = removable_playername[index]
				player[index][2] = removable_playerid[index]
			});            
        }
	});
	
	
	$(document).on("click" , '#outoftheteam',function(){
		$.each(player, function(index, player){
			$('[data-pid="'+player[2]+'"]').parent().remove();
			$('[data-id="'+player[2]+'"]').parent().show();
		});
		player = new Array();
	});

	
	$(document).on('mouseover','#draft_team img', function(){
		$(this).attr('src', '/assets/create-over.png');
	});
	
	$(document).on('mouseout', '#draft_team img', function(){
		$(this).attr('src', '/assets/create.png');
	});
	
	
	
	var maxteamid = parseInt($('#teammaxid').html());
	
	$(document).on('click','#draft_team', function(){
		$(this).children('img').attr('src', '/assets/create-over.png');
		var jsonObj = {};
		var selected_players = $('#removable_players_table').children('tbody').children('tr');
		var clkey = $('#clientkey').val();
		var ckey = $("#team_coachkey option:selected").val();
		var coachname = $("#team_coachkey option:selected").html();
		var mkey = $("#team_managerkey option:selected").val();
		var managername = $("#team_managerkey option:selected").html();
		var tname = $('#team_teamname').val();
		tname = tname.charAt(0).toUpperCase()+tname.slice(1);
		var teamid = $('#team_teamid').val();
		var teamtypekey = $("#team_teamtypekey option:selected").val();
		var formatkey = $("#format_select option:selected").val();
		var countrykey = $("#country_select option:selected").val();
		var countryname = $("#country_select option:selected").html();
		var count_players = $(selected_players).length;
		
		var counter = 1;

		$(selected_players).each(function(){
			var pkey = $(this).find('[data-pid]').attr('data-pid');
			var pid = $(this).find('.removable_playerid').html();
			jsonObj = {clientkey:clkey, playerkey:pkey, playerid:pid, managerkey:mkey,coachkey:ckey,teamname:tname,teamid:teamid,teamtypekey:teamtypekey, formatkey:formatkey, countrykey:countrykey};
			$.ajax({
				url: '/teams',
				type: 'post',
				cache: false,
				data: {team:jsonObj},
				success: function(data, textStatus, jqXHR ) { 
					if (counter == count_players){
						//window.location='/team?teamid='+teamid;
						$('#success_message').html('Team created successfully');
						$('.fields').children('input').val('');
						$('#removable_players_table').html('');
						$('.player').hide();
						maxteamid = maxteamid+1;
						$('#maximumteamid').html('Enter '+maxteamid+' or more');
						
					}

					
					counter = counter + 1;
					console.log('i m here');

					
				},
				error: function(jqXHR, textStatus, errorThrown){ 
					console.log('unsuccessful');
					$('#success_message').html('Team creation aborted');
				}
			});
		});	
		
		
	});
	
	
	$('#countrykey_team').change(function(){
		countrykey = $('#countrykey_team option:selected').val();
		formatkey = $('#team_formatkey option:selected').val();
		$('.player').hide();
		players = $('[data-country="'+countrykey+'"]');
		console.log(players);
		console.log(formatkey);
		players.each(function(){
			if ( $(this).attr('data-format')== formatkey  ){
				//console.log($(this).parent());	
				$(this).parent().show();
			}
		
		});
	});
	
	
	$('#team_formatkey').change(function(){
		countrykey = $('#countrykey_team option:selected').val();
		formatkey =  $('#team_formatkey option:selected').val();
		$('.player').hide();
		players = $('[data-country="'+countrykey+'"]');
		console.log(players);
		console.log(formatkey);
		players.each(function(){
			if ( $(this).attr('data-format')== formatkey  ){
				$(this).parent().show();
			}
		
		});
	});
	
	$(document).on("click" ,'#in_the_team', function(){		
		$.each(player, function(index, player){
			$('#removable_players_table').append('<tr><td class="removable_playerid">'+player[2]+'</td><td class="removable_playername" data-pid="'+player[2]+'">'+player[1]+'</td></tr>');
			$('[data-id="'+player[2]+'"]').parent().hide();
		});
		player = new Array();
	});
	
	
	$(document).on("click" ,'#out_of_the_team', function(){
		$.each(player, function(index, player){			
			$('[data-pid="'+player[2]+'"]').parent().remove();
			$('[data-id="'+player[2]+'"]').parent().show();			
		});
		player = new Array();
	});
	
	
	if ($('body,html').find('#new_match').length != 0){
			$('#match_teamidtwo').attr('disabled','disabled');
	}
	
	$('#match_teamidone').change(function(){
		teamone = $('#match_teamidone option:selected').val();
		$('#match_teamidtwo').removeAttr('disabled');
		
		$('#match_tosswon').children('option').hide();
		$('#match_tosswon').find('[value="'+teamone+'"]').show();
		$('#match_winnerkey').find('[value="'+teamone+'"]').show();

	});
	

	
	
	$('#match_teamidtwo').change(function(){
		teamtwo =  $('#match_teamidtwo option:selected').val();
		$('#match_tosswon').find('[value="'+teamtwo+'"]').show();
		
		$('#match_winnerkey').find('[value="'+teamtwo+'"]').show();

	});

	
	

	if ($('body,html').find('#modify_team_form').length != 0){
		var teamid = $('#team_teamid').val();
		var date_drafted = $('#date_drafted').html();
		$('.player').hide();
		countrykey = $('#countrykey_team option:selected').val();
		formatkey =  $('#team_formatkey option:selected').val();
		players = $('[data-country="'+countrykey+'"]');
		players.each(function(){
			if ( $(this).attr('data-format')== formatkey  ){
				$(this).parent().show();
			}
		});	
		$.ajax({
			url: '/team.json?date_drafted='+date_drafted+'&teamid='+teamid,
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 	
				var object_count = data.length
				console.log(object_count);
				var i;
				for(i=0; i<object_count; i++){
					$('#removable_players_table').append('<tr><td class="removable_playerid">'+data[i]['playerid']+'</td><td class="removable_playername" data-teamkey="'+data[i]['id']+'" data-pid="'+data[i]['playerid']+'">'+data[i]['player_name']+'</td></tr>');
					$('[data-id="'+data[i]['playerid']+'"]').parent().hide();			
				}
				
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});
	}

	$(document).on('mouseover','#update_team img', function(){
		$(this).attr('src', '/assets/update-over.png');
	});
	
	$(document).on('mouseout','#update_team img', function(){
		$(this).attr('src', '/assets/update.png');
	});
	
	$(document).on('click','#update_team', function(){
		$(this).children('img').attr('src', '/assets/update-over.png');
		var jsonObj = {};
		var selected_players = $('#removable_players_table').children('tbody').children('tr');
		var clkey = $('#clientkey').val();
		var ckey = $("#team_coachkey option:selected").val();
		var mkey = $("#team_managerkey option:selected").val();
		var tname = $('#team_teamname').val();
		var teamid = $('#team_teamid').val();
		var date_drafted = $('#date_drafted').html();
		var teamtypekey = $("#team_teamtypekey option:selected").val();
		var formatkey = $("#team_formatkey option:selected").val();
		var countrykey = $("#countrykey_team option:selected").val();
		var count_players = $(selected_players).length;
		

		var team_players = [];
		$.ajax({
			url: '/team.json?date_drafted='+date_drafted+'&teamid='+teamid,
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 	
				var object_count = data.length
				var i;
				for(i=0; i<object_count; i++){
					console.log(data[i]);
					$.ajax({
						url: '/teams/'+data[i]['id'],
						type: 'DELETE',
						data: {id:data[i]['id']},	
						cache: false,
						data: {team:jsonObj},
						success: function(data, textStatus, jqXHR ) { 
							console.log('delete successful');
						},
						error: function(jqXHR, textStatus, errorThrown){ 
							console.log(errorThrown);
						}
					});
				}
				
				
				
				var counter = 1;

				$(selected_players).each(function(){
					var pkey = $(this).find('[data-pid]').attr('data-pid');
					var pid = $(this).find('.removable_playerid').html();
					jsonObj = {clientkey:clkey, playerkey:pkey, playerid:pid, managerkey:mkey,coachkey:ckey,teamname:tname,teamid:teamid,teamtypekey:teamtypekey, formatkey:formatkey, countrykey:countrykey};
					$.ajax({
						url: '/teams',
						type: 'post',
						cache: false,
						data: {team:jsonObj},
						success: function(data, textStatus, jqXHR ) { 
							if (counter == count_players){
								//window.location='/team?teamid='+teamid;
								$('#success_message').html('Team updated successfully');
							}

					
							counter = counter + 1;
							
						},
						error: function(jqXHR, textStatus, errorThrown){ 
							console.log('unsuccessful');
						}
					});
				});	
				

			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});
		

	});
	
	$(document).on('click','._country', function()  {
		window.location='/countries/new';
	});
	
	$(document).on('click','._tournament', function()  {
		window.location='/tournaments/new';
	});
	
	$(document).on('click', '._player',function()  {
		window.location='/players/new';
	});
	
	$(document).on('click','._manager', function()  {
		window.location='/managers/new';
	});
	
	$(document).on('click','._coach', function()  {
		window.location='/coaches/new';
	});
	
	$(document).on('click','._team', function()  {
		window.location='/teams/new';
	});
	
	$(document).on('click','._venue', function()  {
		window.location='/venues/new';
	});

	$(document).on('click','._match', function()  {
		window.location='/matches/new';
	});
	
	var x = $('.x').html();
	if (x==1 && x!= undefined){
		$('#navigation_bar').hide();
		$('#centralnav').hide();
	}
	
	console.log('this is alt');
	var alt = $('.order').children('span').children('img').attr('alt');
	console.log('this is alt '+ alt);
	if (alt != undefined) {
		$('.order').children('span').children('img').attr('src', '/assets/'+alt.toLowerCase()+'-over.png');
	}
	

});







