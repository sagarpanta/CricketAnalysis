$(document).ready(function(){
	$('#managers tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#managers tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	var textfield_filled = 0;
	
	$('.fields').on('click', function(){
		$('#success_message').html('');	
	});


});
