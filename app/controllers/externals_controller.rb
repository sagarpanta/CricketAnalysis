require 'csv'

class ExternalsController < ApplicationController
  # GET /externals
  # GET /externals.json
  def index
    @externals = External.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @externals }
    end
  end

  # GET /externals/1
  # GET /externals/1.json
  def show
    @external = External.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @external }
    end
  end

  # GET /externals/new
  # GET /externals/new.json
  def new
		@tournaments = Tournament.where('clientkey=?', current_user.id).collect {|t| [ t.name,t.id]}
		@tournaments << ['', -2]
		@tournaments = @tournaments.sort_by{|k| k[0]}
		
		@venues = Venue.where('clientkey=?', current_user.id).collect {|t| [ t.venuename,t.id]}
		@venues << ['', -2]
		@venues = @venues.sort_by{|k| k[0]}
		
		@matches = Match.find_by_sql("select distinct m.id, to_char(matchdate, 'YYYY-MM-DD')||'  '||t.teamname||' - '||t1.teamname as match from matches m inner join (select distinct teamid, clientkey, teamname from teams) t on m.teamidone=t.teamid and m.clientkey = t.clientkey inner join (select distinct teamid, clientkey, teamname from teams) t1 on m.teamidtwo=t1.teamid and m.clientkey = t1.clientkey where m.clientkey = "+current_user.id.to_s+ " order by m.id desc").collect {|m| [ m.match,m.id]}
		@matches << ['', -2]
		@matches = @matches.sort_by{|k| k[0]}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @external }
    end
  end

  # GET /externals/1/edit
  def edit
    @external = External.find(params[:id])
  end

  # POST /externals
  # POST /externals.json
    def create 
        @external = External.new(params[:external])

        if @external.save
            flash[:notice] = "Thank you"
            redirect_to matches_url
        else
            flash[:error] = "There was a problem submitting your attachment."
            render :action => "new"
        end
    end

  # PUT /externals/1
  # PUT /externals/1.json
  def update
    @external = External.find(params[:id])

    respond_to do |format|
      if @external.update_attributes(params[:external])
        format.html { redirect_to @external, notice: 'External was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @external.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /externals/1
  # DELETE /externals/1.json
  def destroy
    @external = External.find(params[:id])
    @external.destroy

    respond_to do |format|
      format.html { redirect_to externals_url }
      format.json { head :no_content }
    end
  end
  
  
  def upload 
	begin
		External.import(params[:file])
		
		externals = External.find(:all, :order=>'"OverNo", "BallNo"')

			bowler_overs = {}
			bowlers = External.select('"BowlerName", "OverNo"').order('"OverNo", "BallNo"')
			bowlers_n_positions = {}
			unique_bowlers = []
			position = 1
			bowlers.each do |b|
				if !unique_bowlers.include? b.BowlerName
					unique_bowlers << b.BowlerName
					bowlers_n_positions[b.BowlerName] =  position
					position = position+1		
				end
			end
			
			batsmen = External.select('"StrikerName", "NonStrikerName"').order('"OverNo", "BallNo"')
			
			batsmen_n_positions = {}
			positions_n_batsmen = {}
			all_batsmen = []
			unique_batsmen = []
			position = 1
			batsmen.each do |b|
				all_batsmen << b.StrikerName << b.NonStrikerName
			end
			all_batsmen.each do |b|
				if !unique_batsmen.include? b
					unique_batsmen << b
					batsmen_n_positions[b] =  position
					positions_n_batsmen[position] = b
					position = position+1		
				end
			end
			
					
			
			@match = Match.find_by_id_and_clientkey(params[:matchkey], current_user.id)
			teamidone = @match.teamidone
			teamidtwo = @match.teamidtwo
			
			lines = {}
			lines['OutsideOffStump'] = 1
			lines['Middle'] = 2
			lines['OffStump'] = 2
			lines['LegStump'] = 3
			lines['OutsideLegStump'] = 4
			
			lengths = {}
			lengths['Full-tossed'] = 6
			lengths['Fulltossed'] = 6
			lengths['FullTossed'] = 6
			lengths['Full-Toss'] = 6
			lengths['FullToss'] = 6
			lengths['YorkerLength'] = 5
			lengths['FullLength'] = 4
			lengths['GoodLength'] = 3
			lengths['ShortOfGoodLength'] = 2
			lengths['ShortLength'] = 1
			
			shottypes = {}
			
			shottypes['Forward Defence'] = 9
			shottypes['Cut Shot'] = 52
			shottypes['Backfoot Defence'] = 3
			shottypes['Frontfoot CoverDrive'] = 8
			shottypes['Backfoot CoverDrive'] = 5
			shottypes['Square Drive'] = 53
			shottypes['Straight Drive'] = 54
			shottypes['On Drive'] = 44
			shottypes['Off Drive'] = 45
			shottypes['Flick'] = 12
			shottypes['Glance'] = 13
			shottypes['Edge'] = 10
			shottypes['Hook'] = 15
			shottypes['Late Cut'] = 16
			shottypes['Pull Shot'] = 47
			#Lofted shottype is just a mentioning here, but the actual lofted shot is
			#determined by the direction
			shottypes['Lofted'] = 27
			shottypes['Left Alone'] = 17
			shottypes['Sweep Shot'] = 55
			shottypes['Reverse Sweep'] = 48
			shottypes['Switch Hit'] = 56
			shottypes['Forward Defence'] = 9
			shottypes['Beaten'] = 7
			shottypes['Paddle Sweep'] = 46
			shottypes['Uncomfortable'] = 28  #represents all mishits and edge
			
			wickettypes = {}
			
			wickettypes['Bowled'] = 1
			wickettypes['Caught'] = 2
			wickettypes['Stumped'] = 3
			wickettypes['Retired Hurt'] = 7
			wickettypes['C & B'] = 2
			wickettypes['LBW'] = 8
			wickettypes['Run Out'] = 4
		
			directions = {}
			directions['FineLeg'] = '1Fine Leg'
			directions['ShortFineLeg'] = '1Fine Leg'
			directions['DeepFineLeg'] = '1Fine Leg'
			directions['SquareLeg'] = '2Square Leg'
			directions['DeepSquareLeg'] = '2Square Leg'
			directions['ShortSquareLeg'] = '2Square Leg'
			directions['MidWicket'] = '3Mid Wicket'
			directions['ShortMidWicket'] = '3Mid Wicket'
			directions['DeepMidWicket'] = '3Mid Wicket'
			directions['LongOn'] = '4Long On'
			directions['Pitch'] = '5Long Off'
			directions['LongOff'] = '5Long Off'
			directions['MidOn'] = '4Long On'
			directions['MidOff'] = '5Long Off'
			directions['Covers'] = '6Covers'
			directions['ShortCovers'] = '6Covers'
			directions['ShortCover'] = '6Covers'
			directions['Point'] = '7Point'
			directions['Gully'] = '7Point'
			directions['DeepPoint'] = '7Point'
			directions['DeepGully'] = '7Point'
			directions['ThirdMan'] = '8ThirdMan'
			directions['ShortThirdMan'] = '8ThirdMan'
			
			angles = {}
			
			angles['OutSwinger'] = 100
			angles['InSwinger'] = 101
			angles['Reverse Swing'] = 102
			angles['LegCutter'] = 103
			angles['OffCutter'] = 104
			angles['InCutter'] = 104
			angles['SlowerBall'] = 105
			angles['NipBacker'] = 106
			angles['Straighter'] = 107
			angles['Straight Ball'] = 107
			angles['StraightBall'] = 107
			angles['Leg Spin'] = 108
			angles['Off Spin'] = 109
			angles['Flipper'] = 110
			angles['Top Spinner'] = 111
			angles['Googly'] = 112
			angles['Doosra'] = 113
	
			formatkey = Match.where('clientkey=? and id=?', current_user.id, params[:matchkey]).select('formatkey')[0].formatkey
			clientkey = current_user.id
			dismissedbatsmanlist = []
			externals.each do |e|
				ballsdelivered = e.IsWide+e.IsNoBall == 0? 1:0
				ballsfaced = e.IsWide ==0? 1:0
				batsmankey = Player.where('clientkey=? and ltrim(rtrim(lower(fullname)))=? and formatkey=?', clientkey, e.StrikerName.downcase, formatkey).select('distinct playerid')[0].playerid
				battingendkey = -2
				battingposition = e.PlayingOrder
				currentbowlerkey = Player.where('clientkey=? and ltrim(rtrim(lower(fullname)))=? and formatkey=?', clientkey, e.BowlerName.downcase, formatkey).select('distinct playerid')[0].playerid
				bowlerkey = e.IsWicket == 1? currentbowlerkey:-2
				bowlingendkey = -2
				bowlingposition = bowlers_n_positions[e.BowlerName]
				byes = e.IsBye*e.Extras
				currentstrikerkey = batsmankey				
				if dismissedbatsmanlist.include? e.NonStrikerName
					dismissedBatsman_pos = batsmen_n_positions[e.NonStrikerName]
					newBatsman = positions_n_batsmen[dismissedBatsman_pos+1]
					currentnonstrikerkey = Player.where('clientkey=? and ltrim(rtrim(lower(fullname)))=? and formatkey=?', clientkey, newBatsman.downcase, formatkey).select('distinct playerid')[0].playerid
				else
					currentnonstrikerkey = Player.where('clientkey=? and ltrim(rtrim(lower(fullname)))=? and formatkey=?', clientkey, e.NonStrikerName.downcase, formatkey).select('distinct playerid')[0].playerid
				end
				eights = e.Runs == 8? 1:0
				
				fielder = Player.where('clientkey=? and ltrim(rtrim(lower(fullname)))=? and formatkey=?', clientkey, e.FielderName.downcase, formatkey).select('distinct playerid')
				fielderkey = e.IsWicket == 1? (fielder.length==0? -2:fielder[0].playerid):-2
				fives = e.Runs == 5? 1:0
				formatkey = formatkey
				fours = e.IsFour
				inning = e.InningsNo
				legbyes = e.IsLegBye*e.Extras
				maiden = 0
				matchkey = params[:matchkey]
				noballs = e.IsNoBall*e.Extras
				ones = e.Runs == 1? 1:0
				others = e.Runs > 8? 1:0
				outtypekey = e.WicketType== 'NULL'? -2:wickettypes[e.WicketType]
				outbywk = -2 #find the fielder
				runs = e.Runs
				sevens = e.Runs == 7? 1:0
				sixes = e.IsSix
				teamidone = teamidone
				teamtwoid = teamidtwo
				threes = e.Runs == 3? 1:0
				tournamentkey = params[:tournamentkey]
				twos = e.Runs == 2? 1:0
				venuekey = params[:venuekey]
				wicket = e.IsWicket
				wides = e.IsWide*e.Extras
				zeros = e.Runs == 0? 1:0
				
				dismissedbatsman = Player.where('clientkey=? and ltrim(rtrim(lower(fullname)))=? and formatkey=?', clientkey, e.OutBatsmanName.downcase, formatkey).select('distinct playerid')
				dismissedbatsmankey = dismissedbatsman.length==0? -2:dismissedbatsman[0].playerid  #findout from raman
				if e.WicketType != 'NULL'
					dismissedbatsmanlist << e.OutBatsmanName
				end
				
				line = lines[e.Line]
				length = lengths[e.Length]
				if e.IsBeaten == 1
					shottype = shottypes['Beaten']
				elsif e.IsUncomfortable == 1 and e.IsBeaten == 0
					shottype = shottypes['Uncomfortable']
				elsif e.ShotName == 'Lofted'
					if ['1Fine Leg', '2Square Leg', '3Mid Wicket'].include? directions[e.Region]
						shottype = 20
					elsif ['4Long On', '5Long Off'].include? directions[e.Region]
						shottype = 27
					elsif ['6Covers'].include? directions[e.Region]
						shottype = 18
					elsif ['7Point'].include? directions[e.Region]
						shottype = 25
					elsif ['8ThirdMan'].include? directions[e.Region]
						shottype = 23
					end
				else
					shottype = shottypes[e.ShotName]
				end
							
				side = e.BowlingDirection == 'O' ? 1:2
				over = e.OverNo
				ballnum = e.IsWide+e.IsNoBall != 0? (e.OverNo-1) * 6 + (e.BallNo-1):(e.OverNo-1) * 6 + e.BallNo
				spell = e.SpellNo
				direction = directions[e.Region]
				angle = angles[e.BallType]
				videofile = e.VideoFile.nil? ? '':e.VideoFile
				
				#Scorecard.create!({clientkey:clientkey, ballsdelivered:ballsdelivered, ballsfaced:ballsfaced,batsmankey:batsmankey,	battingendkey:battingendkey,battingposition:battingposition,currentbowlerkey:currentbowlerkey,bowlerkey:bowlerkey,bowlingendkey:bowlingendkey,bowlingposition:bowlingposition,byes:byes,currentstrikerkey:currentstrikerkey,currentnonstrikerkey:currentnonstrikerkey,eights:eights,fielderkey:fielderkey,fives:fives,formatkey:formatkey,fours:fours,inning:inning,legbyes:legbyes,maiden:maiden,matchkey:matchkey,noballs:noballs,ones:ones,others:others,outtypekey:outtypekey,outbywk:outbywk,runs:runs,sevens:sevens,sixes:sixes,teamidone:teamidone,teamtwoid:teamtwoid,threes:threes,tournamentkey:tournamentkey,twos:twos,venuekey:venuekey,wicket:wicket,wides:wides,zeros:zeros,dismissedbatsmankey:dismissedbatsmankey,line:line,length:length,direction:direction, angle:angle, shottype:shottype,side:side,over:over,ballnum:ballnum,spell:spell})
			
				@scorecard = Scorecard.new({clientkey:clientkey, ballsdelivered:ballsdelivered, ballsfaced:ballsfaced,batsmankey:batsmankey,	battingendkey:battingendkey,battingposition:battingposition,currentbowlerkey:currentbowlerkey,bowlerkey:bowlerkey,bowlingendkey:bowlingendkey,bowlingposition:bowlingposition,byes:byes,currentstrikerkey:currentstrikerkey,currentnonstrikerkey:currentnonstrikerkey,eights:eights,fielderkey:fielderkey,fives:fives,formatkey:formatkey,fours:fours,inning:inning,legbyes:legbyes,maiden:maiden,matchkey:matchkey,noballs:noballs,ones:ones,others:others,outtypekey:outtypekey,outbywk:outbywk,runs:runs,sevens:sevens,sixes:sixes,teamidone:teamidone,teamtwoid:teamtwoid,threes:threes,tournamentkey:tournamentkey,twos:twos,venuekey:venuekey,wicket:wicket,wides:wides,zeros:zeros,dismissedbatsmankey:dismissedbatsmankey,line:line,length:length,direction:direction, angle:angle, shottype:shottype,side:side,over:over,ballnum:ballnum,spell:spell, videoloc:videofile})

				if @scorecard.save
					runs = Scorecard.where('clientkey = ? and matchkey = ? and batsmankey =? ', current_user.id, @scorecard.matchkey, @scorecard.batsmankey).sum(:runs)
					if runs>=0 and runs<=10
						cr = '0-10'
					elsif runs>10 and runs<=30
						cr = '11-30'
					elsif runs>30 and runs<50
						cr = '31-49'
					elsif runs>50 and runs<=75
						cr = '50-75'
					elsif runs>75 and runs<100
						cr = '76-99'
					else 
						cr = '100+'
					end
					
					Scorecard.where('clientkey = ? and matchkey = ? and batsmankey =? ', current_user.id, @scorecard.matchkey, @scorecard.batsmankey).update_all(:cr => cr)
					
					batting_stats = Battingscorecard.find_by_batsmankey_and_matchkey_and_inning(@scorecard.batsmankey, @scorecard.matchkey, @scorecard.inning)
					bowling_stats = Bowlingscorecard.find_by_bowlerkey_and_matchkey_and_inning(@scorecard.currentbowlerkey, @scorecard.matchkey, @scorecard.inning)

					bowler =  Rails.cache.fetch("bowler_#{@scorecard.bowlerkey}_#{@scorecard.formatkey}", :expires_in=>24.hours) do
						Player.find_all_by_playerid_and_formatkey(@scorecard.bowlerkey, @scorecard.formatkey)
					end

					bowlername = bowler[0].nil? ? '':bowler[0].fname[0]+' '+bowler[0].lname
					fielder = Rails.cache.fetch("fielder_#{@scorecard.fielderkey}_#{@scorecard.formatkey}", :expires_in=>24.hours) do
						Player.find_all_by_playerid_and_formatkey(@scorecard.fielderkey, @scorecard.formatkey)
					end
					fieldername = fielder[0].nil? ? '':fielder[0].fname[0]+' '+fielder[0].lname
					
					outtype = Rails.cache.fetch("dismissals_#{@scorecard.outtypekey}", :expires_in=>1.day) do
						Dismissal.find_all_by_id(@scorecard.outtypekey)
					end
					
					outtypename = outtype[0].nil? ? '':outtype[0].dismissaltype
					currentbowlerovers = bowling_stats.overs.nil? ? 0.0:bowling_stats.overs 
					#add 1 ball as 0.1 to the current bowler overs
					# for eg add  3.5 + 0.1 = 3.4 
					# but if the new overs becomes 3.6, make it 4.0
					newcurrentbowlerovers = currentbowlerovers + @scorecard.ballsdelivered/10.0
					
					if (newcurrentbowlerovers*10)%10 == 6
						newcurrentbowlerovers = newcurrentbowlerovers.to_int+1.0
					end
					
					newcurrentbowlerovers_decimal = ((newcurrentbowlerovers - newcurrentbowlerovers.to_int)*10)/6.0 +newcurrentbowlerovers.to_int
					totalovers = @scorecard.ballnum%6/10.0 + @scorecard.ballnum/6
					
					hilite = {}
					
					if @scorecard.ballnum%6!=0 and (@scorecard.runs%2==1 or @scorecard.byes%2== 1 or @scorecard.legbyes%2 == 1)
						hilite[@scorecard.currentnonstrikerkey] = 'hilite'
						hilite[@scorecard.batsmankey] = 'hilite-nonstriker'
					elsif @scorecard.ballnum%6!=0 and (@scorecard.runs%2==0 and @scorecard.byes%2 == 0 and @scorecard.legbyes%2 == 0)
						hilite[@scorecard.batsmankey] = 'hilite'
						hilite[@scorecard.currentnonstrikerkey] = 'hilite-nonstriker'
					elsif @scorecard.ballnum%6==0 and ((@scorecard.noballs == 0 and (@scorecard.runs%2==1 or @scorecard.byes%2 == 1 or @scorecard.legbyes%2 == 1)) or (@scorecard.wides%2==1 or @scorecard.wides==4) or (@scorecard.noballs==1 and (@scorecard.runs%2==0 and @scorecard.legbyes%2==0 and @scorecard.runs%2==0)))
						hilite[@scorecard.batsmankey] = 'hilite'
						hilite[@scorecard.currentnonstrikerkey] = 'hilite-nonstriker'
					elsif @scorecard.ballnum%6==0 and ((@scorecard.noballs>0 and (@scorecard.byes%2==1 or @scorecard.legbyes%2==1 or @scorecard.runs%2==1)) or (@scorecard.noballs == 0 and (@scorecard.runs%2==0 and @scorecard.byes%2== 0 and @scorecard.legbyes%2 == 0)) or (@scorecard.wides%2==0 and (@scorecard.wides != 1 or @scorecard.wides!=4)))
						hilite[@scorecard.currentnonstrikerkey] = 'hilite'
						hilite[@scorecard.batsmankey] = 'hilite-nonstriker'
					end
										
					ballsfaced = batting_stats.ballsfaced.nil? ? 0:batting_stats.ballsfaced
					zeros = batting_stats.zeros.nil? ? 0:batting_stats.zeros
					runs = batting_stats.runs.nil? ? 0:batting_stats.runs
					fours = batting_stats.fours.nil? ? 0:batting_stats.fours
					sixes = batting_stats.sixes.nil? ? 0:batting_stats.sixes
					
					bruns = bowling_stats.runs.nil? ? 0:bowling_stats.runs
					bbyes = bowling_stats.runs.nil? ? 0:bowling_stats.byes
					blegbyes = bowling_stats.runs.nil? ? 0:bowling_stats.legbyes
					bzeros = bowling_stats.zeros.nil? ? 0:bowling_stats.zeros
					bfours = bowling_stats.fours.nil? ? 0:bowling_stats.fours
					bsixes = bowling_stats.sixes.nil? ? 0:bowling_stats.sixes
					bwides = bowling_stats.wides.nil? ? 0:bowling_stats.wides
					bnoballs = bowling_stats.noballs.nil? ? 0:bowling_stats.noballs
					bwickets = bowling_stats.wickets.nil? ? 0:bowling_stats.wickets
					bmaidens = bowling_stats.maidens.nil? ? 0:bowling_stats.maidens
					blast_run = @scorecard.runs+@scorecard.byes+@scorecard.legbyes+@scorecard.noballs+@scorecard.wides
					bwicketsgone = bowling_stats.wickets.nil? ? 0:bowling_stats.wickets
					
					
					#Battingscorecard.where('matchkey = ? and batsmankey =? and inning=?', @scorecard.matchkey, @scorecard.batsmankey, @scorecard.inning).update_all(:position=>@scorecard.battingposition, :runs=>@scorecard.runs+batting_stats.runs, :ballsfaced=>batting_stats.ballsfaced+@scorecard.ballsfaced, :strikerate=> batting_stats.ballsfaced+@scorecard.ballsfaced == 0? 0:(batting_stats.runs+@scorecard.runs)/(1.0*(batting_stats.ballsfaced+@scorecard.ballsfaced)), :zeros=>@scorecard.zeros+batting_stats.zeros, :ones=>batting_stats.ones+@scorecard.ones, :twos=>batting_stats.twos+@scorecard.twos, :threes=>batting_stats.threes+@scorecard.threes, :fours=>batting_stats.fours+@scorecard.fours, :fives=>@scorecard.fives+batting_stats.fives, :sixes=>batting_stats.sixes+@scorecard.sixes, :played=>1, :hilite=>hilite[@scorecard.batsmankey])
					Battingscorecard.where('matchkey = ? and batsmankey =? and inning=?', @scorecard.matchkey, @scorecard.currentstrikerkey, @scorecard.inning).update_all(:position=>@scorecard.battingposition, :runs=>@scorecard.runs+runs, :ballsfaced=>ballsfaced+@scorecard.ballsfaced, :strikerate=> ballsfaced+@scorecard.ballsfaced == 0? 0:(runs+@scorecard.runs)/(1.0*(ballsfaced+@scorecard.ballsfaced)), :zeros=>zeros+@scorecard.zeros, :fours=>fours+@scorecard.fours, :sixes=>sixes+@scorecard.sixes, :played=>1, :updated_at=>Time.now, :hilite=>hilite[@scorecard.batsmankey], :nonstrikerkey=>@scorecard.currentnonstrikerkey)
					Battingscorecard.where('matchkey = ? and batsmankey =? and inning=?', @scorecard.matchkey, @scorecard.currentnonstrikerkey, @scorecard.inning).update_all(:played=>1, :hilite=>hilite[@scorecard.currentnonstrikerkey])
					
					if @scorecard.outtypekey>0
						Battingscorecard.where('matchkey = ? and batsmankey =? and inning=?', @scorecard.matchkey, @scorecard.dismissedbatsmankey, @scorecard.inning).update_all(:fielder=>fieldername, :fielderkey=>@scorecard.fielderkey, :outtype=>outtypename, :outtypekey=>@scorecard.outtypekey, :bowler=>bowlername, :bowlerkey=>@scorecard.bowlerkey, :hilite=>'', :updated_at=>Time.now,)
						bwicketsgone = bwicketsgone+1
					end
					Bowlingscorecard.where('matchkey = ? and inning=?', @scorecard.matchkey, @scorecard.inning).update_all(:hilite=>'')
					Bowlingscorecard.where('matchkey = ? and bowlerkey =? and inning=?', @scorecard.matchkey, @scorecard.currentbowlerkey,@scorecard.inning).update_all(:position=>@scorecard.bowlingposition, :overs=>newcurrentbowlerovers,:runs=>@scorecard.runs+@scorecard.wides+@scorecard.noballs+bruns, :byes=>bbyes+@scorecard.byes, :legbyes=>blegbyes+@scorecard.legbyes, :maidens=>bmaidens+@scorecard.maiden, :wickets=>@scorecard.wicket+bwickets, :economy=>newcurrentbowlerovers_decimal==0? 0:(@scorecard.runs+@scorecard.wides+@scorecard.noballs+bruns)/newcurrentbowlerovers_decimal, :zeros=>@scorecard.zeros+bzeros,  :zeros=>bzeros+@scorecard.zeros,:fours=>bfours+@scorecard.fours, :sixes=>bsixes+@scorecard.sixes, :wides=>bwides+@scorecard.wides,:noballs=>bnoballs+@scorecard.noballs, :totalovers=>totalovers, :wicketsgone=>bwicketsgone,:last_run=>blast_run, :bowled=>1, :hilite=>'hilite', :updated_at=>Time.now)				
				end
			end

		External.find_by_sql('truncate table externals; alter sequence externals_id_seq restart with 1;')
		
		redirect_to matches_url  
	rescue
		External.find_by_sql('truncate table externals; alter sequence externals_id_seq restart with 1;')
		Battingscorecard.where('clientkey=? and matchkey=?',current_user.id, params[:matchkey]).update_all(:position=>11, :fielder=>'', :fielderkey=>-2,:outtype=>'', :outtypekey=>-2, :bowler=>'', :bowlerkey=>-2, :runs=>nil, :ballsfaced=>nil, :strikerate=>nil, :zeros=>nil, :ones=>nil, :twos=>nil, :threes=>nil, :fours=>nil, :fives=>nil, :sixes=>nil, :hilite=>'', :nonstrikerkey=>'', :played=>0)
		Bowlingscorecard.where('clientkey=? and matchkey=?',current_user.id, params[:matchkey]).update_all(:position=>11, :overs=>nil, :runs=>nil, :maidens=>nil, :wickets=>nil, :economy=>nil, :zeros=>nil, :ones=>nil, :twos=>nil, :threes=>nil, :fours=>nil, :fives=>nil, :sixes=>nil, :wides=>nil, :noballs=>nil, :byes=>nil, :legbyes=>nil, :last_run=>nil, :bowled=>0, :hilite=>'',:totalovers=>0.0, :wicketsgone=>0)
		Scorecard.find_by_sql('delete from scorecards where matchkey='+params[:matchkey].to_s)
	end
  end
  
end
