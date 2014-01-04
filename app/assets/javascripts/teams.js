$(document).on('ready page:load', function () {
	$('#teams tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#teams tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	
	
	$(document).on('click','.fields', function(){
		$('#success_message').html('');	
	});
	
	$(document).on('click', '.fields1', function(){
		console.log('hello');
		$(this).children('input').val('');
		$('#success_message').html('');	
		
	});
	
	$(document).on('click', '#team_teamname', function(){
		$('#team_teamid').val('');
	});
	
	$(document).on('click', '#team_coachkey, #team_managerkey, #team_teamid', function(){
		$.ajax({
			url: '/teams.json',
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 
				console.log('successful');
				var teamname = $('#team_teamname').val();
				for(i=0;i<data.length; i++){
					if(data[i]['teamname'].toLowerCase() == teamname.toLowerCase() && teamname != ''){
						$('#team_teamid').val(data[i]['teamid']);
						break;
					}
				}
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});
	});
});