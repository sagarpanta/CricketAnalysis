$(document).ready(function(){
	var analysis = $('#analysis_analysiskey').val();
	
	var countrykey = [''];
	var formatkey = [''];
	var tournamentkey = [''];
	var venuekey = [''];
	var teamtypekey = [''];
	var teamkey = [''];
	var matchtypekey = [''];
	var coachkey = [''];
	var managerkey = [''];
	var playertypename = [''];
	//var playerkey = [''];
	var batsmankey = [''];
	var bowlerkey = [''];
	var endkey = [''];
	var battingstylename = [''];
	var bowlingstylename = [''];
	var bowlingtypename = [''];
	var battingposition = [''];
	var bowlingposition = [''];
	var inningkey = [''];
	var shottypekey = [''];
	var shotdirectionkey = [''];
	var pitchconditionkey = [''];
	
	///////////////
	
	var countrykey1 = [''];
	var formatkey1 = [''];
	var tournamentkey1 = [''];
	var venuekey1 = [''];
	var teamtypekey1 = [''];
	var teamkey1 = [''];
	var matchtypekey1 = [''];
	var coachkey1 = [''];
	var managerkey1 = [''];
	var playertypename1 = [''];
	//var playerkey1 = [''];
	var batsmankey1 = [''];
	var bowlerkey1 = [''];
	var endkey1 = [''];
	var battingstylename1 = [''];
	var bowlingstylename1 = [''];
	var bowlingtypename1 = [''];
	var battingposition1 = [''];
	var bowlingposition1 = [''];
	var inningkey1 = [''];
	var linekey1 = [''];
	var lengthkey1 = [''];
	var sidekey1 = [''];
	var spellkey1 = [''];
	var pitchconditionkey1 = [''];
	
	////////////////
	
	var metric = '';
	var group1 = '';
	var group2 = '';
	var lastXmatches = -2;
	var lastXballs = -2;
	
	var keys = [];
	var values = [];
	
	var jsonObj = {};
	
	var product =	function cartesianProductOf(countrykey, formatkey, playertypename, battingstylename, bowlingtypename, bowlingstylename) {
						var i,j,k,l,m;
						var result = [];
						citems = countrykey.length;
						fitems = formatkey.length;
						pitems = playertypename.length;
						bitems = battingstylename.length;
						oitems = bowlingstylename.length;
						titems = bowlingtypename.length;

						for(i=0;i<citems;i++){
							for(j=0;j<fitems;j++){
								for(k=0;k<pitems;k++){
									for(m=0;m<bitems;m++){
										for(n=0;n<oitems;n++){
											for(o=0;o<titems;o++){
												var attributes = [countrykey[i], formatkey[j], playertypename[k], battingstylename[m],  bowlingstylename[n],bowlingtypename[o]];
												result.push(attributes);
											}
										}
									}
									
								}
							}
						}
						return result;
					};
					
	
	
	
	var charttype = 'bars';
	var zoomIn = function drawRegionsMap(region, chartdata) {
        // Some raw data (not necessarily accurate)
        var data = google.visualization.arrayToDataTable(chartdata);
		
        var options = {};
		options['region'] = region;
		options['magnifyingGlass'] = {enable:true, zoomFactor:7.5};

        var chart = new google.visualization.GeoChart(document.getElementById('container'));
        chart.draw(data, options);
		google.visualization.events.addListener(chart, 'regionClick', function(e) {
			console.log(e);
			google_map_function(chartdata);
		});
    }
	
	var google_map_function =  function drawRegionsMap(chartdata) {
        // Some raw data (not necessarily accurate)
        var data = google.visualization.arrayToDataTable(chartdata);
		
        var options = {};
		options['dataMode'] = 'regions';
		options['magnifyingGlass'] = {enable:true, zoomFactor:7.5};
		options['height'] = 375;

        var chart = new google.visualization.GeoChart(document.getElementById('container'));
        chart.draw(data, options);
		google.visualization.events.addListener(chart, 'regionClick', function(e) {
			console.log(e);
			zoomIn(e['region'], chartdata);
		});
    }

	var google_table_function =  function drawVisualization(chartdata) {
        var data = google.visualization.arrayToDataTable(chartdata);
        var table = new google.visualization.Table(document.getElementById('myModal'));
        table.draw(data, {showRowNumber: true});
      }	
	
	
	var google_chart_function =  function drawVisualization(chartdata) {
        // Some raw data (not necessarily accurate)
		
        var data = google.visualization.arrayToDataTable(chartdata);
		
        var options = {
          title : metric.toUpperCase()+' GROUPED BY '+group1.toUpperCase() + ' BY ' + group2.toUpperCase(),
		  titleTextStyle:  {color: 'darkgray', fontName: 'verdana', fontSize: 8},
          vAxis: {title: metric, titleTextStyle: {fontSize: 8}},
          hAxis: {title: group, textStyle: {fontSize: 8}, titleTextStyle: {fontSize: 8}},
		  legend: {position: 'right', textStyle: {fontSize: 10}},
		  height: 375,
          seriesType: charttype,
          series: {1000: {type: "line"}}
        };
		
		var chart;
		if (charttype == 'pie') {
			chart = new google.visualization.PieChart(document.getElementById('container'));
		}
		else if (charttype == 'bars' || charttype == 'line'){
			chart = new google.visualization.ComboChart(document.getElementById('container'));
		}
        chart.draw(data, options);
      }
	  
	  

	
	var visible = $('#container').css('display');
	console.log(visible);
    if (visible != undefined) {
		var userkey = $('#userkey').html(); 	 
		$.ajax({
			url: '/matchwins.json?clientkey='+userkey,
			type: 'get',
			data: jsonObj,
			cache: false,
			success: function(data, textStatus, jqXHR ) { 
				console.log('successful');
				
				google_map_function(data);
				$('#container').show();

			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
				alert('Too many filters. Reloading page...');
			}
		});
	}

    

	


	$('#analysis_analysiskey').change(function() {
		analysis = $(this).val();
	});
	
	$('#country_countrykey').chosen().change(function() {
		countrykey =  $(this).val() || [''];	
		attributes = product(countrykey, formatkey, playertypename, battingstylename, bowlingtypename, bowlingstylename);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		console.log(selector.substring(0,selector.length-1));
		$('#batsman_batsmankey').children('option').hide();
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).show();
		$('#batsman_batsmankey').trigger("liszt:updated");
	});
	
	
	
	$('#matchformat_matchformatkey').change(function() {
		formatkey =  $(this).val() || [''];
		attributes = product(countrykey, formatkey, playertypename, battingstylename, bowlingtypename, bowlingstylename);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#inning_inningkey').children('option').hide();
		var testmatch = 0;
		for(i=0;i<=formatkey.length;i++){
			console.log(formatkey[i]);
			if(formatkey[i]=="12"){
				testmatch = 1;
				$('#inning_inningkey').children('option').show();
				console.log($('#inning_inningkey').children('option'));
			}
			if(formatkey[i]!="12" && testmatch!="1"){
				$('#inning_inningkey').find('[value="1"],[value="2"]').show();
				console.log($('#inning_inningkey').children('option'));
			}
		}
		
		$('#batsman_batsmankey').children('option').hide();
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).show();
		$('#inning_inningkey').trigger("liszt:updated");
		$('#batsman_batsmankey').trigger("liszt:updated");
		
	});
	

	$('#tournament_tournamentkey').change(function() {
		tournamentkey =  $(this).val() || [''];
	});
	
	$('#venue_venuekey').change(function() {
		venuekey =  $(this).val() || [''];
	});
	
	$('#teamtype_teamtypekey').change(function() {
		teamtypekey =  $(this).val() || [''];
	});
	
	$('#matchtype_matchtypekey').change(function() {
		matchtypekey =  $(this).val() || [''];
	});
	
	$('#inning_inningkey').change(function(){
		inningkey =  $(this).val() || [''];
	});
	
	$('#coach_coachkey').change(function() {
		coachkey =  $(this).val() || [''];
	});
	
	$('#manager_managerkey').change(function() {
		managerkey =  $(this).val() || [''];
	});

	$('#battingposition_battingpositionkey').change(function() {
		battingposition =  $(this).val() || [''];
	});
	
	$('#bowlingposition_bowlingpositionkey').change(function() {
		bowlingposition =  $(this).val() || [''];
	});



	
	$('#playertype_playertypekey').change(function() {
		playertypename = $(this).val() || [''];
		attributes = product(countrykey, formatkey, playertypename,  battingstylename, bowlingtypename, bowlingstylename);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#batsman_batsmankey').children('option').hide();
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).show();
		
		$('#batsman_batsmankey').trigger("liszt:updated");
	});
	

	$('#end_endkey').change(function() {
		endkey =  $(this).val() || [''];
	});
	
	$('#battingstyle_battingstylekey').change(function() {
		battingstylename = $(this).val() || [''];
	});
	
	
	$('#battingstyle_battingstylekey').change(function() {
		battingstylename = $(this).val() || [''];
		attributes = product(countrykey, formatkey, playertypename,  battingstylename, bowlingtypename,bowlingstylename);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#batsman_batsmankey').children('option').hide();
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).show();
		
		$('#batsman_batsmankey').trigger("liszt:updated");
		
	});

		
	
	$('#bowlingtype_bowlingtypekey').change(function() {
		bowlingtypename =  $(this).val() || [''];
		attributes = product(countrykey, formatkey, playertypename,  battingstylename, bowlingtypename, bowlingstylename);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#batsman_batsmankey').children('option').hide();
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).show();
		
		$('#batsman_batsmankey').trigger("liszt:updated");
	});
	

	
	
	$('#bowlingstyle_bowlingstylekey').change(function() {
		bowlingstylename =  $(this).val() || [''];
		attributes = product(countrykey, formatkey, playertypename,  battingstylename, bowlingtypename, bowlingstylename);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#batsman_batsmankey').children('option').hide();
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).show();
		
		$('#batsman_batsmankey').trigger("liszt:updated");
	});
	
	$('#batsman_batsmankey').chosen().change(function() {
		batsmankey = $(this).val() || [''];
	});
	
	
	$('#team_teamkey').change(function() {
		teamkey = $(this).val() || [''];
	});
	
	$('#st_stkey').change(function() {
		shottypekey =  $(this).val() || [''];
	});

	$('#sd_sdkey').change(function() {
		shotdirectionkey =  $(this).val() || [''];
	});
	
	$('#pc_pckey').change(function() {
		pitchconditionkey =  $(this).val() || [''];
	});
	
	


	
//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////BOWLING FUNCTIONS//////////////////////////////////////////	




	$('#country_countrykey1').chosen().change(function() {
		countrykey1 =  $(this).val() || [''];	
		attributes = product(countrykey1, formatkey1, playertypename1, battingstylename1, bowlingtypename1, bowlingstylename1);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		console.log(selector.substring(0,selector.length-1));
		$('#bowler_bowlerkey1').children('option').hide();
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).show();
		$('#bowler_bowlerkey1').trigger("liszt:updated");
	});
	
	
	
	$('#matchformat_matchformatkey1').chosen().change(function() {
		formatkey1 =  $(this).val() || [''];
		attributes = product(countrykey1, formatkey1, playertypename1,  battingstylename1, bowlingtypename1, bowlingstylename1);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#inning_inningkey1').children('option').hide();
		var testmatch = 0;
		for(i=0;i<=formatkey1.length;i++){
			console.log(formatkey1[i]);
			if(formatkey1[i]=="12"){
				testmatch = 1;
				$('#inning_inningkey1').children('option').show();
				console.log($('#inning_inningkey1').children('option'));
			}
			if(formatkey1[i]!="12" && testmatch!="1"){
				$('#inning_inningkey1').find('[value="1"],[value="2"]').show();
				console.log($('#inning_inningkey1').children('option'));
			}
		}
		console.log(selector.substring(0,selector.length-1));
		$('#bowler_bowlerkey1').children('option').hide();
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).show();
		$('#inning_inningkey1').trigger("liszt:updated");
		$('#bowler_bowlerkey1').trigger("liszt:updated");
		
	});
	

	$('#tournament_tournamentkey1').change(function() {
		tournamentkey1 =  $(this).val() || [''];
	});
	
	$('#venue_venuekey1').change(function() {
		venuekey1 =  $(this).val() || [''];
	});
	
	$('#teamtype_teamtypekey1').change(function() {
		teamtypekey1 =  $(this).val() || [''];
	});
	
	$('#matchtype_matchtypekey1').change(function() {
		matchtypekey1 =  $(this).val() || [''];
	});
	
	$('#inning_inningkey1').change(function(){
		inningkey1 =  $(this).val() || [''];
	});
	
	$('#coach_coachkey1').change(function() {
		coachkey1 =  $(this).val() || [''];
	});
	
	$('#manager_managerkey1').change(function() {
		managerkey1 =  $(this).val() || [''];
	});

	$('#battingposition_battingpositionkey1').change(function() {
		battingposition1 =  $(this).val() || [''];
	});
	
	$('#bowlingposition_bowlingpositionkey1').change(function() {
		bowlingposition1 =  $(this).val() || [''];
	});

	$('#length_lengthkey1').change(function() {
		lengthkey1 =  $(this).val() || [''];
	});
	
	$('#line_linekey1').change(function() {
		linekey1 =  $(this).val() || [''];
	});
	
	$('#side_sidekey1').change(function() {
		sidekey1 =  $(this).val() || [''];
	});
	
	$('#spell_spellkey1').change(function() {
		spellkey1 =  $(this).val() || [''];
	});

	$('#pc_pckey1').change(function() {
		pitchconditionkey1 =  $(this).val() || [''];
	});
		
	
	$('#playertype_playertypekey1').change(function() {
		playertypename1 = $(this).val() || [''];
		attributes = product(countrykey1, formatkey1, playertypename1, battingstylename1, bowlingtypename1, bowlingstylename1);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#bowler_bowlerkey1').children('option').hide();
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).show();
		
		$('#bowler_bowlerkey1').trigger("liszt:updated");
	});
	

	$('#end_endkey1').change(function() {
		endkey1 =  $(this).val() || [''];
	});
	
	$('#battingstyle_battingstylekey1').change(function() {
		battingstylename1 = $(this).val() || [''];
	});
	
	
	$('#battingstyle_battingstylekey1').change(function() {
		battingstylename1 = $(this).val() || [''];
		attributes = product(countrykey1, formatkey1, playertypename1,  battingstylename1, bowlingtypename1,bowlingstylename1);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		$('#bowler_bowlerkey1').children('option').hide();
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).show();
		$('#bowler_bowlerkey1').trigger("liszt:updated");
		
	});

		
	
	$('#bowlingtype_bowlingtypekey1').change(function() {
		bowlingtypename1 =  $(this).val() || [''];
		attributes = product(countrykey1, formatkey1, playertypename1,  battingstylename1, bowlingtypename1, bowlingstylename1);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		console.log(selector.substring(0,selector.length-1));
		$('#bowler_bowlerkey1').children('option').hide();
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).show();
		$('#bowler_bowlerkey1').trigger("liszt:updated");
	});
	

	
	
	$('#bowlingstyle_bowlingstylekey1').change(function() {
		bowlingstylename1 =  $(this).val() || [''];
		attributes = product(countrykey1, formatkey1, playertypename1,  battingstylename1, bowlingtypename1, bowlingstylename1);
		items = attributes.length;
		var selector = '';
		var i,j;
		for(i=0;i<items;i++){
			var item_length = attributes[i].length;
			for(j=0;j<item_length;j++){
				if(j==0){
					selector +=  attributes[i][j] == ''? '':'[data-countrykey="'+attributes[i][j]+'"]';
				}
				else if (j==1){
					selector +=  attributes[i][j] == ''? '':'[data-format="'+attributes[i][j]+'"]';
				}
				else if (j==2){
					selector +=  attributes[i][j] == ''? '':'[data-playertype="'+attributes[i][j]+'"]';
				}
				else if (j==3){
					selector +=  attributes[i][j] == ''? '':'[data-battingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==4){
					selector +=  attributes[i][j] == ''? '':'[data-bowlingstyle="'+attributes[i][j]+'"]';
				}
				else if (j==5){
					selector +=  attributes[i][j] == ''? ',':'[data-bowlingtype="'+attributes[i][j]+'"],';
				}
			}
		}
		console.log(selector);
		$('#bowler_bowlerkey1').children('option').hide();
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).show();
		console.log($('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)));
		$('#bowler_bowlerkey1').trigger("liszt:updated");
	});
	

	
	$('#bowler_bowlerkey1').chosen().change(function() {
		bowlerkey1 = $(this).val() || [''];
		console.log(bowlerkey);
	});
	
	$('#team_teamkey1').change(function() {
		teamkey1 = $(this).val() || [''];
	});
	

	

	////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	
	var chartmetric = '';
	var chartgroup = '';
	var chartclickcount = 0;
	

	
	$('.charttype').live('click', function(){
		charttype = $(this).html();
		if (charttype == 'Column') {
			charttype = 'bars';
		}
		else if (charttype == 'Line') {
			charttype = 'line';
		}
		else if (charttype == 'Pie'){
			charttype = 'pie';
		}
		$('.charttype').css('opacity', '0.9');
		$(this).css('opacity', '0.7');
	});
	
	
	$('.tabletype a').live('click', function(){
		$('.tabletype a').css('opacity', '0.9');
		$(this).css('opacity', '0.7');
	});
	
	
	$('.tabletype a').live('mouseover', function(){
		//no color change
		$('.tabletype a').css('background-color', '#19197D');
	});
	
	$('.tabletype a').live('mouseout', function(){
		//
		$('.tabletype a').css('background-color', '#19197D');
		$('.tabletype a').css('opacity', '0.9');
	});
	

	var metricclickcount = 0;
	var groupclickcount = 0;

	$('.enable').live('click', function(){
		metricclickcount = metricclickcount + 1;
		
		if(metricclickcount == 1) {
			$('.metric').css('background-color', '#383838');
			$(this).css('background-color', 'steelblue');
		}
		if (metricclickcount > 1 && groupclickcount <2) {
			$('.metric').css('background-color', '#383838');
			$(this).css('background-color', 'steelblue');
			metricclickcount = 1;
		}
		else if (metricclickcount > 1 && groupclickcount == 2) {
			$('.groups,.metric').css('background-color', '#383838');
			$(this).css('background-color', 'steelblue');
			$('#container').html('');
			metricclickcount = 1;
			groupclickcount = 0;
		}
	
		
		metric =$(this).attr('data-metric');
		var temp = $('#lastXmatches').val();
		if (temp == ''){
			lastXmatches = -2;		
		}
		else {
			lastXmatches = parseInt(temp);
		}
		
		var temp1 = $('#lastXballs').val();
		if (temp1 == ''){
			lastXballs = -2;		
		}
		else {
			lastXballs = parseInt(temp1);
		}
		

		if (groupclickcount == 2 && metricclickcount == 1){
			jsonObj = {filters:{akey:analysis,ckey:countrykey, fkey:formatkey, tkey:tournamentkey, inn:inningkey,vkey:venuekey, ttkey:teamtypekey, tmkey:teamkey, mtkey:matchtypekey, chkey:coachkey, mkey:managerkey, ptname:playertypename, ekey:endkey, btkey:batsmankey, bts:battingstylename, bp:battingposition, st:shottypekey, sd:shotdirectionkey,pckey:pitchconditionkey,ckey1:countrykey1, fkey1:formatkey1, tkey1:tournamentkey1, inn1:inningkey1,vkey1:venuekey1, ttkey1:teamtypekey1, tmkey1:teamkey1, mtkey1:matchtypekey1, chkey1:coachkey1, mkey1:managerkey1, ptname1:playertypename1, ekey1:endkey1, blkey1:bowlerkey1, bts1:battingstylename1, bls1:bowlingstylename1, btn1:bowlingtypename1, bp1:battingposition1, blp1:bowlingposition1,  lk1:linekey1, lnk1:lengthkey1, bskey1:sidekey1, spkey1:spellkey1, pckey1:pitchconditionkey1,group1:group1, group2:group2, metric:metric, lxm:lastXmatches, lxb:lastXballs}};
			console.log(jsonObj);
			$.ajax({
				url: '/generate.json',
				type: 'get',
				data: jsonObj,
				cache: false,
				success: function(data, textStatus, jqXHR ) { 
					console.log('successful');
					google_chart_function(data);
					google_table_function(data);
					$('#container').show();
					$('#table_div').show();
				},
				error: function(jqXHR, textStatus, errorThrown){ 
					console.log('unsuccessful');
					alert('Too many filters. Reloading page...');
					//location.reload();
					$('#groupbybattingstyle').attr('src','/assets/battingstyle.png');
					$('#chartruns').attr('src','/assets/Runs.png');
				}
			});
		}
	});
	
	$('.groups').live('click', function(){
		groupclickcount = groupclickcount + 1;
		group = $(this).attr('data-group');
		
		if(groupclickcount == 1) {
			$(this).css('background-color', 'steelblue');
			group1 = group;
		}
		else if (groupclickcount == 2) {
			$(this).css('background-color', 'darkgray');
			group2 = group;
		}
		if (groupclickcount > 2 && metricclickcount == 0) {
			$('.groups').css('background-color', '#383838');
			$(this).css('background-color', 'steelblue');
			groupclickcount = 1;
			group1 = group;
			
		}
		else if ((groupclickcount > 2 && metricclickcount == 1) || (groupclickcount== 2 && metricclickcount > 1)) {
			$('.groups,.metric').css('background-color', '#383838');
			$(this).css('background-color', 'steelblue');
			groupclickcount = 1;
			metricclickcount = 0;
			group1 = group
		}

		var temp = $('#lastXmatches').val();
		if (temp == ''){
			lastXmatches = -2;		
		}
		else {
			lastXmatches = parseInt(temp);
		}
		
		var temp1 = $('#lastXballs').val();
		if (temp1 == ''){
			lastXballs = -2;		
		}
		else {
			lastXballs = parseInt(temp1);
		}
		
		if (groupclickcount == 2 && metricclickcount == 1){
			jsonObj = {filters:{akey:analysis,ckey:countrykey, fkey:formatkey, tkey:tournamentkey, inn:inningkey,vkey:venuekey, ttkey:teamtypekey, tmkey:teamkey, mtkey:matchtypekey, chkey:coachkey, mkey:managerkey, ptname:playertypename, ekey:endkey, btkey:batsmankey, bts:battingstylename, bp:battingposition, st:shottypekey, sd:shotdirectionkey,pckey:pitchconditionkey,ckey1:countrykey1, fkey1:formatkey1, tkey1:tournamentkey1, inn1:inningkey1,vkey1:venuekey1, ttkey1:teamtypekey1, tmkey1:teamkey1, mtkey1:matchtypekey1, chkey1:coachkey1, mkey1:managerkey1, ptname1:playertypename1, ekey1:endkey1, blkey1:bowlerkey1, bts1:battingstylename1, bls1:bowlingstylename1, btn1:bowlingtypename1, bp1:battingposition1, blp1:bowlingposition1,  lk1:linekey1, lnk1:lengthkey1, bskey1:sidekey1, spkey1:spellkey1, pckey1:pitchconditionkey1,group1:group1, group2:group2, metric:metric, lxm:lastXmatches, lxb:lastXballs}};
			$.ajax({
				url: '/generate.json',
				type: 'get',
				data: jsonObj,
				cache: false,
				success: function(data, textStatus, jqXHR ) { 
					console.log('successful');	

					google_chart_function(data);
					google_table_function(data);
					$('#container').show();
					$('#table_div').show();
					
				},
				error: function(jqXHR, textStatus, errorThrown){ 
					console.log('unsuccessful');
					alert('Too many filters. Reloading page...');
				}
			});
		}
	});
	
		
});

