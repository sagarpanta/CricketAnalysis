$(document).ready(function(){
	$('#coaches tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#coaches tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	var textfield_filled = 0;
	
	$('.fields').live('click', function(){
		$('#success_message').html('');	
	});


});
