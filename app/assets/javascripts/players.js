$(document).ready(function(){
	$('#players tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#players tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});


	$("#datepicker").datepicker({dateFormat: 'yy-mm-dd'});
	
	
	$('.fields').live('click', function(){
		$('#success_message').html('');	
	});
	
	
	$( "#dialog-player-form" ).dialog({
		autoOpen: false,
		height: 150,
		width: 200,
		modal: true
	});
	
	$('.edit_player table tr td #player_playerid').live('click', function(){
		$( "#dialog-player-form" ).dialog('open');
	});

	$('#btn-ok').live('click', function(){
		$( "#dialog-player-form" ).dialog('close');
	});
		
	

});

