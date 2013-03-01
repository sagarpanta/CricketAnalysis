$(document).ready(function(){
	$(".chzn-select").chosen();	
	var analysis = $('#analysis_analysiskey').val();
	
	var mapdata;
	var jsonObj_store = {};
	
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
	var anglekey1 = [''];
	
	////////////////
	
	var metric = '';
	var group1 = '';
	var group2 = '';
	var lastXmatches = -2;
	var lastXballs = -2;
	var firstXballs = -2;
	var frequency = 0;
	var frequency_click = 0;
	
	var video = 0;
	var video_click = 0;
	
	$(document).on('click', '#lastXballs',function(){
		firstXballs = $('#firstXballs').val();
		if (firstXballs!=''){
			alert('Cannot have values on both Last X balls and First X balls');
		}
	});
	
	$(document).on('click','#firstXballs', function(){
		lastXballs = $('#lastXballs').val();
		if (lastXballs!=''){
			alert('Cannot have values on both Last X balls and First X balls');
		}
	});
	
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
				mapdata = data;
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
	
	$('#country_countrykey').change(function() {
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
		//$('#batsman_batsmankey').children('option').hide();
		$('#batsman_batsmankey').children('option').attr('disabled' , 'disabled');
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
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
		$('#inning_inningkey').children('option').attr('disabled', 'disabled');
		var testmatch = 0;
		for(i=0;i<=formatkey.length;i++){
			console.log(formatkey[i]);
			if(formatkey[i]=="12"){
				testmatch = 1;
				$('#inning_inningkey').children('option').removeAttr('disabled');
				console.log($('#inning_inningkey').children('option'));
			}
			if(formatkey[i]!="12" && testmatch!="1"){
				$('#inning_inningkey').find('[value="1"],[value="2"]').removeAttr('disabled');
				console.log($('#inning_inningkey').children('option'));
			}
		}
		
		$('#batsman_batsmankey').children('option').attr('disabled' , 'disabled');
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
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
		$('#batsman_batsmankey').children('option').attr('disabled' , 'disabled');
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
		
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
		$('#batsman_batsmankey').children('option').attr('disabled' , 'disabled');
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
		
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
		$('#batsman_batsmankey').children('option').attr('disabled' , 'disabled');
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
		
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
		$('#batsman_batsmankey').children('option').attr('disabled' , 'disabled');
		$('#batsman_batsmankey').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
		
		$('#batsman_batsmankey').trigger("liszt:updated");
	});
	
	$('#batsman_batsmankey').change(function() {
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




	$('#country_countrykey1').change(function() {
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
		$('#bowler_bowlerkey1').children('option').attr('disabled' , 'disabled');
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
		$('#bowler_bowlerkey1').trigger("liszt:updated");
	});
	
	
	
	$('#matchformat_matchformatkey1').change(function() {
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
		$('#inning_inningkey1').children('option').attr('disabled', 'disabled');
		var testmatch = 0;
		for(i=0;i<=formatkey1.length;i++){
			console.log(formatkey1[i]);
			if(formatkey1[i]=="12"){
				testmatch = 1;
				$('#inning_inningkey1').children('option').removeAttr('disabled');
				console.log($('#inning_inningkey1').children('option'));
			}
			if(formatkey1[i]!="12" && testmatch!="1"){
				$('#inning_inningkey1').find('[value="1"],[value="2"]').removeAttr('disabled');
				console.log($('#inning_inningkey1').children('option'));
			}
		}
		console.log(selector.substring(0,selector.length-1));
		$('#bowler_bowlerkey1').children('option').attr('disabled' , 'disabled');
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
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
	
	$('#angle_anglekey1').change(function() {
		anglekey1 =  $(this).val() || [''];
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
		$('#bowler_bowlerkey1').children('option').attr('disabled' , 'disabled');
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
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
		$('#bowler_bowlerkey1').children('option').attr('disabled' , 'disabled');
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
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
		$('#bowler_bowlerkey1').children('option').attr('disabled' , 'disabled');
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
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
		$('#bowler_bowlerkey1').children('option').attr('disabled' , 'disabled');
		$('#bowler_bowlerkey1').children(selector.substring(0,selector.length-1)).removeAttr('disabled');
		$('#bowler_bowlerkey1').trigger("liszt:updated");
	});
	

	
	$('#bowler_bowlerkey1').change(function() {
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
	

	
	$('.charttype').on('click', function(){
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

		$('.charttype').css('opacity', '1');
		$(this).css('opacity', '0.7');
	});
	
	$('#frequency').on('click', function(){
		frequency_click += 1;
		if (frequency_click%2==1){
			frequency = 1;
			$(this).css('opacity', '0.7');
		}
		else{
			frequency = 0;
			$(this).css('opacity', '1');
		}
		console.log(frequency_click);
	});
	
	
	$('#showVideo').on('click', function(){
		video_click += 1;
		if (video_click%2==1){
			video = 1;
			$(this).css('opacity', '0.7');
			
			$('#container').html($('.replay').html());
			$('#container').css('background-image', "url(/assets/canvas_bg.png)").css('background-size', '100% 100%');
		}
		else{
			video = 0;
			$(this).css('opacity', '1');
			$('#container').css('background-image', "none");
			google_map_function(mapdata);
		}
		console.log(video_click);
	});
	
	
	
	$('.tabletype a').on('click', function(){
		$('.tabletype a').css('opacity', '1');
		$(this).css('opacity', '0.7');
	});
	
	
	$('.tabletype a').on('mouseover', function(){
		//no color change
		$(this).css('background-color', '#19197D');
	});
	
	$('.tabletype a').on('mouseout', function(){
		//
		$(this).css('background-color', '#19197D');
		$(this).css('opacity', '1');
	});

	$('.savetype a').on('click', function(){
		$('.savetype a').css('opacity', '1');
		$(this).css('opacity', '0.7');
	});
	
	
	$('.savetype a').on('mouseover', function(){
		//no color change
		$(this).css('background-color', '#19197D');
	});
	
	$('.savetype a').on('mouseout', function(){
		$(this).css('background-color', '#19197D');
		$(this).css('opacity', '1');
	});	

	$('#submit_report img').on('mouseover', function(){	
		$(this).attr('src','/assets/button-over.png');	
	});

	$('#submit_report img').on('mouseout', function(){
		$(this).attr('src','/assets/button.png');	
	});
	
	$('#submit_report img').on('click', function(){
		if (jsonObj_store['report']['akey'] == 'Batting' || jsonObj_store['report']['akey'] == 'Bowling') {	
			jsonObj_store['report']['reportname'] = $('#save').val();
			$.ajax({
				url: '/reports',
				type: 'post',
				data: jsonObj_store,
				cache: false,
				success: function(data, textStatus, jqXHR ) { 
					console.log('successful');
				},
				error: function(jqXHR, textStatus, errorThrown){ 
					console.log('unsuccessful');
					$(this).attr('src','/assets/button.png');	
				}
			});		
		}
		else{
			alert('Cannot Save Report. Please Select Group/s and Metric');s
		}
		
	});
	
	
	//******************Videos from external application (for eg T20 Pro) *****************
	
	var URL = window.URL || window.webkitURL;
	var videoNode;
	var sources = [];
	var sources_names = [];
	var playable = [];
	var imageplayable = [];
	

	var inputNode = document.getElementById('t20provideoinput');
	//var groupElement = document.getElementsByClassName('metric')[0];
	var triggerElement = document.getElementById('trigger');

	var loadSelectedFiles = function playSelectedFileInit(event) {
			for(var i=0; i<this.files.length; i++){
				var file = this.files[i];

				var type = file.type;

				var fileURL = URL.createObjectURL(file);

				sources.push(fileURL);
				sources_names.push(file.name);
			}
			
			//console.log(sources_names);
			//console.log(sources);
							
		};
		
	var playExternalVideos = function(vid_array){
		var j = 1;
		var playlist = [];
		
		$('#container').remove('#t20provideo');
		$('#container').html('<video id="t20provideo" autoplay></video>');
		var videoNode = document.querySelector('video');
		var counter = 0;
		for (var i=0;i<vid_array.length; i++){

			if ($.inArray(vid_array[i], sources_names) > -1){
				playlist.push(sources[$.inArray(vid_array[i], sources_names)]);
			}
		}	
		
		videoNode.src = playlist[0];
		videoNode.load();
		videoNode.play();
		videoNode.addEventListener('ended', function(){
			if (j==playlist.length){
				playable = [];
				playlist = [];
				j = 1;
			}
		   //videoNode.src = sources[j++];	
		   if (j< playlist.length){
				videoNode.src = playlist[j++];
				videoNode.load();
				videoNode.play();
		    }
		}, false);
	};
																																																																																																																																																																																																																																																																																									  
					   
		if (inputNode != null) { 
			inputNode.addEventListener('change', loadSelectedFiles, false);
		}

	
	//*******************************************************************************
	
	var metricclickcount = 0;
	var groupclickcount = 0;

	$(document).on('click','.enable', function(){
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
		
		var temp2 = $('#firstXballs').val();
		if (temp2 == ''){
			firstXballs = -2;		
		}
		else {
			firstXballs = parseInt(temp2);
		}
		

		if (groupclickcount == 2 && metricclickcount == 1){
			jsonObj = {filters:{akey:analysis,ckey:countrykey, fkey:formatkey, tkey:tournamentkey, inn:inningkey,vkey:venuekey, ttkey:teamtypekey, tmkey:teamkey, mtkey:matchtypekey, chkey:coachkey, mkey:managerkey, ptname:playertypename, ekey:endkey, btkey:batsmankey, bts:battingstylename, bp:battingposition, st:shottypekey, sd:shotdirectionkey,pckey:pitchconditionkey,ckey1:countrykey1, fkey1:formatkey1, tkey1:tournamentkey1, inn1:inningkey1,vkey1:venuekey1, ttkey1:teamtypekey1, tmkey1:teamkey1, mtkey1:matchtypekey1, chkey1:coachkey1, mkey1:managerkey1, ptname1:playertypename1, ekey1:endkey1, blkey1:bowlerkey1, bts1:battingstylename1, bls1:bowlingstylename1, btn1:bowlingtypename1, bp1:battingposition1, blp1:bowlingposition1,  lk1:linekey1, lnk1:lengthkey1, bskey1:sidekey1, spkey1:spellkey1, pckey1:pitchconditionkey1,ankey1:anglekey1,group1:group1, group2:group2, metric:metric, lxm:lastXmatches, lxb:lastXballs, fxb:firstXballs, fq:frequency, vid:video}};	
			var userkey = $('#userkey').html(); 
			$.ajax({
				url: '/generate.json',
				type: 'get',
				data: jsonObj,
				cache: false,
				success: function(data, textStatus, jqXHR ) { 
					jsonObj_store={report:{clnkey:userkey, akey:analysis,ckey:countrykey.join(), fkey:formatkey.join(), tkey:tournamentkey.join(), inn:inningkey.join(),vkey:venuekey.join(), ttkey:teamtypekey.join(), tmkey:teamkey.join(), mtkey:matchtypekey.join(), chkey:coachkey.join(), mkey:managerkey.join(), ptname:playertypename.join(), ekey:endkey.join(), btkey:batsmankey.join(), bts:battingstylename.join(), bp:battingposition.join(), st:shottypekey.join(), sd:shotdirectionkey.join(),pckey:pitchconditionkey.join(),ckey1:countrykey1.join(), fkey1:formatkey1.join(), tkey1:tournamentkey1.join(), inn1:inningkey1.join(),vkey1:venuekey1.join(), ttkey1:teamtypekey1.join(), tmkey1:teamkey1.join(), mtkey1:matchtypekey1.join(), chkey1:coachkey1.join(), mkey1:managerkey1.join(), ptname1:playertypename1.join(), ekey1:endkey1.join(), blkey1:bowlerkey1.join(), bts1:battingstylename1.join(), bls1:bowlingstylename1.join(), btn1:bowlingtypename1.join(), bp1:battingposition1.join(), blp1:bowlingposition1.join(),  lk1:linekey1.join(), lnk1:lengthkey1.join(), bskey1:sidekey1.join(), spkey1:spellkey1.join(), pckey1:pitchconditionkey1.join(),ankey1:anglekey1.join(),group1:group1, group2:group2, metric:metric, lxm:lastXmatches, lxb:lastXballs, fxb:firstXballs, fq:frequency, vid:video, charttype:charttype}};	
					console.log('successful');
					if (video==1){
						playable = [];
						imageplayable = [];
						for(var i=0; i<data.length; i++){
							var _length = data[i]['val'].length;
							if (data[i]['val'].substring(_length-3, _length) == 'mp4') {
								playable.push(data[i]['val']);
							}
							else{
								imageplayable.push(data[i]['val']);
								//replayVideo(0, data[i]['val']);
							}	
						}
						$('#container').html($('.replay').html());
						for (var i=0; i<imageplayable.length;i++){
							replayVideo(0, imageplayable[i], i, data.length-1);
						}
						//playExternalVideos(playable);
						if (imageplayable.length == 0){
							replayVideo(0, 'nonimage', 0,0);
						}
	
					}
					else{
						google_chart_function(data);
						google_table_function(data);
						$('#container').show();
						$('#table_div').show();
					}

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
	
	$(document).on('click', '.groups',function(){
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
		
		var temp2 = $('#firstXballs').val();
		if (temp2 == ''){
			firstXballs = -2;		
		}
		else {
			firstXballs = parseInt(temp2);
		}
		
		if (groupclickcount == 2 && metricclickcount == 1){
			jsonObj = {filters:{akey:analysis,ckey:countrykey, fkey:formatkey, tkey:tournamentkey, inn:inningkey,vkey:venuekey, ttkey:teamtypekey, tmkey:teamkey, mtkey:matchtypekey, chkey:coachkey, mkey:managerkey, ptname:playertypename, ekey:endkey, btkey:batsmankey, bts:battingstylename, bp:battingposition, st:shottypekey, sd:shotdirectionkey,pckey:pitchconditionkey,ckey1:countrykey1, fkey1:formatkey1, tkey1:tournamentkey1, inn1:inningkey1,vkey1:venuekey1, ttkey1:teamtypekey1, tmkey1:teamkey1, mtkey1:matchtypekey1, chkey1:coachkey1, mkey1:managerkey1, ptname1:playertypename1, ekey1:endkey1, blkey1:bowlerkey1, bts1:battingstylename1, bls1:bowlingstylename1, btn1:bowlingtypename1, bp1:battingposition1, blp1:bowlingposition1,  lk1:linekey1, lnk1:lengthkey1, bskey1:sidekey1, spkey1:spellkey1, pckey1:pitchconditionkey1,ankey1:anglekey1,group1:group1, group2:group2, metric:metric, lxm:lastXmatches, lxb:lastXballs, fxb:firstXballs, fq:frequency, vid:video}};
			$.ajax({
				url: '/generate.json',
				type: 'get',
				data: jsonObj,
				cache: false,
				success: function(data, textStatus, jqXHR ) { 
					console.log('successful');	

					if (video==1){
						replayVideo(0, data[i]['val']);
					}
					else{
						google_chart_function(data);
						google_table_function(data);
						$('#container').show();
						$('#table_div').show();
					}	
					
				},
				error: function(jqXHR, textStatus, errorThrown){ 
					console.log('unsuccessful');
					alert('Too many filters. Reloading page...');
				}
			});
		}
	});
	
	
	//***************************************************
		var fileSystem = null; // file system 
		var error = 0; // if file system API error
		var frames = 0; // index for the image files (files0 files1 etc)
		var _files = []; // store the path of the images recoreded
		
		function errorHandler(err){
		error =1 ;
		 var msg = 'An error occured: ';
			switch (err.code) {
				case FileError.NOT_FOUND_ERR:
					msg += 'File or directory not found';
					break;
		 
				case FileError.NOT_READABLE_ERR:
					msg += 'File or directory not readable';
					break;
		 
				case FileError.PATH_EXISTS_ERR:
					msg += 'File or directory already exists';
					break;
		 
				case FileError.TYPE_MISMATCH_ERR:
					msg += 'Invalid filetype';
					break;
		 
				default:
					msg += 'Unknown Error';
					break;
			};
		 
		 console.log(msg);
		};
	
	function onInitFs(fs) {
		fileSystem = fs;
		fs.root.getDirectory('Video', {create: true, exclusive:false}, function(dirEntry) {
			console.log('You have just created the ' + dirEntry.name + ' directory.');
			
			var page = $('#analysis_page').html();
			if(page!= undefined){
				//document.getElementById('_runs').addEventListener('click', replayVideo, false);
			}
	 
			fs.root.getDirectory('Video', {}, function(dirEntry){
			  var dirReader = dirEntry.createReader();
			  dirReader.readEntries(function(entries) {
				for(var i = 0; i < entries.length; i++) {
				  var entry = entries[i];
				  if (entry.isDirectory){
					console.log('Directory: ' + entry.fullPath);
				  }
				  else if (entry.isFile){
					//console.log('File: ' + entry.fullPath);
				  // remove comment to delete all files
					_files.push(entry.fullPath);
					frames = parseInt(entry.fullPath[entry.fullPath.length-1]);
				  }
				}
				_files = _files.sort();
			  }, errorHandler);
			}, errorHandler);
		}, errorHandler);
	}
	
	
		var replayVideo = function(idx, filename_part, i, len) {
			// reads through all the images and show them (image path stored in _files)
			if(idx.clientX) idx = 0;
			if(_files[idx] === undefined || (i==len && idx==_files.length)) {
				playExternalVideos(playable);
				//alert('nothing to play');
				return;
			}
			var img = document.getElementById('replay-screen');
			fileSystem.root.getFile(_files[idx], {}, function(fileEntry) {
				fileEntry.file(function(file) {
					var reader = new FileReader();
					reader.onloadend = function(e) {
						if(_files[idx].indexOf(filename_part) != -1){img.src = this.result; console.log(_files[idx].indexOf(filename_part));}
						if(++idx <= _files.length)
							{setInterval(replayVideo(idx, filename_part), 2*1000);} // y u no work !?
						/*if(idx == _files.length){
							playExternalVideos(playable);
						}*/
							
					};
					reader.readAsText(file);
				}, errorHandler);
			}, errorHandler);
		}

	window.requestFileSystem  = window.requestFileSystem || window.webkitRequestFileSystem;
	//window.requestFileSystem(window.TEMPORARY, 10*1024*1024, initFs, errorHandler);
	window.webkitStorageInfo.requestQuota(PERSISTENT, 1024*1024*1024, function(grantedBytes) {
		window.requestFileSystem(PERSISTENT, grantedBytes, onInitFs, errorHandler);
	});
	
		
});

