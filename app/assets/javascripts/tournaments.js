$(document).ready(function(){
	$('#tournaments tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#tournaments tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	$('.fields').live('click', function(){
		$('#success_message').html('');	
	});

});