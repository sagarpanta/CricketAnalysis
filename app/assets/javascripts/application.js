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
//= require_tree .
$(document).ready(function(){
	$(".chzn-select").chosen();
	$('.mac-dock img').resizeOnApproach();
	
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
	
	$('#centralnav').live('mouseover' , function(){
		$(this).fadeTo(0,1);
	});
	
	$('#centralnav').live('mouseout' , function(){
		$(this).fadeTo(0,0);
	});
	
	
	$('.cnav').live('hover', function(){
		$(this).css('opacity', '0.7');
		
	});
	
	$('.cnav').live('mouseout', function(){
		$(this).css('opacity', '0.6');
	});	
	
	
	$('.actions input').live('mouseover', function(){
		var data = $(this).attr('data');
		$(this).attr('src', '/assets/'+data+'-over.png');
	});
	
	$('.actions input').live('mouseout', function(){
		var data = $(this).attr('data');
		$(this).attr('src', '/assets/'+data+'.png');
	});
	
	$('.actions input').live('click', function(){
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
					console.log(player[index]);
			});
			            
        }
	});
	
	
	$('#intheteam').live("click" , function(){
		$.each(player, function(index, player){
			$('#removable_players_table').append('<tr><td class="removable_playerid">'+player[2]+'</td><td class="removable_playername" data-pid="'+player[0]+'">'+player[1]+'</td></tr>');
			$('[data-id="'+player[0]+'"]').parent().hide();
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
				console.log(element);
				removable_playerid[index]=$(element).find('.removable_playerid').html();
				player[index] = new Array();
				player[index][0] = removable_playerkey[index]
				player[index][1] = removable_playername[index]
				player[index][2] = removable_playerid[index]
			});            
        }
	});
	
	
	$('#outoftheteam').live("click" , function(){
		$.each(player, function(index, player){
			$('[data-pid="'+player[0]+'"]').parent().remove();
			$('[data-id="'+player[0]+'"]').parent().show();
		});
		player = new Array();
	});

	
	$('#draft_team img').live('mouseover', function(){
		$(this).attr('src', '/assets/create-over.png');
	});
	
	$('#draft_team img').live('mouseout', function(){
		$(this).attr('src', '/assets/create.png');
	});
	
	
	
	var maxteamid = parseInt($('#teammaxid').html());
	
	$('#draft_team').live('click', function(){
		$(this).children('img').attr('src', '/assets/create-over.png');
		var jsonObj = {};
		var selected_players = $('#removable_players_table').children('tbody').children('tr');
		var clkey = $('#clientkey').val();
		var ckey = $("#team_coachkey option:selected").val();
		var coachname = $("#team_coachkey option:selected").html();
		var mkey = $("#team_managerkey option:selected").val();
		var managername = $("#team_managerkey option:selected").html();
		var tname = $('#team_teamname').val();
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
	
	$('#in_the_team').live("click" , function(){		
		$.each(player, function(index, player){
			$('#removable_players_table').append('<tr><td class="removable_playerid">'+player[2]+'</td><td class="removable_playername" data-pid="'+player[0]+'">'+player[1]+'</td></tr>');
			$('[data-id="'+player[0]+'"]').parent().hide();
		});
		player = new Array();
	});
	
	
	$('#out_of_the_team').live("click" , function(){
		$.each(player, function(index, player){			
			$('[data-pid="'+player[0]+'"]').parent().remove();
			$('[data-id="'+player[0]+'"]').parent().show();			
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
			url: '/team.json?teamid='+teamid,
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 	
				var object_count = data.length
				console.log(object_count);
				var i;
				for(i=0; i<object_count; i++){
					$('#removable_players_table').append('<tr><td class="removable_playerid">'+data[i]['playerid']+'</td><td class="removable_playername" data-teamkey="'+data[i]['id']+'" data-pid="'+data[i]['playerkey']+'">'+data[i]['player_name']+'</td></tr>');
					$('[data-id="'+data[i]['playerkey']+'"]').parent().hide();			
				}
				
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});
	}

	$('#update_team img').live('mouseover', function(){
		$(this).attr('src', '/assets/update-over.png');
	});
	
	$('#update_team img').live('mouseout', function(){
		$(this).attr('src', '/assets/update.png');
	});
	
	$('#update_team').live('click', function(){
		$(this).children('img').attr('src', '/assets/update-over.png');
		var jsonObj = {};
		var selected_players = $('#removable_players_table').children('tbody').children('tr');
		var clkey = $('#clientkey').val();
		var ckey = $("#team_coachkey option:selected").val();
		var mkey = $("#team_managerkey option:selected").val();
		var tname = $('#team_teamname').val();
		var teamid = $('#team_teamid').val();
		var teamtypekey = $("#team_teamtypekey option:selected").val();
		var formatkey = $("#team_formatkey option:selected").val();
		var countrykey = $("#countrykey_team option:selected").val();
		var count_players = $(selected_players).length;
		

		var team_players = [];
		$.ajax({
			url: '/team.json?teamid='+teamid,
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 	
				var object_count = data.length

				var i;
				for(i=0; i<object_count; i++){
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
	
	$('._country').live('click', function()  {
		window.location='/countries/new';
	});
	
	$('._tournament').live('click', function()  {
		window.location='/tournaments/new';
	});
	
	$('._player').live('click', function()  {
		window.location='/players/new';
	});
	
	$('._manager').live('click', function()  {
		window.location='/managers/new';
	});
	
	$('._coach').live('click', function()  {
		window.location='/coaches/new';
	});
	
	$('._team').live('click', function()  {
		window.location='/teams/new';
	});
	
	$('._venue').live('click', function()  {
		window.location='/venues/new';
	});

	$('._match').live('click', function()  {
		window.location='/matches/new';
	});
	
	var x = $('.x').html();
	if (x==1){
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







