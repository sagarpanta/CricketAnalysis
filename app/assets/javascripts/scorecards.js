$(document).ready(function(){
	var dblclicked = 0;
	
	$('.Batsman').live('click', function(){
		if (dblclicked%2 == 0){
			$('.Batsman').removeClass('hilite');
			$(this).removeClass('hilite-nonstriker');
			$(this).addClass('hilite');
			//console.log(this);
		}
		else {
			$('.Batsman').removeClass('hilite-nonstriker');
			$(this).removeClass('hilite');
			$(this).addClass('hilite-nonstriker');
			//console.log(this);
		}
		dblclicked = dblclicked+1;
		
	});
	
	

	$('.Bowler').live('click', function(event){
		$('.Bowler').removeClass('hilite');
		$(this).addClass('hilite');
	});
	
	$('.highlight').hover(function() {
		$(this).css('background-color', 'steelblue');
	});
	
	$('.highlight').mouseout(function() {
		$(this).css('background-color', 'black');
	});
	
	$("#batsmansort tbody").sortable();
	$("#bowlersort tbody").sortable();
	
	
	
	//***************************************************************************************************************************
		var runs_string;
		var batsmanid, batsmankey, clientkey;
		var bowlerid;
		var runs = 0, zeros = 0, ones = 0, twos = 0, threes = 0, fours = 0, fives=0, sixes = 0, sevens = 0, eights = 0, others = 0, outbywk = -2, formatkey = 0;
		var wides = 0, noballs=0, byes=0, legbyes=0, ballsdelivered = 0, ballsfaced = 0, maiden = 0;
		var ballsbeforeboundary = 0, ballsbeforerun = 0, dbx= 0, dbr= 0, dbb = 0;
		var fielderkey = -2, bowlerkey = -2, currentbowlerkey = -2, currentstrikerkey = -2, currentnonstrikerkey = -2;
		var dismissedbatsmankey = -2,bowlerkey = -2, outbatsmankey = -2;
		var wicket = 0;
		var dismissaltypekey = -2, teamoneid = -2, teamtwoid =-2, venuekey = -2;
		var inningballcounter = 0;
		var maidenovercounter = 0;
		var scoring_number_clicked = 0;
		var rclicked = 0, wclicked = 0, nclicked = 0, bclicked =0, lbclicked=0;
		var line = 0, length= 0, shottype = 0;
		var bowling_side = -2;
		var freehit = 0;
		
		
		clientkey = $('#clientkey').html();

		
	$('.scoring_numbers').live('click', function(){
		runs_string = $(this).html();
		$('.scoring_numbers').removeAttr('scoring_number_clicked');
		$('.scoring_numbers').css('opacity', '0.9')
		$(this).css('opacity', '0.7').addClass('scoring_number_clicked');
	});
	
	$('.scoring_numbers').live('hover', function(){
		$(this).css('opacity', '0.7');
		
	});
	
	$('.scoring_numbers').live('mouseout', function(){
		if ($(this).attr('class') == 'scoring_numbers scoring_number_clicked'){
			$(this).css('opacity', '0.7');
		}
		else {
			$(this).css('opacity', '0.9');
		}
	});
	
	$( "#dialog-form" ).dialog({
		autoOpen: false,
		height: 400,
		width: 500,
		modal: true
	});
	
	
	
	$('#btn-submit').live('click', function(){
		$( "#dialog-form" ).dialog('close');
		$('#shottype_shottypekey').val('').trigger('liszt:updated');
		line = line;
		length = length;
		shottype = shottype;
		$('.dialog_td1').css('background-color', 'lightgrey');
		$('.dialog_td2').css('background-color', 'lightgrey');
	});
	
	$('#btn-cancel').live('click', function(){
		$( "#dialog-form" ).dialog('close');
		line = 0;
		length = 0;
		shottype = 0;
		ballsdelivered = 0;
		ballsfaced=0;
		runs = ones = twos = threes = fours = fives = sixes = 0;
	});
	

	
	$('.dialog_td1').live('click', function(){
		$('.dialog_td1').css('background-color', 'lightgrey');
		$(this).css('background-color', 'steelblue');
		line = $(this).attr('data-line');
	});

	$('.dialog_td2').live('click', function(){
		$('.dialog_td2').css('background-color', 'lightgrey');
		$(this).css('background-color', 'steelblue');
		length = $(this).attr('data-length');
	});
	
	$('#shottype_shottypekey').chosen().change(function() {
		var val = $(this).val();
		if (val == null){
			shottype = 0;
		}
		else {
			shottype = parseInt($(this).val()[0]);
		}
	});
	
	
	$('.bowling_side ul li').live('click', function(){
		$('.bowling_side ul li').css('opacity', '0.9');
		$('.bowling_side ul li').removeClass('side');
		$(this).css('opacity', '0.6');	
		$(this).addClass('side');
	});
	
	
	$('#runs').live('mouseover', function(){
		if (rclicked!=1){
			$(this).children('img').attr('src','/assets/up-over.png');	
		}
	});

	$('#runs').live('mouseout', function(){
		if (rclicked!=1){
			$(this).children('img').attr('src','/assets/up.png');	
		}
		
	});
	

	$('#runs').live('click', function(){
		rclicked = 1;
		console.log('clicked');
		$('#wides').children('img').attr('src','/assets/up.png');
		$('#noballs').children('img').attr('src','/assets/up.png');
		$('#byes').children('img').attr('src','/assets/up.png');
		$('#legbyes').children('img').attr('src','/assets/up.png');
		$(this).children('img').attr('src','/assets/up-over.png');
		switch(runs_string){
			case "0":
				runs = 0;
				zeros=1;
				maidenovercounter = maidenovercounter+ 1;
				break;
			case "1":
				runs = 1;
				ones = 1;
				maidenovercounter = 0;
				break;
			case "2":
				runs = 2;
				twos = 1;	
				maidenovercounter = 0;
				break;
			case "3":
				runs = 3;
				threes = 1;
				maidenovercounter = 0;				
				break;
			case "4":
				runs = 4;
				fours = 1;
				maidenovercounter = 0;
				break;
			case "5":
				runs = 5;
				fives = 1;
				maidenovercounter = 0;
				break;
			case "6":
				runs = 6;
				sixes = 1;
				maidenovercounter = 0;
				break;
			case "7":
				runs = 7;
				sevens = 1;
				maidenovercounter = 0;
				break;
			case "8":
				runs = 8;
				eights = 1;
				maidenovercounter = 0;
				break;
		}
		if (noballs==1){
			ballsdelivered = 0;
		}
		else{
			ballsdelivered = 1;
		}
		ballsfaced = 1;
		$( "#dialog-form" ).dialog( "open" ); 
	});
	
	$('#wides').live('mouseover', function(){
		if (wclicked!=1){
			$(this).children('img').attr('src','/assets/up-over.png');	
		}
	});

	$('#wides').live('mouseout', function(){
		if (wclicked!=1){
			$(this).children('img').attr('src','/assets/up.png');	
		}
		
	});
	
	$('#wides').live('click', function(){
		wclicked = 1;
		$('#runs').children('img').attr('src','/assets/up.png');
		$('#noballs').children('img').attr('src','/assets/up.png');
		$('#byes').children('img').attr('src','/assets/up.png');
		$('#legbyes').children('img').attr('src','/assets/up.png');
		$(this).children('img').attr('src','/assets/up-over.png');
		switch(runs_string){
			case "1":
				wides = 1;
				ones = 0;
				break;
			case "2":
				wides = 2;
				twos = 0;
				break;
			case "3":
				wides = 3;
				threes = 0;
				break;
			case "4":
				wides = 4;
				fours = 0;
				break;
			case "5":
				wides = 5;
				fives = 0;
				break;
			case "6":
				wides = 6;
				sixes = 0;
				break;
		}
		maidenovercounter = 0;
		//$( "#dialog-form" ).dialog( "open" ); 
	});
	
	$('#noballs').live('mouseover', function(){
		if (nclicked!=1){
			$(this).children('img').attr('src','/assets/up-over.png');	
		}
	});

	$('#noballs').live('mouseout', function(){
		if (nclicked!=1){
			$(this).children('img').attr('src','/assets/up.png');	
		}
		
	});
	
	$('#noballs').live('click', function(){
		nclicked = 1;
		$('#runs').children('img').attr('src','/assets/up.png');
		$('#wides').children('img').attr('src','/assets/up.png');
		$('#byes').children('img').attr('src','/assets/up.png');
		$('#legbyes').children('img').attr('src','/assets/up.png');
		$(this).children('img').attr('src','/assets/up-over.png');
		noballs = 1
		ballsfaced = 1
		ballsdelivered = 0;
		maidenovercounter = 0;
		//$( "#dialog-form" ).dialog( "open" ); 
	});
	
	$('#byes').live('mouseover', function(){
		if (bclicked!=1){
			$(this).children('img').attr('src','/assets/up-over.png');	
		}
	});

	$('#byes').live('mouseout', function(){
		if (bclicked!=1){
			$(this).children('img').attr('src','/assets/up.png');	
		}
		
	});
	
	$('#byes').live('click', function(){
		bclicked = 1;
		$('#runs').children('img').attr('src','/assets/up.png');
		$('#wides').children('img').attr('src','/assets/up.png');
		$('#noballs').children('img').attr('src','/assets/up.png');
		$('#legbyes').children('img').attr('src','/assets/up.png');
		$(this).children('img').attr('src','/assets/up-over.png');
		switch(runs_string){
			case "1":
				byes = 1;
				ones = 1;
				break;
			case "2":
				byes = 2;
				twos = 1;
				break;
			case "3":
				byes = 3;
				threes = 1;
				break;
			case "4":
				byes = 4;
				fours = 1;
				break;
			case "5":
				byes = 5;
				fives = 1;
				break;
			case "6":
				byes = 6;
				sixes = 1;
				break;
		}
		if (noballs==1){
			ballsdelivered = 0;
		}
		else{
			ballsdelivered = 1;
		}
		ballsfaced = 1
		maidenovercounter = 0;
		$( "#dialog-form" ).dialog( "open" ); 
	});
	
	$('#legbyes').live('mouseover', function(){
		if (lbclicked!=1){
			$(this).children('img').attr('src','/assets/up-over.png');	
		}
	});

	$('#legbyes').live('mouseout', function(){
		if (lbclicked!=1){
			$(this).children('img').attr('src','/assets/up.png');	
		}
	});
	
	$('#legbyes').live('click', function(){
		lbclicked = 1;
		$('#runs').children('img').attr('src','/assets/up.png');
		$('#wides').children('img').attr('src','/assets/up.png');
		$('#noballs').children('img').attr('src','/assets/up.png');
		$('#byes').children('img').attr('src','/assets/up.png');
		$(this).children('img').attr('src','/assets/up-over.png');
		switch(runs_string){
			case "1":
				legbyes = 1;
				ones = 1
				break;
			case "2":
				legbyes = 2;
				twos = 1;
				break;
			case "3":
				legbyes = 3;
				threes = 1;
				break;
			case "4":
				legbyes = 4;
				fours = 1;
				break;
			case "5":
				legbyes = 5;
				fives = 1;
				break;
			case "6":
				legbyes = 6;
				sixes = 1;
				break;
		}
		if (noballs==1){
			ballsdelivered = 0;
		}
		else{
			ballsdelivered = 1;
		}
		ballsfaced = 1
		maidenovercounter = 0;
		$( "#dialog-form" ).dialog( "open" ); 
	});
	
	$('.Dismissaltype').change(function() {
		console.log($('.Dismissaltype'));
		dismissaltypekey = $(this).children('select').children('option:selected').val() ;
		if (dismissaltypekey == 1 || dismissaltypekey == 8){
			$(this).parent().children('.fielder').children('select').attr('disabled', 'disabled');
			$(this).parent().children('.wktakingbowler').children('select').removeAttr('disabled');
		}
		else if (dismissaltypekey == 5 || dismissaltypekey == 6 || dismissaltypekey == 7) {
			$(this).parent().children('.fielder').children('select').attr('disabled', 'disabled');
			$(this).parent().children('.wktakingbowler').children('select').attr('disabled', 'disabled');
		}
		else if (dismissaltypekey == 2 || dismissaltypekey == 3) {
			$(this).parent().children('.fielder').children('select').removeAttr('disabled');
			$(this).parent().children('.wktakingbowler').children('select').removeAttr('disabled');
		}
		else if (dismissaltypekey == 4) {
			$(this).parent().children('.wktakingbowler').children('select').attr('disabled', 'disabled');
			$(this).parent().children('.fielder').children('select').removeAttr('disabled');
		}
		dismissedbatsmankey = $(this).parent().children('.Batsmanid').html();
		outbatsmankey = $(this).parent().children('.Batsmankey').html();
		
		console.log(outbastmankey);

	});
	
	$('.fielder').change(function() {
		fielderkey = $(this).parent().children('.fielder').children('select').children('option:selected').val();
		//console.log($(this).parent().children('.fielder').children('select').children('option:selected').val());
	});
	
	
	var end1 = $('#end_battingend').children('option').find('selected')	.val();
	var end2 = $('#end_bowlingend').children('option').find('selected').val();
	
	$('#end_battingend').change(function(){
		var newend  = $(this).children('option:selected').val();
		var newendname = $(this).children('option:selected').html();
		var oldend = $('#end_battingend').find('[selected="selected"]').val();

		$('#end_battingend').find('[selected="selected"]').removeAttr('selected');
		$(this).find('[value="'+newend+'"]').attr('selected','selected');
		
		var nonselectedend = $('#end_bowlingend').find('[value="'+oldend+'"]');
		$('#end_bowlingend').find('[selected="selected"]').val(newend);
		$('#end_bowlingend').find('[selected="selected"]').html(newendname);
		$('#end_bowlingend').find('[selected="selected"]').removeAttr('selected');
		
		$(nonselectedend).attr('selected', 'selected');
		
		/*battingendkey = newend;
		bowlingendkey = oldend;*/
		

		
	});
	
	$('#end_bowlingend').change(function(){
		var newend  = $(this).children('option:selected').val();
		var oldend = $('#end_bowlingend').find('[selected="selected"]').val();
		
		
		$('#end_bowlingend').find('[selected="selected"]').removeAttr('selected');
		$(this).find('[value="'+newend+'"]').attr('selected','selected');
		
		var nonselectedend = $('#end_battinggend').find('[value="'+oldend+'"]');
		$('#end_battinggend').find('[selected="selected"]').val(newend);
		$('#end_battinggend').find('[selected="selected"]').html(newend);
		$('#end_battinggend').find('[selected="selected"]').removeAttr('selected');
		
		$(nonselectedend).attr('selected', 'selected');
		
		/*bowlingendkey = newend;
		battingendkey = oldend;*/
		
	});

	$('#submit_runs').live('mouseover', function(){	
		$(this).children('img').attr('src','/assets/button-over.png');	
		$('#submit_caption').css('top', 10);
	});

	$('#submit_runs').live('mouseout', function(){
		$(this).children('img').attr('src','/assets/button.png');	
		$('#submit_caption').css('top', 7);
	});
	
	$('#submit_runs').live('click', function(){
		$(this).children('img').attr('src','/assets/button-over.png');	
		
		batsmanid = $('.Batsman').parent().find('.hilite').parent().children('.Batsmanid').html();
		batsmankey = $('.Batsman').parent().find('.hilite').parent().children('.Batsmankey').html();
		bowlerid = $('.Batsman').parent().find('.hilite').parent().children('.Bowlerid').html();
		teamoneid = $('#teamoneid').html();
		teamtwoid = $('#teamtwoid').html();
		//console.log(teamoneid + '    ' + teamtwoid);
		battingendkey =  $('#battingend option:selected').val();
		bowlingendkey =  $('#bowlingend option:selected').val();
		
		console.log(battingendkey);
		console.log(bowlingendkey);
		
		currentstrikerkey = $('.Batsman').parent().find('.hilite').parent().children('.Batsmankey').html();
		currentnonstrikerkey = $('.Batsman').parent().find('.hilite-nonstriker').parent().children('.Batsmankey').html();
		currentbowlerkey = $('.Bowlerid').parent().find('.hilite').parent().children('.Bowlerkey').html();
		currentbowlerid = $('.Bowlerid').parent().find('.hilite').parent().children('.Bowlerid').html();	
		
		
		if (outbatsmankey == currentstrikerkey) {
			$('.Batsman').parent().find('.hilite').parent().children('.batting_position').children('select').attr('disabled', 'disabled');
			$('.Batsman').parent().find('.hilite').parent().children('.fielder').children('select').attr('disabled', 'disabled');
			$('.Batsman').parent().find('.hilite').parent().children('.wktakingbowler').children('select').attr('disabled', 'disabled');
			$('.Batsman').parent().find('.hilite').parent().children('.Dismissaltype').children('select').attr('disabled', 'disabled');
		}
		
		//fielderkey = $('.Batsman').parent().find('.hilite').parent().children('.fielder').children('select').children('option:selected').val();
		
		//maiden = 
		inning = $('#inningkey').html();
		formatkey = $('#formatkey').html();
		venuekey = $('#venuekey').html();
		
		battingposition = $('.Batsman').parent().find('.hilite').parent().children('.batting_position').children('select').children('option:selected').val();
		bowlingposition = $('.Bowler').parent().find('.hilite').parent().children('.bowling_position').children('select').children('option:selected').val();
		
		tournamentkey = $('#tournamentkey').html();
		matchkey = $('#matchkey').html();
		
		if (dismissaltypekey > 0 && (dismissaltypekey == 1 || dismissaltypekey == 2 || dismissaltypekey == 3 || dismissaltypekey == 8 )){
			wicket = 1
			bowlerkey = currentbowlerkey
		}
		
		overs = inningballcounter/6 + inningballcounter%6/10.0
		
		if (maidenovercounter == 6) {
			maiden = 1;
		}
		else {
			maiden = 0;
		}
	
		var totalones = 0;
		var totaltwos = 0;
		var totalthrees = 0;
		var totalfours = 0;
		var totalfives = 0;
		var totalsixes = 0;
	
		var currentbatsmanrun = $('.Batsman.hilite').parent().children('.batsman_runs').html();
		var currentbatsmanballsfaced = $('.Batsman.hilite').parent().children('.batsman_balls_faced').html();
		var currentbatsmansr = $('.Batsman.hilite').parent().children('.batsman_strikerate').html();
		var currentbatsmanzeros = $('.Batsman.hilite').parent().children('.batsman_zeros').html();
		var currentbatsmanones = $('.Batsman.hilite').parent().children('.batsman_ones').html();
		var currentbatsmantwos = $('.Batsman.hilite').parent().children('.batsman_twos').html();
		var currentbatsmanthrees = $('.Batsman.hilite').parent().children('.batsman_threes').html();
		var currentbatsmanfours = $('.Batsman.hilite').parent().children('.batsman_fours').html();
		var currentbatsmanfives = $('.Batsman.hilite').parent().children('.batsman_fives').html();
		var currentbatsmansixes = $('.Batsman.hilite').parent().children('.batsman_sixes').html();
		
		if (currentbatsmanrun == '' ) {currentbatsmanrun = 0;}
		if (currentbatsmanballsfaced == '') {currentbatsmanballsfaced = 0;}
		if (currentbatsmansr == '') {currentbatsmansr = 0;}
		if (currentbatsmanzeros == '') {currentbatsmanzeros = 0;}
		if (currentbatsmanones == '') {currentbatsmanones = 0;}
		if (currentbatsmantwos == '') {currentbatsmantwos = 0;}
		if (currentbatsmanthrees == '') {currentbatsmanthrees = 0;}
		if (currentbatsmanfours == '') {currentbatsmanfours = 0;}
		if (currentbatsmanfives == '') {currentbatsmanfives = 0;}
		if (currentbatsmansixes == '') {currentbatsmansixes = 0;}
		
		var totalruns = runs+ parseInt(currentbatsmanrun);
		var totalballsfaced = ballsfaced+parseInt(currentbatsmanballsfaced);
		var currentbatsmansr = 0.0;
		if (totalballsfaced != 0){ currentbatsmansr = totalruns/(totalballsfaced*1.0)*100;}
		var totalstrikerate = totalruns/totalballsfaced*100;
		var totalzeros = zeros+parseInt(currentbatsmanzeros);
		var totalones = ones+parseInt(currentbatsmanones);
		var totaltwos = twos+parseInt(currentbatsmantwos);
		var totalthrees = threes+parseInt(currentbatsmanthrees);
		var totalfours = fours + parseInt(currentbatsmanfours);
		var totalfives = fives + parseInt(currentbatsmanfives);
		var totalsixes = sixes + parseInt(currentbatsmansixes);

	
		$('.Batsman.hilite').parent().children('.batsman_runs').html(totalruns);
		$('.Batsman.hilite').parent().children('.batsman_balls_faced').html(totalballsfaced);
		$('.Batsman.hilite').parent().children('.batsman_strikerate').html(parseFloat(currentbatsmansr).toFixed(1));
		$('.Batsman.hilite').parent().children('.batsman_zeros').html(totalzeros);
		$('.Batsman.hilite').parent().children('.batsman_ones').html(totalones);
		$('.Batsman.hilite').parent().children('.batsman_twos').html(totaltwos);
		$('.Batsman.hilite').parent().children('.batsman_threes').html(totalthrees);
		$('.Batsman.hilite').parent().children('.batsman_fours').html(totalfours);
		$('.Batsman.hilite').parent().children('.batsman_fives').html(totalfives);
		$('.Batsman.hilite').parent().children('.batsman_sixes').html(totalsixes);


		var currentbowlerovers = $('.Bowler.hilite').parent().children('.bowler_overs').html();
		var currentbowlerrun = $('.Bowler.hilite').parent().children('.bowler_runs').html();
		var currentbowlermaidens = $('.Bowler.hilite').parent().children('.bowler_maidens').html();
		var currentbowlerwickets = $('.Bowler.hilite').parent().children('.bowler_wickets').html();
		var currentbowlerecon = $('.Bowler.hilite').parent().children('.bowler_econ').html();
		var currentbowlerzeros = $('.Bowler.hilite').parent().children('.bowler_zeros').html();	
		var currentbowlerones = $('.Bowler.hilite').parent().children('.bowler_ones').html();
		var currentbowlertwos = $('.Bowler.hilite').parent().children('.bowler_twos').html();
		var currentbowlerthrees = $('.Bowler.hilite').parent().children('.bowler_threes').html();
		var currentbowlerfours = $('.Bowler.hilite').parent().children('.bowler_fours').html();
		var currentbowlerfives = $('.Bowler.hilite').parent().children('.bowler_fives').html();
		var currentbowlersixes = $('.Bowler.hilite').parent().children('.bowler_sixes').html();
		var currentbowlerwides = $('.Bowler.hilite').parent().children('.bowler_wides').html();
		var currentbowlernoballs = $('.Bowler.hilite').parent().children('.bowler_noballs').html();
		var currentbowlerothers = $('.Bowler.hilite').parent().children('.bowler_others').html();
		
		
		
		if (currentbowlerovers == '' ) {currentbowlerovers = 0.0;}
		if (currentbowlerrun == '') {currentbowlerrun = 0;}
		if (currentbowlermaidens == '') {currentbowlermaidens = 0;}
		if (currentbowlerwickets == '') {currentbowlerwickets = 0;}
		if (currentbowlerecon == '') {currentbowlerecon = 0;}
		if (currentbowlerzeros == '') {currentbowlerzeros = 0;}
		if (currentbowlerones == '') {currentbowlerones = 0;}
		if (currentbowlertwos == '') {currentbowlertwos = 0;}
		if (currentbowlerthrees == '') {currentbowlerthrees = 0;}
		if (currentbowlerfours == '') {currentbowlerfours = 0;}
		if (currentbowlerfives == '') {currentbowlerfives = 0;}
		if (currentbowlersixes == '') {currentbowlersixes = 0;}
		if (currentbowlerwides == '') {currentbowlerwides = 0;}
		if (currentbowlernoballs == '') {currentbowlernoballs = 0;}
		if (currentbowlerothers == '') {currentbowlerothers = 0;}
		
		var totalovers =  parseFloat((ballsdelivered +parseFloat(currentbowlerovers)*10)/10.0).toFixed(1);
		var totaldeliveries = parseInt(totalovers)*6+parseInt((totalovers - parseInt(totalovers))*10);
		if ((parseInt(totalovers)*6+parseInt((totalovers - parseInt(totalovers))*10)) % 6 == 0 && inningballcounter != 0){totalovers = parseInt(totalovers)+1.0}
		var totalruns = runs+wides+noballs+byes+legbyes+parseInt(currentbowlerrun);
		var totalmaidens = maiden + parseInt(currentbowlermaidens);
		var totalwickets = 0;
		if (currentbowlerkey == bowlerkey) { totalwickets = wicket + parseInt(currentbowlerwickets);}
		var totalecon = 0;
		if (totaldeliveries != 0) {totalecon = totalruns/(totaldeliveries/6.0); }
		var totalzeros = zeros + parseInt(currentbowlerzeros);
		var totalones = ones+parseInt(currentbowlerones);
		var totaltwos = twos+parseInt(currentbowlertwos);
		var totalthrees = threes+parseInt(currentbowlerthrees);
		var totalfours = fours + parseInt(currentbowlerfours);
		var totalfives = fives + parseInt(currentbowlerfives);

		var totalwides = wides + parseInt(currentbowlerwides);
		var totalnoballs = noballs + parseInt(currentbowlernoballs);
		var totalothers = byes+legbyes + parseInt(currentbowlerothers);
		

		$('.Bowler.hilite').parent().children('.bowler_overs').html(totalovers);	
		$('.Bowler.hilite').parent().children('.bowler_runs').html(totalruns);
		$('.Bowler.hilite').parent().children('.bowler_maidens').html(totalmaidens);
		$('.Bowler.hilite').parent().children('.bowler_wickets').html(totalwickets);
		$('.Bowler.hilite').parent().children('.bowler_econ').html(totalecon.toFixed(1));
		$('.Bowler.hilite').parent().children('.bowler_zeros').html(totalzeros);
		$('.Bowler.hilite').parent().children('.bowler_ones').html(totalones);			
		$('.Bowler.hilite').parent().children('.bowler_twos').html(totaltwos);	
		$('.Bowler.hilite').parent().children('.bowler_threes').html(totalthrees);	
		$('.Bowler.hilite').parent().children('.bowler_fours').html(totalfours);	
		$('.Bowler.hilite').parent().children('.bowler_fives').html(totalfives);	
		$('.Bowler.hilite').parent().children('.bowler_sixes').html(totalsixes);	
		$('.Bowler.hilite').parent().children('.bowler_wides').html(totalwides);
		$('.Bowler.hilite').parent().children('.bowler_noballs').html(totalnoballs);
		$('.Bowler.hilite').parent().children('.bowler_others').html(totalothers);
		
		

		var val = $('.Bowler.hilite').parent().children('.bowling_side').children('ul').children('.side').html();
		console.log(val);
		if (val == 'RTW'){
			bowling_side = 0;
		}
		else{
			bowling_side = 1;
		}
	
	
		var bd = 0;
		var newover = 0.0;
		overs = $('#overs').html();
		console.log(overs);
		if (wides == 0 && noballs ==0 && parseFloat(overs) == 0){	
			inningballcounter = parseInt(parseInt(overs)*6 + (parseFloat(overs)-parseInt(overs)+1));
			newover = parseFloat(parseInt(inningballcounter/6) + parseFloat(inningballcounter%6/10));
		}
		else if (wides == 0 && noballs ==0 && parseFloat(overs) > 0){
			inningballcounter = parseInt(parseInt(overs)*6 + Math.round((parseFloat(overs)-parseInt(overs))*10)+1);
			newover = parseFloat(parseInt(inningballcounter/6) + parseFloat(inningballcounter%6/10));
		}
		else if (wides>0 || noballs>0){
			newover = parseFloat(overs);
		}

		$('#overs').html(newover);
		
		scores = $('#totalscore').html();
		totalscore = parseInt(scores)+runs+wides+noballs+legbyes+byes;
		wickets = $('#wicket').html();
		totalwickets = parseInt(wickets) + wicket;
		$('#scores').html('Score:'+totalscore+'/'+totalwickets+'<br/>Overs:'+newover);
		$('#totalscore').html(totalscore);
		$('#wicket').html(totalwickets);
		
		//ballsdelievered is counted one for every run hit, but if 
		//it is hit in a noball, the should not be counted
		if (runs>0 && noballs>0){
			ballsdelivered = 0
		}
		
	
		console.log('clientkey: ' + clientkey);
		jsonObj = {clientkey:clientkey,  ballsdelivered:ballsdelivered, ballsfaced:ballsfaced, batsmankey:batsmankey, batsmanid:batsmanid, battingendkey:battingendkey, battingposition:battingposition, bowlerkey:bowlerkey, bowlingendkey:bowlingendkey, bowlingposition:bowlingposition, byes:byes, currentbowlerkey:currentbowlerkey,  currentbowlerid:currentbowlerid, currentnonstrikerkey:currentnonstrikerkey, currentstrikerkey:currentstrikerkey, dismissedbatsmankey:dismissedbatsmankey, eights:eights, fielderkey:fielderkey, fives:fives, formatkey:formatkey, fours:fours, inning:inning, legbyes:legbyes, maiden:maiden, matchkey:matchkey, noballs:noballs, ones:ones, others:others, outbywk:outbywk, outtypekey:dismissaltypekey, runs:runs, sevens:sevens, sixes:sixes, teamidone:teamoneid, teamtwoid:teamtwoid, threes:threes, tournamentkey:tournamentkey, twos:twos, venuekey:venuekey, wicket:wicket, wides:wides, zeros:zeros, line:line, length:length, shottype:shottype, side:bowling_side, ballnum:inningballcounter, over:parseInt(Math.ceil(newover))};
		console.log(jsonObj);
		$.ajax({
			url: '/scorecards',
			type: 'post',
			cache: false,
			data: {scorecard:jsonObj},
			success: function(data, textStatus, jqXHR ) { 
				console.log('successful');
				$('#submit_runs').children('img').attr('src','/assets/button.png');

				$('#runs').children('img').attr('src','/assets/up.png');
				$('#wides').children('img').attr('src','/assets/up.png');
				$('#noballs').children('img').attr('src','/assets/up.png');
				$('#byes').children('img').attr('src','/assets/up.png');
				$('#legbyes').children('img').attr('src','/assets/up.png');
				$('.scoring_numbers').removeClass('scoring_number_clicked');
				$('.scoring_numbers').css('opacity', '0.9');
		
				rclicked = 0, wclicked = 0, nclicked, bclicked= 0, lbclicked = 0;
			},
			error: function(jqXHR, textStatus, errorThrown){ 
				console.log('unsuccessful');
			}
		});
		
		
		 //after assigning to the json Obj.
		 //if runs were hit, then the balls before run hit and boundary were assigned properly, 
		 //now reset the varaible back to zero
		 //when you are looking for these variable, only look with filter runs > 0
		 if (runs > 0){
			ballsbeforerun = 0;	
		 }
		 else if (runs > 3) {
		 	ballsbeforeboundary = 0;
		 }
		 
		 if ((inningballcounter%6 == 0 && inningballcounter!= 0 && runs%2 ==0) || (inningballcounter%6 != 0 && inningballcounter!= 0 &&(runs%2==1 || byes%2 == 1 || legbyes%2 == 1)) || (inningballcounter!= 0 && (wides==2 || (wides==4 && fours==1))) ){
			var striker = $('.Batsman.hilite');
			var nonstriker = $('.Batsman.hilite-nonstriker');

			$(striker).removeClass('hilite').addClass('hilite-nonstriker');
			$(nonstriker).removeClass('hilite-nonstriker').addClass('hilite');
	 
		 }
		 
		 if (inningballcounter%6 == 0 && inningballcounter!=0){
				bowlingend = $('#bowlingend').children('select').children('option:selected').val();
			var bowlingendname = $('#bowlingend').children('select').children('option:selected').html();
				battingend = $('#battingend').children('select').children('option:selected').val();
			var battingendname = $('#battingend').children('select').children('option:selected').html();
				 $('#bowlingend').children('select').children('option:selected').val(battingend);
				 $('#bowlingend').children('select').children('option:selected').html(battingendname);
				 $('#battingend').children('select').children('option:selected').val(bowlingend);
				 $('#battingend').children('select').children('option:selected').html(bowlingendname);

		 }
		 
		 
		runs = 0; zeros = 0; ones = 0; twos = 0; threes = 0; fours = 0; fives=0; sixes = 0; sevens = 0; eights = 0; others = 0;
		outbywk = -2; formatkey = 0; wides = 0; byes=0; noballs = 0;legbyes=0; ballsdelivered = 0; ballsfaced = 0; maiden = 0;
		fielderkey = -2; currentbowlerkey = -2; currentstrikerkey = -2; bowlerkey = -2, batsmankey = -2; 
		currentnonstrikerkey = -2; dismissedbatsmankey = -2; wicket = 0; dismissaltypekey = -2; teamoneid = -2; teamtwoid =-2;
		venuekey = -2;
		

		
		//console.log(jsonObj);
		
		
		
	});
	


});