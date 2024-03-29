$(document).on('ready page:load', function () {
	$('#matches tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#matches tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	var textfield_filled = 0;
	
	$('.fields').on('click', function(){
		$('#success_message').html('');	
	});

	var matchovers;
	var google_match_function =  function drawVisualization(chartdata, currOver, htmlid, title) {
        // Some raw data (not necessarily accurate)
		
        var data = google.visualization.arrayToDataTable(chartdata);
		
        var options = {
          title : title,
		  titleTextStyle:  {color: 'darkgray', fontName: 'verdana', fontSize: 12},
          vAxis: {title: 'runs'},
          hAxis: {title: 'over', gridlines: {color: '#333', count: currOver}, showTextEvery:1},
          seriesType: 'line',
          series: {currOver: {type: "line"}}
        };
		console.log('hello');
		
		var chart;

		chart = new google.visualization.LineChart(document.getElementById(htmlid));

        chart.draw(data, options);
      }
	  
	var google_match_function_bar =  function drawVisualization(chartdata, currOver, htmlid, title) {
        // Some raw data (not necessarily accurate)
		
        var data = google.visualization.arrayToDataTable(chartdata);
		
        var options = {
          title : title,
		  titleTextStyle:  {color: 'darkgray', fontName: 'verdana', fontSize: 12},
          vAxis: {title: 'runs'},
          hAxis: {title: 'over', gridlines: {color: '#333', count: currOver}, showTextEvery:1}
        };	
		var chart;
		chart = new google.visualization.ColumnChart(document.getElementById(htmlid));
        chart.draw(data, options);
      }
	  
	  var matchid = $('#matchid').html();
	  var totalinnings = parseInt($('#totalinnings').html());
	  var runsperover = $('#runsperover').html();
	  
	  var cumrunsperover = $('#cumrunsperover').html();
	  
	  if (runsperover != undefined) {
		  matchovers = parseInt($('#matchOvers').html());
		  currOver = parseInt($('#currOver').html());
		  currOverInDec = parseFloat($('#currOverInDec').html());
		  currball = parseInt($('#currBall').html());
		  var i = 0;
		  var _data = new Array();
		  var _data_c = new Array();
		  
		  _data = runsperover.split(',');
		  _data_c = cumrunsperover.split(',');
		  
		  var chartdata = new Array();
		  var chartdata_c = new Array();
		  
		  var temp = new Array();
		  var temp_c = new Array();
		  console.log(runsperover);
		  console.log(cumrunsperover);
		  console.log('total inns ' + totalinnings);
		  var x = 1;
		  for(i=0; i<=_data.length; i++) {
			//if 2nd inning is currently on or already being played, then the consider changing the string value to int for every 2nd and 3rd element of the set (x%3==2 || x%3==0). Ignore the first set completely (x>3)
			//if only 1st inning is being played, then consider changing every 2nd value to integer (x%2==0). Ignore the first set completely (x>2)
			if ((totalinnings == 2 && (x%3==2 || x%3==0) && x>3) ||  (totalinnings == 1 && x%2==0 && x>2)){
				temp.push(parseInt(_data[i]));
				temp_c.push(parseInt(_data_c[i]));
			}
			else{
				temp.push(_data[i]);
				temp_c.push(_data_c[i]);
			}

			if ((totalinnings == 2 && x%3==0) || (totalinnings == 1 && x%2==0)){
				chartdata.push(temp);
				chartdata_c.push(temp_c);
				
				temp = new Array();
				temp_c = new Array();
			}
			x = x+1;
		  }
		  
		  
		  console.log(chartdata);
 
		  
		  google_match_function_bar(chartdata, currOver, 'container1', 'Runs Per Over');
		  $('#container1').show();
		  
		  google_match_function(chartdata_c, currOver, 'container2', 'Cumulative Runs Per Over');
		  $('#container2').show();
		  
		  

	   }
	   
	 $('[name="button"]').on('click', function(){
		var runrate = parseFloat($('#runrate').val());
		var currentscore = parseInt($('#currScore').html());
		var ovrsRemaining = parseFloat($('#oversRemaining').html());
		
		var projectedScore = currentscore + parseInt(ovrsRemaining * runrate);
		$('#projected').html(projectedScore);
	 
	 
	 }); 

	/* 
	var pitchcondition_array = new Array();
	var match_form = $('.pitchcondition').html();
	if (match_form != undefined){
		$.ajax({
			url: '/pitchconditions',
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 
				console.log('successful');
				pitchcondition_array = data;
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});
	}
	*/
	
	$('#pc_pckey').change(function(){
		var pitchcondition = $(this).val();
		$('#match_pitchcondition').val(pitchcondition);
	});
	
	
	var pitch_clicked = 0;
	$('#match_pitchcondition').on('click', function(){
		pitch_clicked = pitch_clicked+1;
		if (pitch_clicked==1){
			$('.pitchcondition').slideDown('slow', function() {
				console.log(typeof pitchcondition_array);
				var i;
				$(this).append('<ul class="ul_pitch">');
				for(i=0; i<pitchcondition_array.length;i++){
					if (pitchcondition_array[i] != null){
						$(this).append('<li class="li_pitch">'+pitchcondition_array[i]+'</li>');
					}
				}
				$(this).append('</ul>');
				$('.ul_pitch').css('margin-top', -10);
				$('.li_pitch').css('display', 'block').css('color','white');
			});
		}
	}); 
	$('#match_pitchcondition').on('mouseout', function(){
		$('.pitchcondition').html('');
		pitch_clicked = 0;
		console.log('hellow hou are you');
	});	
	
	$('#public_client_clientkey').change(function(){
		$('.public_match').hide();
		var clientkey = $(this).val();
		$('[data-clientkey="'+clientkey+'"]').show();
	});
});