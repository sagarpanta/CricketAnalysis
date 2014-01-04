$(document).on('ready page:load', function () {
	$('#tournaments tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#tournaments tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	$('.fields').on('click', function(){
		$('#success_message').html('');	
	});

});