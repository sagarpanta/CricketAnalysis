$(document).ready(function(){
	$('#teams tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#teams tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	
	
	$('.fields').live('click', function(){
		$('#success_message').html('');	
	});
	
	$('.fields1').live('click', function(){
		console.log('hello');
		$(this).children('input').val('');
		$('#success_message').html('');	
		
	});
	
	
	


});
