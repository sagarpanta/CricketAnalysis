$(document).on('ready page:load', function () {

	var original_data = [];
	
	$('#reports tr').mouseover(function(){
		$(this).children('td').css('background-color','#65B8C9').css('color', 'black');
	});
	
	$('#reports tr').mouseout(function(){
		$(this).children('td').css('background-color','black').css('color', 'white');
	});
	
	$('.back_to_reports img').on('mouseover', function(){
		$(this).attr('src', '/assets/back_over.png');
	});
	
	$('.back_to_reports img').on('mouseout', function(){
		$(this).attr('src', '/assets/back.png');
	});
	
	$('.tag_clicked').on('click', function(){
		tag = $(this).html();
		$('[data-tag="All"]').parent().hide();
		console.log(tag);
		$('[data-tag1="'+tag+'"]').parent().show();
		$('[data-tag2="'+tag+'"]').parent().show();
		$('[data-tag3="'+tag+'"]').parent().show();
		$('[data-tag="'+tag+'"]').parent().show();
	
	});
	
	
	
	var google_table_function =  function drawVisualization(chartdata) {
		$('#charttable').css('display', 'block');
        var data = google.visualization.arrayToDataTable(chartdata);
        var table = new google.visualization.Table(document.getElementById('charttable'));
        table.draw(data, {showRowNumber: true});
      }	
	
	
	var google_chart_function =  function drawVisualization(chartdata, group1, group2, charttype) {
        // Some raw data (not necessarily accurate)
		$('#reportcontainer').css('display', 'block').css('margin', '0 auto');
		$('#reports').hide();
		$('#navigations').hide();
		$('.back_to_reports').show();
        var data = google.visualization.arrayToDataTable(chartdata);
		var _title = '';
		if (group1 == group2){
			_title =  metric.toUpperCase()+' GROUPED BY '+group1.toUpperCase();
		}
		else{
			_title =  metric.toUpperCase()+' GROUPED BY '+group1.toUpperCase()+ ' BY ' + group2.toUpperCase();
		}
		
		$('h3').html(_title);
		
        var options = {
          title : _title,
		  titleTextStyle:  {color: 'darkgray', fontName: 'verdana', fontSize: 9},
          vAxis: {title: metric, titleTextStyle: {fontSize: 9}},
          hAxis: {title: group1, textStyle: {fontSize: 9}, titleTextStyle: {fontSize: 9}},
		  legend: {position: 'right', textStyle: {fontSize: 10}},
		  height: 375,
          seriesType: charttype,
          series: {1000: {type: "line"}}
        };
		
		var chart;
		if (charttype == 'pie') {
			chart = new google.visualization.PieChart(document.getElementById('reportcontainer'));
		}
		else if (charttype == 'bars' || charttype == 'line'){
			chart = new google.visualization.ComboChart(document.getElementById('reportcontainer'));
		}
		console.log(charttype);
        chart.draw(data, options);
      }	
	
	$(document).on('click', '.view_report', function(){
		var id = $(this).attr('data-id');
		$('#tags').hide();
		$.ajax({
			url: '/reports/'+id+'.json',
			type: 'get',
			cache: false,
			success: function(data, textStatus, jqXHR ) { 
				console.log('successful');
				
				
				var _table = '<table><tbody><tr>';
				var counter = 1;
				$.each(data, function(key, value) {
					if(key != 'fcount' && key != 'report'){
						if (counter%3 != 0){
							_table = _table + '<td>'+key+' : '+ value.substring(0,value.length-1)+'</td>';
						}
						else{
							_table = _table + '<td>'+key+' : '+ value.substring(0,value.length-1)+'</td>';
							_table = _table+'</tr><tr>';
						}
						counter=counter+1;
					}
					
				});
				_table = _table+'</tr></tbody></table>';
				$('#filters').html(_table);		
				/*
				for(var i=1; i<=data['fcount'];i++){
					if data[]%3<>0{
						_table = _table + '<td><%= key %>: <%= value %></td>';
					}
					_table = _table + '</tr><tr>';
					counter = counter+1;
				}
				_table = _table+'</tr></tbody></table>';


				$('#filters').html(_table);				
				*/
				
				var obj = {};
				obj['akey'] = data['report']['akey'];
				obj['ckey'] = data['report']['ckey'].split(',');
				obj['fkey'] = data['report']['fkey'].split(',');
				obj['tkey'] = data['report']['tkey'].split(',');
				obj['inn'] = data['report']['inn'].split(',');
				obj['vkey'] = data['report']['vkey'].split(',');
				obj['ttkey'] = data['report']['ttkey'].split(',');
				obj['tmkey'] = data['report']['tmkey'].split(',');
				obj['mtkey'] = data['report']['mtkey'].split(',');
				obj['chkey'] = data['report']['chkey'].split(',');
				obj['mkey'] = data['report']['mkey'].split(',');
				obj['ptname'] = data['report']['ptname'].split(',');
				obj['ekey'] = data['report']['ekey'].split(',');
				obj['btkey'] = data['report']['btkey'].split(',');
				obj['bts'] = data['report']['bts'].split(',');
				obj['bp'] = data['report']['bp'].split(',');
				obj['st'] = data['report']['st'].split(',');
				obj['sd'] = data['report']['sd'].split(',');
				obj['pckey'] = data['report']['pckey'].split(',');
				obj['ckey1'] = data['report']['ckey1'].split(',');
				obj['fkey1'] = data['report']['fkey1'].split(',');
				
				obj['tkey1'] = data['report']['tkey1'].split(',');
				obj['inn1'] = data['report']['inn1'].split(',');
				obj['vkey1'] = data['report']['vkey1'].split(',');
				obj['ttkey1'] = data['report']['ttkey1'].split(',');
				obj['tmkey1'] = data['report']['tmkey1'].split(',');
				obj['mtkey1'] = data['report']['mtkey1'].split(',');
				obj['chkey1'] = data['report']['chkey1'].split(',');
				obj['mkey1'] = data['report']['mkey1'].split(',');
				obj['ptname1'] = data['report']['ptname1'].split(',');
				obj['ekey1'] = data['report']['ekey1'].split(',');
				
				obj['blkey1'] = data['report']['blkey1'].split(',');
				obj['bts1'] = data['report']['bts1'].split(',');
				obj['bls1'] = data['report']['bls1'].split(',');
				obj['btn1'] = data['report']['btn1'].split(',');
				obj['bp1'] = data['report']['bp1'].split(',');
				obj['blp1'] = data['report']['blp1'].split(',');
				obj['lk1'] = data['report']['lk1'].split(',');
				obj['lnk1'] = data['report']['lnk1'].split(',');
				obj['bskey1'] = data['report']['bskey1'].split(',');
				obj['spkey1'] = data['report']['spkey1'].split(',');
				obj['pckey1'] = data['report']['pckey1'].split(',');
				
				obj['ankey1'] = data['report']['ankey1'].split(',');
				obj['group1'] = data['report']['group1'];
				obj['group2'] = data['report']['group2'];
				//obj['metric'] = data['report']['metric'];
				obj['lxm'] = data['report']['lxm'];
				obj['lxb'] = data['report']['lxb'];
				obj['fxb'] = data['report']['fxb'];
				obj['fq'] = data['report']['fq'];
				obj['vid'] = data['report']['vid'];
				
				obj['tag1'] = data['report']['tag1'];
				obj['tag2'] = data['report']['tag2'];
				obj['tag3'] = data['report']['tag3'];
				
				var charttype = data['report']['charttype'];
				var metrices = data['report']['metric'].split(',');
				if(metrices.length>1){metrices.pop();}
				var counter = 0;
				for(var i=0;i< metrices.length;i++)
				{
					obj['metric'] = metrices[i];
				
					var jsonObj = {};
					jsonObj['filters'] = obj;
					$.ajax({
						url: '/generate.json',
						type: 'get',
						data: jsonObj,
						cache: false,
						success: function(data, textStatus, jqXHR ) { 
							//console.log(data);
							group1 = obj['group1'];
							group2 = obj['group2'];
							metric = obj['metric'];
							console.log('successful');
							if(counter > 0){
								console.log('**********************'+counter);
								for(var j=0; j<data.length; j++){
									original_data[j].push(data[j][1]);	
								}
								data = original_data;
							}
							
							
							original_data = data;
							counter++;
							if(counter > metrices.length){
								original_data = [];
								counter=0;	
								alert()
							}
							//show only after all metric are added
							else if(counter == metrices.length){
								google_chart_function(data, group1, group2, charttype);
								google_table_function(data);
								$('#container').show();
								$('#table_div').show();
							}
						},
						error: function(jqXHR, textStatus, errorThrown){ 
							console.log('unsuccessful');
							console.log(jqXHR);
							console.log(textStatus);
							console.log(errorThrown);
							alert('Too many filters. Reloading page...');
						}
					});
				}
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
				$(this).attr('src','/assets/button.png');	
			}
		});	
	});
	
	
	$('.back_to_reports').on('click', function(){
		$('#navigations').show();
		$('#reports').show();
		$(this).hide();
		$('#reportcontainer').hide();
		$('#charttable').hide();
		$('h3').html('');
		$('#filters').html('');
		$('#tags').show();
		
	});
	
});