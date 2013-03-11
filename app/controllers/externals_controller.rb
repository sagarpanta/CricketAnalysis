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
		
		@matches = Match.find_by_sql("select distinct m.id, to_char(created_at, 'YYYY-MM-DD')||'  '||t.teamname||' - '||t1.teamname as match from matches m inner join (select distinct teamid, clientkey, teamname from teams) t on m.teamidone=t.teamid and m.clientkey = t.clientkey inner join (select distinct teamid, clientkey, teamname from teams) t1 on m.teamidtwo=t1.teamid and m.clientkey = t1.clientkey where m.clientkey = "+current_user.id.to_s+ " order by m.id desc").collect {|m| [ m.match,m.id]}
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
			lengths['YorkerLength'] = 1
			lengths['FullLength'] = 2
			lengths['GoodLength'] = 3
			lengths['ShortOfGoodLength'] = 4
			lengths['ShortLength'] = 5
			
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
				batsmankey = Player.where('clientkey=? and lower(fullname)=? and formatkey=?', clientkey, e.StrikerName.downcase, formatkey).select('distinct playerid')[0].playerid
				battingendkey = -2
				battingposition = e.PlayingOrder
				currentbowlerkey = Player.where('clientkey=? and lower(fullname)=? and formatkey=?', clientkey, e.BowlerName.downcase, formatkey).select('distinct playerid')[0].playerid
				bowlerkey = e.IsWicket == 1? currentbowlerkey:-2
				bowlingendkey = -2
				bowlingposition = bowlers_n_positions[e.BowlerName]
				byes = e.IsBye
				currentstrikerkey = batsmankey				
				if dismissedbatsmanlist.include? e.NonStrikerName
					dismissedBatsman_pos = batsmen_n_positions[e.NonStrikerName]
					newBatsman = positions_n_batsmen[dismissedBatsman_pos+1]
					currentnonstrikerkey = Player.where('clientkey=? and lower(fullname)=? and formatkey=?', clientkey, newBatsman.downcase, formatkey).select('distinct playerid')[0].playerid
				else
					currentnonstrikerkey = Player.where('clientkey=? and lower(fullname)=? and formatkey=?', clientkey, e.NonStrikerName.downcase, formatkey).select('distinct playerid')[0].playerid
				end
				eights = e.Runs == 8? 1:0
				
				fielder = Player.where('clientkey=? and lower(fullname)=? and formatkey=?', clientkey, e.FielderName.downcase, formatkey).select('distinct playerid')
				fielderkey = e.IsWicket == 1? (fielder.length==0? -2:fielder[0].playerid):-2
				fives = e.Runs == 5? 1:0
				formatkey = formatkey
				fours = e.IsFour
				inning = e.InningsNo
				legbyes = e.IsLegBye
				maiden = 0
				matchkey = params[:matchkey]
				noballs = e.IsNoBall
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
				wides = e.IsWide
				zeros = e.Runs == 0? 1:0
				
				dismissedbatsman = Player.where('clientkey=? and lower(fullname)=? and formatkey=?', clientkey, e.OutBatsmanName.downcase, formatkey).select('distinct playerid')
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
				else
					shottype = shottypes[e.ShotName]
				end
				side = e.BowlingDirection == 'O' ? 1:2
				over = e.OverNo
				ballnum = e.IsWide+e.IsNoBall != 0? (e.OverNo-1) * 6 + (e.BallNo-1):(e.OverNo-1) * 6 + e.BallNo
				spell = e.SpellNo
				direction = directions[e.Region]
				angle = angles[e.BallType]
				videofile = e.VideoFile
				
				#Scorecard.create!({clientkey:clientkey, ballsdelivered:ballsdelivered, ballsfaced:ballsfaced,batsmankey:batsmankey,	battingendkey:battingendkey,battingposition:battingposition,currentbowlerkey:currentbowlerkey,bowlerkey:bowlerkey,bowlingendkey:bowlingendkey,bowlingposition:bowlingposition,byes:byes,currentstrikerkey:currentstrikerkey,currentnonstrikerkey:currentnonstrikerkey,eights:eights,fielderkey:fielderkey,fives:fives,formatkey:formatkey,fours:fours,inning:inning,legbyes:legbyes,maiden:maiden,matchkey:matchkey,noballs:noballs,ones:ones,others:others,outtypekey:outtypekey,outbywk:outbywk,runs:runs,sevens:sevens,sixes:sixes,teamidone:teamidone,teamtwoid:teamtwoid,threes:threes,tournamentkey:tournamentkey,twos:twos,venuekey:venuekey,wicket:wicket,wides:wides,zeros:zeros,dismissedbatsmankey:dismissedbatsmankey,line:line,length:length,direction:direction, angle:angle, shottype:shottype,side:side,over:over,ballnum:ballnum,spell:spell})
			
				@scorecard = Scorecard.new({clientkey:clientkey, ballsdelivered:ballsdelivered, ballsfaced:ballsfaced,batsmankey:batsmankey,	battingendkey:battingendkey,battingposition:battingposition,currentbowlerkey:currentbowlerkey,bowlerkey:bowlerkey,bowlingendkey:bowlingendkey,bowlingposition:bowlingposition,byes:byes,currentstrikerkey:currentstrikerkey,currentnonstrikerkey:currentnonstrikerkey,eights:eights,fielderkey:fielderkey,fives:fives,formatkey:formatkey,fours:fours,inning:inning,legbyes:legbyes,maiden:maiden,matchkey:matchkey,noballs:noballs,ones:ones,others:others,outtypekey:outtypekey,outbywk:outbywk,runs:runs,sevens:sevens,sixes:sixes,teamidone:teamidone,teamtwoid:teamtwoid,threes:threes,tournamentkey:tournamentkey,twos:twos,venuekey:venuekey,wicket:wicket,wides:wides,zeros:zeros,dismissedbatsmankey:dismissedbatsmankey,line:line,length:length,direction:direction, angle:angle, shottype:shottype,side:side,over:over,ballnum:ballnum,spell:spell, videoloc:videfile})

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
				end
				
			
			end

		External.destroy_all
		
		redirect_to matches_url  
  end
  
end
