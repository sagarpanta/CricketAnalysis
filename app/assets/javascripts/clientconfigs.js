$(document).ready(function(){

	var avg = 0, bbb= 0, bbh= 0, byes= 0, clientkey= 0, convrsnratio= 0;
	var dsmsl= 0, extras= 0, five= 0, four=0, inns= 0, legbyes= 0, mtchlost= 0;
    var	mtchwon= 0, noballs= 0, one = 0, runs = 0, six= 0, sr= 0, three= 0, two= 0, wides= 0, zero= 0;

	
	
	var clientkey = $('#userkey').html();
	if (clientkey!= undefined){
		$.ajax({
			url: '/settings.json?clientkey='+clientkey,
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 
				console.log('successful');
				console.log(data);
				
				if (data["avg"]==1) {$('[data-metric="avg"]').addClass('enable');}
				if (data["bbb"]==1) {$('[data-metric="bbb"]').addClass('enable');}
				if (data["bbh"]==1) {$('[data-metric="bbh"]').addClass('enable');}
				if (data["byes"]==1) {$('[data-metric="byes"]').addClass('enable');}
				if (data["convrsnratio"]==1) {$('[data-metric="convrsnratio"]').addClass('enable');}
				if (data["dsmsl"]==1) {$('[data-metric="dsmsl"]').addClass('enable');}
				if (data["extras"]==1) {$('[data-metric="extras"]').addClass('enable');}
				if (data["five"]==1) {$('[data-metric="five"]').addClass('enable');}
				if (data["four"]==1) {$('[data-metric="four"]').addClass('enable');}
				if (data["inns"]==1) {$('[data-metric="inns"]').addClass('enable');}
				if (data["legbyes"]==1) {$('[data-metric="legbyes"]').addClass('enable');}
				if (data["mtchlost"]==1) {$('[data-metric="mtchlost"]').addClass('enable');}
				if (data["mtchwon"]==1) {$('[data-metric="mtchwon"]').addClass('enable');}
				if (data["noballs"]==1) {$('[data-metric="noballs"]').addClass('enable');}
				if (data["one"]==1) {$('[data-metric="one"]').addClass('enable');}
				if (data["runs"]==1) {$('[data-metric="runs"]').addClass('enable');}
				if (data["six"]==1) {$('[data-metric="six"]').addClass('enable');}
				if (data["sr"]==1) {$('[data-metric="sr"]').addClass('enable');}
				if (data["three"]==1) {$('[data-metric="three"]').addClass('enable');}
				if (data["two"]==1) {$('[data-metric="two"]').addClass('enable');}
				if (data["wides"]==1) {$('[data-metric="wides"]').addClass('enable');}
				if (data["zero"]==1) {$('[data-metric="zero"]').addClass('enable');}
				if (data["fifties"]==1) {$('[data-metric="fifties"]').addClass('enable');}
				if (data["hundreds"]==1) {$('[data-metric="hundreds"]').addClass('enable');}
				if (data["bavg"]==1) {$('[data-metric="bavg"]').addClass('enable');}
				if (data["econ"]==1) {$('[data-metric="econ"]').addClass('enable');}
				if (data["dbx"]==1) {$('[data-metric="dbx"]').addClass('enable');}
				if (data["noofdels"]==1) {$('[data-metric="noofdels"]').addClass('enable');}
				if (data["noofshots"]==1) {$('[data-metric="noofshots"]').addClass('enable');}
				if (data["c_strike"]==1) {$('[data-metric="c_strike"]').addClass('enable');}
				if (data["c_nonstrike"]==1) {$('[data-metric="c_nonstrike"]').addClass('enable');}
				if (data["consistency"]==1) {$('[data-metric="consistency"]').addClass('enable');}
				if (data["mishits"]==1) {$('[data-metric="mishits"]').addClass('enable');}
				if (data["slugs"]==1) {$('[data-metric="slugs"]').addClass('enable');}
				
				
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});	
	}

	$(document).on('click','#all', function(){
		var checked = $('.new_clientconfig .field [type="checkbox"], .edit_clientconfig .field [type="checkbox"]').prop('checked');
		var all = $(this).prop('checked');
		if ((checked == false) || (all == true)){
			$('.new_clientconfig .field [type="checkbox"], .edit_clientconfig .field [type="checkbox"]').prop('checked',true);
		}
		else{
			$('.new_clientconfig .field [type="checkbox"], .edit_clientconfig .field [type="checkbox"]').prop('checked',false);
		}
	});
	
	

});