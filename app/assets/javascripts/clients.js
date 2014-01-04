$(document).on('ready page:load', function () {
	$('.links').on('mouseout', function(){
		
		var alt = $(this).children('span').children('img').attr('alt').toLowerCase();
		$(this).children('span').children('img').attr('src', '/assets/'+alt+'.png');
		//$(this).attr('src', '/assets/match.png');
	
	});
	
	$('.links').on('mouseover', function(){	
		var alt = $(this).children('span').children('img').attr('alt').toLowerCase();
		$(this).children('span').children('img').attr('src', '/assets/'+alt+'-over.png');

	});
	
	$('.links').on('click', function(){
		var alt = $(this).children('span').children('img').attr('alt').toLowerCase();
		$(this).children('span').children('img').attr('src', '/assets/'+alt+'.png');
		link = $(this).attr('data-link');
		console.log(link);
		window.location='/'+link;

	});
	

	
	
});

