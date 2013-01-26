$(document).ready(function(){
	$('#venues tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#venues tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});

	
	$('.fields').on('click', function(){
		$('#success_message').html('');	
	});

});