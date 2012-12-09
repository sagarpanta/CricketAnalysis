$(document).ready(function(){
	$('#matches tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#matches tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	var textfield_filled = 0;
	
	$('.fields').live('click', function(){
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
	  
	  

	  var matchid = $('#matchid').html();
	  var innings = parseInt($('#innings').html());
	  var runsperover = $('#runsperover').html();
	  
	  var cumrunsperover = $('#cumrunsperover').html();
	  
	  if (runsperover != undefined) {
		  matchovers = parseInt($('#matchOvers').html());
		  currOver = parseInt($('#currOver').html());
		  currOverInDec = parseFloat($('#currOverInDec').html());
		  currball = parseInt($('#currBall').html());
		  var i = 0;
		  var _data = new Array();
		  _data = runsperover.split(',');
		  
		  var chartdata = new Array();
		  var temp = new Array();
		 

		  var index_pos = 0;
		  for(i=0; i<=innings; i++) {
			temp.push(_data[i]);
			console.log(temp);
			index_pos = i+1;
		  }
		  chartdata.push(temp);

		  var temp = new Array();
		  for (i = index_pos; i<_data.length; i++){
			temp.push(parseInt(_data[i]))
			if ((i+1)%2 == 0){
				chartdata.push(temp);
				temp = [];
			}

		  }
		  chartdata[0].push('avg');
		  var  avg = parseFloat($('#currRR').html());
		  
		  for (i=1; i<chartdata.length; i++) {
			chartdata[i].push(avg);
		  }
		  
		  console.log(chartdata);
		  
		  google_match_function(chartdata, currOver, 'container1', 'Runs Per Over');
		  $('#container1').show();
		  
		  
		  //*****************
		  var i = 0;
		  var _data = new Array();
		  _data = cumrunsperover.split(',');
		  
		  var chartdata = new Array();
		  var temp = new Array();
		 

		  var index_pos = 0;
		  for(i=0; i<=innings; i++) {
			temp.push(_data[i]);
			console.log(temp);
			index_pos = i+1;
		  }
		  chartdata.push(temp);

		  var temp = new Array();
		  for (i = index_pos; i<_data.length; i++){
			temp.push(parseInt(_data[i]))
			if ((i+1)%2 == 0){
				chartdata.push(temp);
				temp = [];
			}

		  }
		  
		  google_match_function(chartdata, currOver,'container2', 'Cumulative Runs Per Over');
		  $('#container2').show();
		  
		  
		  console.log(chartdata);
	   }
	   
	 $('[name="button"]').live('click', function(){
		var runrate = parseFloat($('#runrate').val());
		var currentscore = parseInt($('#currScore').html());
		var ovrsRemaining = parseFloat($('#oversRemaining').html());
		
		var projectedScore = currentscore + parseInt(ovrsRemaining * runrate);
		$('#projected').html(projectedScore);
	 
	 
	 });  
	  
});