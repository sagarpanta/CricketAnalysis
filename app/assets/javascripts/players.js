$(document).ready(function(){
	$('#players tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#players tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});


	$("#datepicker").datepicker({dateFormat: 'yy-mm-dd'});
	
	
	$('.fields').on('click', function(){
		$('#success_message').html('');	
	});
	
	
	$( "#dialog-player-form" ).dialog({
		autoOpen: false,
		height: 150,
		width: 200,
		modal: true
	});
	
	$('.edit_player table tr td #player_playerid').on('click', function(){
		$( "#dialog-player-form" ).dialog('open');
	});

	$('#btn-ok').on('click', function(){
		$( "#dialog-player-form" ).dialog('close');
	});
	
	$(document).on('keyup','#name', function(){
		var searchname = $(this).val();
		if (searchname ==''){
			$('.playerdata').show();
		}
		else{
			$('.playerdata').hide();
			$("td:contains("+searchname+")").parent().show()
		}
	});
	
	$(document).on('click', '#player_fname', function(){
		$('#player_playerid').val('');
	});
	
	$(document).on('click', '#player_playerid', function(){		
		var fname = $('#player_fname').val();
		var lname = $('#player_lname').val();
		if (fname != undefined){
			fname = fname.charAt(0).toUpperCase()+fname.slice(1);
		}
		if (lname != undefined){
			lname = lname.charAt(0).toUpperCase()+lname.slice(1);
		}
		var fullname = fname+' '+lname;
		$.ajax({
			url: '/playerids.json?fullname='+fullname,
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 
				console.log('successful');
				if(data['fullname'] == fullname && fullname != ''){
					$('#player_playerid').val(data['playerid']);
				}
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});
	});
		
	

});

