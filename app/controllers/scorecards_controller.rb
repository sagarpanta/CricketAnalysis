class ScorecardsController < ApplicationController
  # GET /scorecards
  # GET /scorecards.json
  def index
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@scorecards = Scorecard.all
			end
		else 
			redirect_to signin_path
		end
		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render json: @scorecards }
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'scorecards#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /scorecards/10
  # GET /scorecards/1.json
  def show
    @scorecard = Scorecard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scorecard }
    end
  end

  # GET /scorecards/new
  # GET /scorecards/new.json
  def new
	begin
		if signed_in?
			@current_client = current_user.username
			@scorecard = Scorecard.new
			@match = Match.find_by_id(params[:id])
		else 
			redirect_to signin_path
		end
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render json: @scorecard }
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'scorecards#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /scorecards/1/edit
  def edit
	begin
		if signed_in?
			@current_client = current_user.username
			@scorecard = Scorecard.find(params[:id])
		else 
			redirect_to signin_path
		end  
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'scorecards#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end  
  end

  # POST /scorecards
  # POST /scorecards.json
  def create
	begin
		@scorecard = Scorecard.new(params[:scorecard])

		respond_to do |format|
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
			

			format.json { render json: @scorecard, status: :created, location: @scorecard }
		  else
			format.json { render json: @scorecard.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'scorecards#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /scorecards/1
  # PUT /scorecards/1.json
  def update
	begin
		if signed_in?
			@current_client = current_user.username
			@scorecard = Scorecard.find(params[:id])
		else 
			redirect_to signin_path
		end
		respond_to do |format|
		  if @scorecard.update_attributes(params[:scorecard])
			format.html { redirect_to @scorecard, notice: 'Scorecard was successfully updated.' }
			format.json { head :no_content }
		  else
			format.html { render action: "edit" }
			format.json { render json: @scorecard.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'scorecards#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /scorecards/1
  # DELETE /scorecards/1.json
  def destroy
    begin
		if signed_in?
			@scorecard = Scorecard.find(params[:id])
			@scorecard.destroy
		else 
			redirect_to signin_path
		end
		respond_to do |format|
		  format.html { redirect_to scorecards_url }
		  format.json { head :no_content }
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'scorecards#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
 
  def match_scorecard_one
	begin
		if signed_in?
			@current_client = current_user.username
			@match = Match.find_by_id_and_clientkey(params[:id], current_user.id)

			#####common entry for all records
			@tournament = Tournament.find_by_id(@match.tournamentkey)
			@venue = Venue.find_by_id(@match.venuekey)
			@format = Format.find_by_id(@match.formatkey)
			@formatarr = []
			@formatarr << @format.name << @format.id
			
			@lines = Line.all
			@lengths = Length.all
			@shottypes = Shottype.all
			
			@batting_side = 0
			@fielding_side = 0
			
			@teamone = Team.find_by_teamid(@match.teamidone)
			@teamtwo = Team.find_by_teamid(@match.teamidtwo)
			
			if @match.tosswon == @match.teamidone
				if @match.electedto == 'Bat'
					#@teamone = Team.find_by_teamid(@match.teamidone)
					#@teamtwo = Team.find_by_teamid(@match.teamidtwo)
					@batting_side = @match.teamidone
					@fielding_side = @match.teamidtwo
				else
					#@teamone = Team.find_by_teamid(@match.teamidtwo)
					#@teamtwo = Team.find_by_teamid(@match.teamidone)
					@batting_side = @match.teamidtwo
					@fielding_side = @match.teamidone
				end
			else
				if @match.electedto == 'Bat'
					#@teamone = Team.find_by_teamid(@match.teamidtwo)
					#@teamtwo = Team.find_by_teamid(@match.teamidone)
					@batting_side = @match.teamidtwo
					@fielding_side = @match.teamidone
				else
					#@teamone = Team.find_by_teamid(@match.teamidone)
					#@teamtwo = Team.find_by_teamid(@match.teamidtwo)
					@batting_side = @match.teamidone
					@fielding_side = @match.teamidtwo
				end
			end
				
			@inning = 1
			
			#####Score calculation
			@runs = Scorecard.first.nil? ? 0:Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).select('sum(runs+wides+noballs+legbyes+byes) as scores')[0][:scores]
			@runs = @runs.nil? ? 0:@runs
			ballsdelivered = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).sum(:ballsdelivered)
			@overs = ballsdelivered/6 + ballsdelivered%6/10.0
			@wickets =  Scorecard.where('matchkey=? and inning= ?', params[:id], @inning).sum(:wicket)


			#batting side players
			@batsmankeys = Team.where('teamid= ?', @batting_side ).collect {|b| b.playerkey}
			
			
			#beginning of calculation of current bowler or batsman or non striker or fielder in action
			#maxid is the last entry id of Scorecard
			@maxid = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.where('matchkey = ? and inning=?', params[:id], @inning).maximum(:id)
			@currentstrikerkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).batsmankey
			@currentnonstrikerkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).currentnonstrikerkey
			@strikerposition =  Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).battingposition
			@maxidwherenonstrikerisstriker = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.where('matchkey = ? and inning=? and currentstrikerkey = ?', params[:id], @inning, @currentnonstrikerkey).maximum(:id)
			@nonstrikerposition = Scorecard.find_by_id(@maxidwherenonstrikerisstriker).nil? ? -2:Scorecard.find_by_id(@maxidwherenonstrikerisstriker).battingposition
			@currentbowlerkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).currentbowlerkey
			@currentbowlingside = Scorecard.where('matchkey=? and inning = ? and currentbowlerkey=?', params[:id], @inning, @currentbowlerkey).first.nil? ? -2:Scorecard.find_by_id(@maxid).side
			@lastrun = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).runs
			@lastbye = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).byes
			@lastlbye = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).legbyes
			@lastnoball = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).noballs
			@lastwide = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).wides
			@battingposition = [1,2,3,4,5,6,7,8,9,10,11]
			@bowlingposition = [1,2,3,4,5,6,7,8,9,10,11]
			@venue = Venue.find_all_by_id(@match.venuekey)
			
			
			#last batting end and last bowling end
			@battingendkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? 0:Scorecard.find_by_id(@maxid).battingendkey
			@bowlingendkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? 1:Scorecard.find_by_id(@maxid).bowlingendkey	
			@battingend = []
			
			@battingend << (@battingendkey ==0? {'value'=> @battingendkey, 'name'=> @venue[0].endone}:{'value'=> @battingendkey, 'name'=> @venue[0].endtwo} )
			@battingend << (@bowlingendkey==1?  {'value'=>@bowlingendkey, 'name'=>@venue[0].endtwo}:{'value'=>@bowlingendkey, 'name'=>@venue[0].endone})

			@battingendname = @battingend[@battingendkey]
			@bowlingendname = @battingend[@bowlingendkey]
			
			#if it is an over and the last runs taken is not one or three or five and it is not zero ball with some wides or noballs, 
			#then swap the striker and non striker, and swap the batting end and bowling end
			if ballsdelivered%6!=0 and (@lastrun%2==1 or @lastbye%2== 1 or @lastlbye%2 == 1)
				temp = @currentstrikerkey
				@currentstrikerkey = @currentnonstrikerkey
				@currentnonstrikerkey = temp
				
				temp1 = @battingendkey
				@battingendkey = @bowlingendkey
				@bowlingendkey = temp1
			elsif ballsdelivered%6!=0 and (@lastrun%2==0 and @lastbye%2 == 0 and @lastlbye%2 == 0)
				@currentstrikerkey = @currentstrikerkey
				@currentnonstrikerkey = @currentnonstrikerkey
			elsif ballsdelivered%6==0 and ((@lastnoball == 0 and (@lastrun%2==1 or @lastbye%2 == 1 or @lastlbye%2 == 1)) or (@lastwide%2==1 or @lastwide==4) or (@lastnoball==1 and (@lastbye%2==0 and @lastlbye%2==0 and @lastrun%2==0)))
				@currentstrikerkey = @currentstrikerkey
				@currentnonstrikerkey = @currentnonstrikerkey
			elsif ballsdelivered%6==0 and ((@lastnoball>0 and (@lastbye%2==1 or @lastlbye%2==1 or @lastrun%2==1)) or (@lastnoball == 0 and (@lastrun%2==0 and @lastbye%2== 0 and @lastlbye%2 == 0)) or (@lastwide%2==0 and (@lastwide != 1 or @lastwide!=4)))
				
				temp = @currentstrikerkey
				@currentstrikerkey = @currentnonstrikerkey
				@currentnonstrikerkey = temp
			end	
			
			if ballsdelivered%6==0 and (@lastwide==0 and @lastnoball ==0)
				temp1 = @battingendkey
				@battingendkey = @bowlingendkey
				@bowlingendkey = temp1
			end

			#counter is the way to add pre populated position to the batsmen.
			@batsmen = []
			counter = 1
			pos = 0
			@batsmankeys.each do |b|	
				if counter >11
					break
				end
				player = Player.find_by_id(b)
				#this is the last entry id of the bastman b
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and batsmankey=?', params[:id],@inning,b).maximum(:id)
				playerlastentry_id_as_nonstriker = Scorecard.where('matchkey=? and inning=? and currentnonstrikerkey=?', params[:id],@inning,b).maximum(:id)
				
				#get the stats of batsman b so far.
				stats_query = 'select SUM(runs) as runs, sum(zeros) as zeros, SUM(ones) as ones, SUM(twos) as twos, SUM(threes) as threes, SUM(fours) as fours, SUM(fives) as fives, SUM(sixes) as sixes, SUM(ballsfaced) as ballsfaced,  case when sum(ballsfaced) = 0 then 0 else sum(runs)/(sum(ballsfaced)*1.0)*100 end as strikerate
								from
								(
								select 
								runs, 
								zeros,
								case when runs>0 then ones else 0 end as ones, 
								case when runs>0 then twos else 0 end twos, 
								case when runs>0 then threes else 0 end threes, 
								case when runs>0 then fours else 0 end fours, 
								case when runs>0 then fives else 0 end fives, 
								case when runs>0 then sixes else 0 end sixes, 
								ballsfaced 
								from scorecards where matchkey = '+params[:id].to_s+' and clientkey = '+current_user.id.to_s+' and batsmankey = '+b.to_s+' and inning='+@inning.to_s+'
								)A
								'
				stats = Scorecard.find_by_sql(stats_query)
				
				
				hilite = ''
				if @currentstrikerkey == b
					hilite='hilite'
				elsif @currentnonstrikerkey == b
					hilite='hilite-nonstriker'
				end

					
				#get the last entry of the batsman b and get his information
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				playerlastentry_as_NS = Scorecard.find_by_id(playerlastentry_id_as_nonstriker)
				
				dbk = playerlastentry.nil? ? -2:playerlastentry[:dismissedbatsmankey]
				dbk1 = playerlastentry_as_NS.nil? ? -2:playerlastentry_as_NS[:dismissedbatsmankey]
				
				if dbk == b
					outtypekey = playerlastentry.nil? ? -2:playerlastentry[:outtypekey]
					wktakingbowlerkey = playerlastentry.nil? ? -2:playerlastentry[:bowlerkey]
					fielderkey = playerlastentry.nil? ? -2:playerlastentry[:fielderkey]
					disabled = outtypekey<=0? false : true				
				elsif dbk1==b
					outtypekey = playerlastentry_as_NS.nil? ? -2:playerlastentry_as_NS[:outtypekey]
					fielderkey = playerlastentry_as_NS.nil? ? -2:playerlastentry_as_NS[:fielderkey]
					wktakingbowlerkey = -2
					disabled = outtypekey<=0? false : true							
				else
					#outtypekey is set to -2 but not others like wktakingbowlerkey because bold is the first element
					#of the select tag where as empty is the first element of the select tag for wktakingbowlerkey
					outtypekey = -2
				end
				
				@batsmen << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, 
							 :counter=>playerlastentry.nil? ? 11:playerlastentry[:battingposition], 
							 :battingposition=>playerlastentry.nil? ? 11:playerlastentry[:battingposition], 
							 :outtypekey=> outtypekey , 
							 :fielderkey =>fielderkey, 
							 :bowlerkey=>playerlastentry.nil? ? -2:playerlastentry[:bowlerkey], 
							 :wktakingbowlerkey=>wktakingbowlerkey,
							 :runs=> stats.nil? ? '':stats[0][:runs],
							 :ballsfaced=>  stats.nil? ? '':stats[0][:ballsfaced],
							 :strikerate=> stats.nil? ? '':stats[0][:strikerate],
							 :zeros=>  stats.nil? ? '':stats[0][:zeros],
							 :ones=>  stats.nil? ? '':stats[0][:ones],
							 :twos=>  stats.nil? ? '':stats[0][:twos],
							 :threes=>  stats.nil? ? '':stats[0][:threes],
							 :fours=>  stats.nil? ? '':stats[0][:fours],
							 :fives=>  stats.nil? ? '':stats[0][:fives],
							 :sixes=>  stats.nil? ? '':stats[0][:sixes],
							 :hilite=> hilite,
							 :disabled=>disabled}
				counter= counter + 1
				pos+=1
				
			end
			
			@batsmen = Scorecard.sortPlayers(@batsmen)
			

			
			#types of dismissals. Add -2 to the entry, which is the default value 
			#i.e. the batsman has not played yet or is still no out.
			#same with the fielder and wicket taking bowlers
			@dismissals = Dismissal.all.collect{|d| [d.dismissaltype, d.id]}
			@dismissals << ['', -2]
			
			@fielders = [['', -2]]
			@fieldingkeys = Team.where('teamid= ?', @fielding_side ).collect {|b| b.playerkey}
			
			@fieldingside = []
			pos = 0
			counter = 0
			@fieldingkeys.each do |b|
				player = Player.find_by_id(b)
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).maximum(:id)
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				stats = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).select('sum(runs+wides+noballs+byes+legbyes) as runs, sum(wides) as wides, sum(noballs) as noballs, sum(byes+legbyes) as others,sum(zeros) as zeros, sum(ones) as ones, sum(twos) as twos, sum(threes) as threes, sum(fours) as fours, sum(fives) as fives, sum(sixes) as sixes, sum(sevens) as sevens, sum(eights) , sum(maiden) as maidens, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets, max(spell) as spell, case when sum(ballsdelivered) = 0 then 0 else sum(runs+wides+noballs+byes+legbyes)/(sum(ballsdelivered)/6.0) end as economy') 
				
				hilite = ''
				otw = ''
				rtw = ''
				if @currentbowlerkey == b
					hilite = 'hilite'
					if @currentbowlingside == 1 
						otw = 'side'
						rtw = ''
					else 
						otw = ''
						rtw = 'side'
					end
				else
					hilite = ''
				end
				
				@fieldingside << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, :playertype=> player.playertype,
								 :bowlingposition=>playerlastentry.nil? ? nil:playerlastentry[:bowlingposition], 
								 :runs=> stats.nil? ? '':stats[0][:runs].nil? ? '':stats[0][:runs],
								 :spell=> stats.nil? ? '':stats[0][:spell].nil? ? 0:stats[0][:spell],
								 :overs=>  stats.nil? ? '':stats[0][:ballsdelivered].nil? ? '':stats[0][:ballsdelivered]/6 + stats[0][:ballsdelivered]%6/10.0,
								 :maidens=> stats.nil? ? '':stats[0][:maidens].nil? ? '':stats[0][:maidens],
								 :zeros=>  stats.nil? ? '':stats[0][:zeros].nil? ? '':stats[0][:zeros],
								 :ones=>  stats.nil? ? '':stats[0][:ones].nil? ? '':stats[0][:ones],
								 :twos=>  stats.nil? ? '':stats[0][:twos].nil? ? '':stats[0][:twos],
								 :threes=>  stats.nil? ? '':stats[0][:threes].nil? ? '':stats[0][:threes],
								 :fours=>  stats.nil? ? '':stats[0][:fours].nil? ? '':stats[0][:fours],
								 :fives=>  stats.nil? ? '':stats[0][:fives].nil? ? '':stats[0][:fives],
								 :sixes=>  stats.nil? ? '':stats[0][:sixes].nil? ? '':stats[0][:sixes],
								 :wides=> stats.nil? ? '':stats[0][:wides].nil? ? '':stats[0][:wides],
								 :noballs=> stats.nil? ? '':stats[0][:noballs].nil? ? '':stats[0][:noballs],
								 :others=> stats.nil? ? '':stats[0][:others].nil? ? '':stats[0][:others],
								 :wickets=> stats.nil? ? '':stats[0][:wickets].nil? ? '':stats[0][:wickets],
								 :economy=> stats.nil? ? '':stats[0][:economy].nil? ? '':stats[0][:economy],
								 :hilite=> hilite,
								 :otw=>otw,
								 :rtw=>rtw}
				@fielders << [player.fullname, b]
				pos = pos+1
				counter = counter + 1
			end
			
				
			@bowlers = []
			@wktakingbowlers = [['', -2]]
			counter = 1
			@fieldingside.each do |b|
				if b[:playertype] == 'Bowler' or b[:playertype] == 'All Rounder'
					temp = b[:bowlingposition].nil? ? 11:b[:bowlingposition]
					b[:bowlingposition] = temp
					@bowlers << b
					@wktakingbowlers << [b[:name],b[:playerkey]]
					counter= counter + 1
				end
			end
			@bowlers = @bowlers.sort_by{|b| b[:bowlingposition]}
		else 
			redirect_to signin_path
		end	
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'scorecards#match_scorecard_one'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  
   def match_scorecard_two
	
		if signed_in?
			@current_client = current_user.username
			@match = Match.find_by_id_and_clientkey(params[:id], current_user.id)
			@teams = Team.find_by_sql('select distinct teamid, teamname from teams where teamid in ('+@match.teamidone.to_s+','+@match.teamidtwo.to_s+')')

			@target = Scorecard.where('matchkey = ? and inning = ? ', params[:id], 1).select('sum(runs+wides+noballs+byes+legbyes) as runs, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets')
			#redirect_to scorecard_first_inning_path({:id=>@match.id})
			#####common entry for all records
			@tournament = Tournament.find_by_id(@match.tournamentkey)
			@venue = Venue.find_by_id(@match.venuekey)
			@format = Format.find_by_id(@match.formatkey)
			@formatarr = []
			@formatarr << @format.name << @format.id
			
			@lines = Line.all
			@lengths = Length.all
			@shottypes = Shottype.all
			
			@batting_side = 0
			@fielding_side = 0
			
			@teamone = Team.find_by_teamid(@match.teamidone)
			@teamtwo = Team.find_by_teamid(@match.teamidtwo)
			
			if @match.tosswon == @match.teamidone
				if @match.electedto == 'Bat'
					#@teamone = Team.find_by_teamid(@match.teamidone)
					#@teamtwo = Team.find_by_teamid(@match.teamidtwo)
					@batting_side = @match.teamidtwo
					@fielding_side = @match.teamidone
				else
					#@teamone = Team.find_by_teamid(@match.teamidtwo)
					#@teamtwo = Team.find_by_teamid(@match.teamidone)
					@batting_side = @match.teamidone
					@fielding_side = @match.teamidtwo
				end
			else
				if @match.electedto == 'Bat'
					#@teamone = Team.find_by_teamid(@match.teamidtwo)
					#@teamtwo = Team.find_by_teamid(@match.teamidone)
					@batting_side = @match.teamidone
					@fielding_side = @match.teamidtwo
				else
					#@teamone = Team.find_by_teamid(@match.teamidone)
					#@teamtwo = Team.find_by_teamid(@match.teamidtwo)
					@batting_side = @match.teamidtwo
					@fielding_side = @match.teamidone
				end
			end
			
			
			if @target[0].ballsdelivered.nil?
				@first_inning_overs = 0.0
			else
				@target[0].ballsdelivered/6 + @target[0].ballsdelivered%6/10.0
			end
			
			#@first_inning_overs = @target[0].ballsdelivered.nil? ? 0.0:@target[0].ballsdelivered/6 + @target[0].ballsdelivered%6/10.0
			@inning = 2
			
			#####Score calculation
			@runs = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? 0:Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).select('sum(runs+wides+noballs+legbyes+byes) as scores')[0][:scores]
			ballsdelivered = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).sum(:ballsdelivered)
			@lastball = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).maximum(:ballnum)
			@lastball = @lastball.nil? ? 0:@lastball
			@overs = ballsdelivered/6 + ballsdelivered%6/10.0
			@wickets =  Scorecard.where('matchkey=? and inning= ?', params[:id], @inning).sum(:wicket)
			@overballnum = (ballsdelivered%6 == 0 and ballsdelivered>0)? 6:ballsdelivered%6  #-ve 1 because to use in between in the next sql
			@runsthisover = Scorecard.where('matchkey=? and inning = ? and ballnum between ? and ?', params[:id], @inning, @lastball==0? 0:@lastball-@overballnum+1, @lastball).select('sum(runs+noballs+byes+legbyes+wides) as runs')[0].runs
			@runsthisover = @runsthisover.nil? ? 0:@runsthisover
			#batting side players
			@batsmankeys = Team.where('teamid= ?', @batting_side ).collect {|b| b.playerkey}
			
			#beginning of calculation of current bowler or batsman or non striker or fielder in action
			#maxid is the last entry id of Scorecard
			@maxid = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.where('matchkey = ? and inning=?', params[:id], @inning).maximum(:id)
			@currentstrikerkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).batsmankey
			@currentnonstrikerkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).currentnonstrikerkey
			@strikerposition =  Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).battingposition
			@maxidwherenonstrikerisstriker = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.where('matchkey = ? and inning=? and currentstrikerkey = ?', params[:id], @inning, @currentnonstrikerkey).maximum(:id)
			@nonstrikerposition = Scorecard.find_by_id(@maxidwherenonstrikerisstriker).nil? ? -2:Scorecard.find_by_id(@maxidwherenonstrikerisstriker).battingposition
			@currentbowlerkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).currentbowlerkey
			@currentbowlingside = Scorecard.where('matchkey=? and inning = ? and currentbowlerkey=?', params[:id], @inning, @currentbowlerkey).first.nil? ? -2:Scorecard.find_by_id(@maxid).side			
			@lastrun = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).runs
			@lastbye = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).byes
			@lastlbye = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).legbyes
			@lastnoball = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).noballs
			@lastwide = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).wides
			
			@battingposition = [1,2,3,4,5,6,7,8,9,10,11]
			@bowlingposition = [1,2,3,4,5,6,7,8,9,10,11]
			@venue = Venue.find_all_by_id(@match.venuekey)

			
			#last batting end and last bowling end
			@battingendkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? 0:Scorecard.find_by_id(@maxid).battingendkey
			@bowlingendkey = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? 1:Scorecard.find_by_id(@maxid).bowlingendkey	
			@battingend = []
			@battingend << (@battingendkey ==0? {'value'=> @battingendkey, 'name'=> @venue[0].endone}:{'value'=> @battingendkey, 'name'=> @venue[0].endtwo} )
			@battingend << (@bowlingendkey==1?  {'value'=>@bowlingendkey, 'name'=>@venue[0].endtwo}:{'value'=>@bowlingendkey, 'name'=>@venue[0].endone})
						
			@battingendname = @battingend[@battingendkey]
			@bowlingendname = @battingend[@bowlingendkey]			

	
			#if it is an over and the last runs taken is not one or three or five and it is not zero ball with some wides or noballs, 
			#then swap the striker and non striker, and swap the batting end and bowling end
			if ballsdelivered%6!=0 and (@lastrun%2==1 or @lastbye%2== 1 or @lastlbye%2 == 1)
				temp = @currentstrikerkey
				@currentstrikerkey = @currentnonstrikerkey
				@currentnonstrikerkey = temp
				
				temp1 = @battingendkey
				@battingendkey = @bowlingendkey
				@bowlingendkey = temp1
			elsif ballsdelivered%6!=0 and (@lastrun%2==0 and @lastbye%2 == 0 and @lastlbye%2 == 0)
				@currentstrikerkey = @currentstrikerkey
				@currentnonstrikerkey = @currentnonstrikerkey
			elsif ballsdelivered%6==0 and ((@lastnoball == 0 and (@lastrun%2==1 or @lastbye%2 == 1 or @lastlbye%2 == 1)) or (@lastwide%2==1 or @lastwide==4) or (@lastnoball==1 and (@lastbye%2==0 and @lastlbye%2==0 and @lastrun%2==0)))
				@currentstrikerkey = @currentstrikerkey
				@currentnonstrikerkey = @currentnonstrikerkey
			elsif ballsdelivered%6==0 and ((@lastnoball>0 and (@lastbye%2==1 or @lastlbye%2==1 or @lastrun%2==1)) or (@lastnoball == 0 and (@lastrun%2==0 and @lastbye%2== 0 and @lastlbye%2 == 0)) or (@lastwide%2==0 and (@lastwide != 1 or @lastwide!=4)))
				
				temp = @currentstrikerkey
				@currentstrikerkey = @currentnonstrikerkey
				@currentnonstrikerkey = temp
			end	
			
			if ballsdelivered%6 == 0
				temp1 = @battingendkey
				@battingendkey = @bowlingendkey
				@bowlingendkey = temp1
			end


			#counter is the way to add pre populated position to the batsmen.
			@batsmen = []
			counter = 1
			pos = 0
			
			@batsmankeys.each do |b|	
				if counter >11
					break
				end
				player = Player.find_by_id(b)
				#this is the last entry id of the bastman b
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and batsmankey=?', params[:id],@inning,b).maximum(:id)

				#get the stats of batsman b so far.
				stats_query = 'select SUM(runs) as runs, sum(zeros) as zeros, SUM(ones) as ones, SUM(twos) as twos, SUM(threes) as threes, SUM(fours) as fours, SUM(fives) as fives, SUM(sixes) as sixes, SUM(ballsfaced) as ballsfaced,  case when sum(ballsfaced) = 0 then 0 else sum(runs)/(sum(ballsfaced)*1.0)*100 end as strikerate
								from
								(
								select 
								runs, 
								zeros,
								case when runs>0 then ones else 0 end as ones, 
								case when runs>0 then twos else 0 end twos, 
								case when runs>0 then threes else 0 end threes, 
								case when runs>0 then fours else 0 end fours, 
								case when runs>0 then fives else 0 end fives, 
								case when runs>0 then sixes else 0 end sixes, 
								ballsfaced 
								from scorecards where matchkey = '+params[:id].to_s+' and clientkey = '+current_user.id.to_s+' and batsmankey = '+b.to_s+' and inning='+@inning.to_s+'
								)A
								'
				stats = Scorecard.find_by_sql(stats_query)
				
				hilite = ''
				if @currentstrikerkey == b
					hilite='hilite'
				elsif @currentnonstrikerkey == b
					hilite='hilite-nonstriker'
				end
				
				#get the last entry of the batsman b and get his information
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				outtypekey = playerlastentry.nil? ? -2:playerlastentry[:outtypekey]
				wktakingbowlerkey = outtypekey!=1? -2:playerlastentry[:bowlerkey]
				disabled = outtypekey<=0? false : true
				@batsmen << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, 
							 :counter=>playerlastentry.nil? ? 11:playerlastentry[:battingposition], 
							 :battingposition=>playerlastentry.nil? ? 11:playerlastentry[:battingposition], 
							 :outtypekey=> playerlastentry.nil? ? -2:playerlastentry[:outtypekey], 
							 :fielderkey =>playerlastentry.nil? ? -2:playerlastentry[:fielderkey], 
							 :bowlerkey=>playerlastentry.nil? ? -2:playerlastentry[:bowlerkey], 
							 :wktakingbowlerkey=>wktakingbowlerkey,
							 :runs=> stats.nil? ? '':stats[0][:runs],
							 :ballsfaced=>  stats.nil? ? '':stats[0][:ballsfaced],
							 :strikerate=> stats.nil? ? '':stats[0][:strikerate],
							 :zeros=>  stats.nil? ? '':stats[0][:zeros],
							 :ones=>  stats.nil? ? '':stats[0][:ones],
							 :twos=>  stats.nil? ? '':stats[0][:twos],
							 :threes=>  stats.nil? ? '':stats[0][:threes],
							 :fours=>  stats.nil? ? '':stats[0][:fours],
							 :fives=>  stats.nil? ? '':stats[0][:fives],
							 :sixes=>  stats.nil? ? '':stats[0][:sixes],
							 :hilite=> hilite,
							 :disabled=>disabled}
				counter= counter + 1
				pos+=1
				
			end
			
			@batsmen = @batsmen.sort_by{|b| b[:battingposition]}

			#types of dismissals. Add -2 to the entry, which is the default value 
			#i.e. the batsman has not played yet or is still no out.
			#same with the fielder and wicket taking bowlers
			@dismissals = Dismissal.all.collect{|d| [d.dismissaltype, d.id]}
			@dismissals << ['', -2]
			
			@fielders = [['', -2]]
			@fieldingkeys = Team.where('teamid= ?', @fielding_side ).collect {|b| b.playerkey}
			
			@fieldingside = []
			pos = 0
			counter = 0
			@fieldingkeys.each do |b|
				player = Player.find_by_id(b)
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).maximum(:id)
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				stats = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).select('sum(runs+wides+noballs+byes+legbyes) as runs, sum(wides) as wides, sum(noballs) as noballs, sum(byes+legbyes) as others,sum(zeros) as zeros, sum(ones) as ones, sum(twos) as twos, sum(threes) as threes, sum(fours) as fours, sum(fives) as fives, sum(sixes) as sixes, sum(sevens) as sevens, sum(eights) , sum(maiden) as maidens, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets, max(spell) as spell, case when sum(ballsdelivered) = 0 then 0 else sum(runs+wides+noballs+byes+legbyes)/(sum(ballsdelivered)/6.0) end as economy') 
				
				hilite = ''
				otw = ''
				rtw = ''
				if @currentbowlerkey == b
					hilite = 'hilite'
					if @currentbowlingside == 1 
						otw = 'side'
						rtw = ''
					else 
						otw = ''
						rtw = 'side'
					end
				else
					hilite = ''
				end
				
				@fieldingside << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, :playertype=> player.playertype,
								 :bowlingposition=>playerlastentry.nil? ? nil:playerlastentry[:bowlingposition], 
								 :runs=> stats.nil? ? '':stats[0][:runs].nil? ? '':stats[0][:runs],
								 :spell=> stats.nil? ? '':stats[0][:spell].nil? ? 0:stats[0][:spell],								 
								 :overs=>  stats.nil? ? '':stats[0][:ballsdelivered].nil? ? '':stats[0][:ballsdelivered]/6 + stats[0][:ballsdelivered]%6/10.0,
								 :maidens=> stats.nil? ? '':stats[0][:maidens].nil? ? '':stats[0][:maidens],
								 :zeros=>  stats.nil? ? '':stats[0][:zeros].nil? ? '':stats[0][:zeros],
								 :ones=>  stats.nil? ? '':stats[0][:ones].nil? ? '':stats[0][:ones],
								 :twos=>  stats.nil? ? '':stats[0][:twos].nil? ? '':stats[0][:twos],
								 :threes=>  stats.nil? ? '':stats[0][:threes].nil? ? '':stats[0][:threes],
								 :fours=>  stats.nil? ? '':stats[0][:fours].nil? ? '':stats[0][:fours],
								 :fives=>  stats.nil? ? '':stats[0][:fives].nil? ? '':stats[0][:fives],
								 :sixes=>  stats.nil? ? '':stats[0][:sixes].nil? ? '':stats[0][:sixes],
								 :wides=> stats.nil? ? '':stats[0][:wides].nil? ? '':stats[0][:wides],
								 :noballs=> stats.nil? ? '':stats[0][:noballs].nil? ? '':stats[0][:noballs],
								 :others=> stats.nil? ? '':stats[0][:others].nil? ? '':stats[0][:others],
								 :wickets=> stats.nil? ? '':stats[0][:wickets].nil? ? '':stats[0][:wickets],
								 :economy=> stats.nil? ? '':stats[0][:economy].nil? ? '':stats[0][:economy],
								 :hilite=> hilite,
								 :otw=>otw,
								 :rtw=>rtw}
				@fielders << [player.fullname, b]
				pos = pos+1
				counter = counter + 1
			end
			
			
				
			@bowlers = []
			@wktakingbowlers = [['', -2]]
			counter = 1
			@fieldingside.each do |b|
				if b[:playertype] == 'Bowler' or b[:playertype] == 'All Rounder'
					temp = b[:bowlingposition].nil? ? 11:b[:bowlingposition]
					b[:bowlingposition] = temp
					@bowlers << b
					@wktakingbowlers << [b[:name],b[:playerkey]]
					counter= counter + 1
				end
			end
			
			@bowlers = @bowlers.sort_by{|b| b[:bowlingposition]}
		else 
			redirect_to signin_path
		end	

  end


  
  
  
   def scorecard

		if signed_in?
			@current_client = current_user.username
			@match = Match.find_by_id(params[:id])
		
			################################ First Inning ##########################################3
			
			
			@score_first_inning = Scorecard.where('matchkey = ? and inning = ? ', params[:id], 1).select('sum(runs+wides+noballs+byes+legbyes) as runs, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets')
			#####common entry for all records
			@tournament = Tournament.find_by_id(@match.tournamentkey)
			@venue = Venue.find_by_id(@match.venuekey)
			@format = Format.find_by_id(@match.formatkey)
			@formatarr = []
			@formatarr << @format.name << @format.id
			
			@batting_side = 0
			@fielding_side = 0
			
			@teamone = Team.find_by_teamid(@match.teamidone)
			@teamtwo = Team.find_by_teamid(@match.teamidtwo)
			
			if @match.tosswon == @match.teamidone
				if @match.electedto == 'Bat'
					#@teamone = Team.find_by_teamid(@match.teamidone)
					#@teamtwo = Team.find_by_teamid(@match.teamidtwo)
					@batting_side = @match.teamidone
					@fielding_side = @match.teamidtwo
				else
					#@teamone = Team.find_by_teamid(@match.teamidtwo)
					#@teamtwo = Team.find_by_teamid(@match.teamidone)
					@batting_side = @match.teamidtwo
					@fielding_side = @match.teamidone
				end
			else
				if @match.electedto == 'Bat'
					#@teamone = Team.find_by_teamid(@match.teamidtwo)
					#@teamtwo = Team.find_by_teamid(@match.teamidone)
					@batting_side = @match.teamidtwo
					@fielding_side = @match.teamidone
				else
					#@teamone = Team.find_by_teamid(@match.teamidone)
					#@teamtwo = Team.find_by_teamid(@match.teamidtwo)
					@batting_side = @match.teamidone
					@fielding_side = @match.teamidtwo
				end
			end
			
			if @score_first_inning[0].ballsdelivered.nil?
				@first_inning_overs = 0.0
			else
				@score_first_inning[0].ballsdelivered/6 + @score_first_inning[0].ballsdelivered%6/10.0
			end
			
			#@first_inning_overs = @target[0].ballsdelivered.nil? ? 0.0:@target[0].ballsdelivered/6 + @target[0].ballsdelivered%6/10.0
			@inning = 1
			
			#####Score calculation
			@runs = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? 0:Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).select('sum(runs+wides+noballs+legbyes+byes) as scores')[0][:scores]
			ballsdelivered = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).sum(:ballsdelivered)
			@overs = ballsdelivered/6 + ballsdelivered%6/10.0
			@wickets =  Scorecard.where('matchkey=? and inning= ?', params[:id], @inning).sum(:wicket)

			#batting side players
			@batsmankeys = Team.where('teamid= ?', @batting_side).collect {|b| b.playerkey}
			

			@battingposition = [1,2,3,4,5,6,7,8,9,10,11]
			@bowlingposition = [1,2,3,4,5,6,7,8,9,10,11]
			@venue = Venue.find_all_by_id(@match.venuekey)



			#counter is the way to add pre populated position to the batsmen.
			@batsmen = []
			counter = 1
			pos = 0
			@batsmankeys.each do |b|	
				if counter >11
					break
				end
				
				player = Player.find_by_id(b)
				#this is the last entry id of the bastman b
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and batsmankey=?', params[:id],@inning,b).maximum(:id)
				stats_query = 'select SUM(runs) as runs, sum(zeros) as zeros, SUM(ones) as ones, SUM(twos) as twos, SUM(threes) as threes, SUM(fours) as fours, SUM(fives) as fives, SUM(sixes) as sixes, SUM(ballsfaced) as ballsfaced,  case when sum(ballsfaced) = 0 then 0 else sum(runs)/(sum(ballsfaced)*1.0)*100 end as strikerate
				from
				(
				select 
				runs, 
				zeros,
				case when runs>0 then ones else 0 end as ones, 
				case when runs>0 then twos else 0 end twos, 
				case when runs>0 then threes else 0 end threes, 
				case when runs>0 then fours else 0 end fours, 
				case when runs>0 then fives else 0 end fives, 
				case when runs>0 then sixes else 0 end sixes, 
				ballsfaced 
				from scorecards where matchkey = '+params[:id].to_s+' and clientkey = '+current_user.id.to_s+' and batsmankey = '+b.to_s+' and inning='+@inning.to_s+'
				)A
				'
				stats = Scorecard.find_by_sql(stats_query)
				#get the last entry of the batsman b and get his information
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				outtypekey = playerlastentry.nil? ? -2:playerlastentry[:outtypekey]
				wktakingbowlerkey = outtypekey!=1? -2:playerlastentry[:bowlerkey]
				disabled = outtypekey<=0? false : true
				@batsmen << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, :counter=>counter, 
							 :battingposition=>playerlastentry.nil? ? counter:playerlastentry[:battingposition], 
							 :outtypekey=> playerlastentry.nil? ? -2:playerlastentry[:outtypekey], 
							 :fielderkey =>playerlastentry.nil? ? -2:playerlastentry[:fielderkey], 
							 :bowlerkey=>playerlastentry.nil? ? -2:playerlastentry[:bowlerkey], 
							 :wktakingbowlerkey=>wktakingbowlerkey,
							 :runs=> stats.nil? ? '':stats[0][:runs],
							 :ballsfaced=>  stats.nil? ? '':stats[0][:ballsfaced],
							 :strikerate=> stats.nil? ? '':stats[0][:strikerate],
							 :zeros=>  stats.nil? ? '':stats[0][:zeros],
							 :ones=>  stats.nil? ? '':stats[0][:ones],
							 :twos=>  stats.nil? ? '':stats[0][:twos],
							 :threes=>  stats.nil? ? '':stats[0][:threes],
							 :fours=>  stats.nil? ? '':stats[0][:fours],
							 :fives=>  stats.nil? ? '':stats[0][:fives],
							 :sixes=>  stats.nil? ? '':stats[0][:sixes]}
				counter= counter + 1
				pos+=1
				
			end
			
			@batsmen = @batsmen.sort_by{|b| b[:battingposition]}

			#types of dismissals. Add -2 to the entry, which is the default value 
			#i.e. the batsman has not played yet or is still no out.
			#same with the fielder and wicket taking bowlers
			@dismissals = Dismissal.all
			@dismissals[-2] = ''
			
			@fielders = {}
			@fielders[-2] = ''
			@fieldingkeys = Team.where('teamid= ?', @fielding_side ).collect {|b| b.playerkey}
			
			@fieldingside = []
			pos = 0
			counter = 0
			@fieldingkeys.each do |b|
				player = Player.find_by_id(b)
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).maximum(:id)
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				stats = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).select('sum(runs+wides+noballs+byes+legbyes) as runs, sum(wides) as wides, sum(noballs) as noballs, sum(byes+legbyes) as others,sum(zeros) as zeros, sum(ones) as ones, sum(twos) as twos, sum(threes) as threes, sum(fours) as fours, sum(fives) as fives, sum(sixes) as sixes, sum(sevens) as sevens, sum(eights) , sum(maiden) as maidens, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets, case when sum(ballsdelivered) = 0 then 0 else sum(runs)/(sum(ballsdelivered)/6.0) end as economy') 
	
				@fieldingside << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, :playertype=> player.playertype,
								 :bowlingposition=>playerlastentry.nil? ? nil:playerlastentry[:bowlingposition], 
								 :runs=> stats.nil? ? '':stats[0][:runs].nil? ? '':stats[0][:runs],
								 :overs=>  stats.nil? ? '':stats[0][:ballsdelivered].nil? ? '':stats[0][:ballsdelivered]/6 + stats[0][:ballsdelivered]%6/10.0,
								 :maidens=> stats.nil? ? '':stats[0][:maidens].nil? ? '':stats[0][:maidens],
								 :zeros=>  stats.nil? ? '':stats[0][:zeros].nil? ? '':stats[0][:zeros],
								 :ones=>  stats.nil? ? '':stats[0][:ones].nil? ? '':stats[0][:ones],
								 :twos=>  stats.nil? ? '':stats[0][:twos].nil? ? '':stats[0][:twos],
								 :threes=>  stats.nil? ? '':stats[0][:threes].nil? ? '':stats[0][:threes],
								 :fours=>  stats.nil? ? '':stats[0][:fours].nil? ? '':stats[0][:fours],
								 :fives=>  stats.nil? ? '':stats[0][:fives].nil? ? '':stats[0][:fives],
								 :sixes=>  stats.nil? ? '':stats[0][:sixes].nil? ? '':stats[0][:sixes],
								 :wides=> stats.nil? ? '':stats[0][:wides].nil? ? '':stats[0][:wides],
								 :noballs=> stats.nil? ? '':stats[0][:noballs].nil? ? '':stats[0][:noballs],
								 :others=> stats.nil? ? '':stats[0][:others].nil? ? '':stats[0][:others],
								 :wickets=> stats.nil? ? '':stats[0][:wickets].nil? ? '':stats[0][:wickets],
								 :economy=> stats.nil? ? '':stats[0][:economy].nil? ? '':stats[0][:economy]
								 }
				@fielders[b] = player.fullname
				pos = pos+1
				counter = counter + 1
			end
			
			
				
			@bowlers = []
			@wktakingbowlers = {}
			@wktakingbowlers[-2] = ''
			counter = 0
			@fieldingside.each do |b|
				if b[:playertype] == 'Bowler' or b[:playertype] == 'All Rounder'
					temp = b[:bowlingposition].nil? ? counter:b[:bowlingposition]
					b[:bowlingposition] = temp
					@bowlers << b
					@wktakingbowlers[b[:playerkey]] = [b[:name]]
					counter= counter + 1
				end
			end
			
			@bowlers = @bowlers.sort_by{|b| b[:bowlingposition]}
			
			
			################################ Second Inning ##########################################3
			
			
			@score_second_inning = Scorecard.where('matchkey = ? and inning = ? ', params[:id], 1).select('sum(runs+wides+noballs+byes+legbyes) as runs, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets')
			#####common entry for all records

			
			if @score_second_inning[0].ballsdelivered.nil?
				@first_inning_overs = 0.0
			else
				@score_second_inning[0].ballsdelivered/6 + @score_second_inning[0].ballsdelivered%6/10.0
			end
			
			#@first_inning_overs = @target[0].ballsdelivered.nil? ? 0.0:@target[0].ballsdelivered/6 + @target[0].ballsdelivered%6/10.0
			@inning = 2
			
			#####Score calculation
			@runs1 = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).first.nil? ? 0:Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).select('sum(runs+wides+noballs+legbyes+byes) as scores')[0][:scores]
			ballsdelivered = Scorecard.where('matchkey=? and inning = ?', params[:id], @inning).sum(:ballsdelivered)
			@overs1 = ballsdelivered/6 + ballsdelivered%6/10.0
			@wickets1 =  Scorecard.where('matchkey=? and inning= ?', params[:id], @inning).sum(:wicket)

			#batting side players
			@batsmankeys1 = Team.where('teamid= ?', @fielding_side ).collect {|b| b.playerkey}
			

			@battingposition = [1,2,3,4,5,6,7,8,9,10,11]
			@bowlingposition = [1,2,3,4,5,6,7,8,9,10,11]




			#counter is the way to add pre populated position to the batsmen.
			@batsmen1 = []
			counter = 1
			pos = 0
			
			@batsmankeys1.each do |b|	
				if counter >11
					break
				end
				player = Player.find_by_id(b)
				#this is the last entry id of the bastman b
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and batsmankey=?', params[:id],@inning,b).maximum(:id)
				stats_query = 'select SUM(runs) as runs, sum(zeros) as zeros, SUM(ones) as ones, SUM(twos) as twos, SUM(threes) as threes, SUM(fours) as fours, SUM(fives) as fives, SUM(sixes) as sixes, SUM(ballsfaced) as ballsfaced,  case when sum(ballsfaced) = 0 then 0 else sum(runs)/(sum(ballsfaced)*1.0)*100 end as strikerate
				from
				(
				select 
				runs, 
				zeros,
				case when runs>0 then ones else 0 end as ones, 
				case when runs>0 then twos else 0 end twos, 
				case when runs>0 then threes else 0 end threes, 
				case when runs>0 then fours else 0 end fours, 
				case when runs>0 then fives else 0 end fives, 
				case when runs>0 then sixes else 0 end sixes, 
				ballsfaced 
				from scorecards where matchkey = '+params[:id].to_s+' and clientkey = '+current_user.id.to_s+' and batsmankey = '+b.to_s+' and inning='+@inning.to_s+'
				)A
				'
				stats = Scorecard.find_by_sql(stats_query)	
				
				#get the last entry of the batsman b and get his information
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				outtypekey = playerlastentry.nil? ? -2:playerlastentry[:outtypekey]
				wktakingbowlerkey = outtypekey!=1? -2:playerlastentry[:bowlerkey]
				disabled = outtypekey<=0? false : true
				@batsmen1 << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, :counter=>counter, 
							 :battingposition=>playerlastentry.nil? ? counter:playerlastentry[:battingposition], 
							 :outtypekey=> playerlastentry.nil? ? -2:playerlastentry[:outtypekey], 
							 :fielderkey =>playerlastentry.nil? ? -2:playerlastentry[:fielderkey], 
							 :bowlerkey=>playerlastentry.nil? ? -2:playerlastentry[:bowlerkey], 
							 :wktakingbowlerkey=>wktakingbowlerkey,
							 :runs=> stats.nil? ? '':stats[0][:runs],
							 :ballsfaced=>  stats.nil? ? '':stats[0][:ballsfaced],
							 :strikerate=> stats.nil? ? '':stats[0][:strikerate],
							 :zeros=>  stats.nil? ? '':stats[0][:zeros],
							 :ones=>  stats.nil? ? '':stats[0][:ones],
							 :twos=>  stats.nil? ? '':stats[0][:twos],
							 :threes=>  stats.nil? ? '':stats[0][:threes],
							 :fours=>  stats.nil? ? '':stats[0][:fours],
							 :fives=>  stats.nil? ? '':stats[0][:fives],
							 :sixes=>  stats.nil? ? '':stats[0][:sixes]}
				counter= counter + 1
				pos+=1
				
			end
			@batsmen1 = @batsmen1.sort_by{|b| b[:battingposition]}

			#types of dismissals. Add -2 to the entry, which is the default value 
			#i.e. the batsman has not played yet or is still no out.
			#same with the fielder and wicket taking bowlers
			@dismissals1 = Dismissal.all
			@dismissals1[-2] = ''
			
			@fielders1 = {}
			@fielders1[-2] = ''
			@fieldingkeys1 = Team.where('teamid= ?',@batting_side ).collect {|b| b.playerkey}
			
			@fieldingside1 = []
			pos = 0
			counter = 0
			@fieldingkeys1.each do |b|
				player = Player.find_by_id(b)
				playerlastentry_id = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).maximum(:id)
				playerlastentry = Scorecard.find_by_id(playerlastentry_id)
				stats = Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', params[:id],@inning,b).select('sum(runs+wides+noballs+byes+legbyes) as runs, sum(wides) as wides, sum(noballs) as noballs, sum(byes+legbyes) as others,sum(zeros) as zeros, sum(ones) as ones, sum(twos) as twos, sum(threes) as threes, sum(fours) as fours, sum(fives) as fives, sum(sixes) as sixes, sum(sevens) as sevens, sum(eights) , sum(maiden) as maidens, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets, case when sum(ballsdelivered) = 0 then 0 else sum(runs)/(sum(ballsdelivered)/6.0) end as economy') 
	
				@fieldingside1 << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, :playertype=> player.playertype,
								 :bowlingposition=>playerlastentry.nil? ? nil:playerlastentry[:bowlingposition], 
								 :runs=> stats.nil? ? '':stats[0][:runs].nil? ? '':stats[0][:runs],
								 :overs=>  stats.nil? ? '':stats[0][:ballsdelivered].nil? ? '':stats[0][:ballsdelivered]/6 + stats[0][:ballsdelivered]%6/10.0,
								 :maidens=> stats.nil? ? '':stats[0][:maidens].nil? ? '':stats[0][:maidens],
								 :zeros=>  stats.nil? ? '':stats[0][:zeros].nil? ? '':stats[0][:zeros],
								 :ones=>  stats.nil? ? '':stats[0][:ones].nil? ? '':stats[0][:ones],
								 :twos=>  stats.nil? ? '':stats[0][:twos].nil? ? '':stats[0][:twos],
								 :threes=>  stats.nil? ? '':stats[0][:threes].nil? ? '':stats[0][:threes],
								 :fours=>  stats.nil? ? '':stats[0][:fours].nil? ? '':stats[0][:fours],
								 :fives=>  stats.nil? ? '':stats[0][:fives].nil? ? '':stats[0][:fives],
								 :sixes=>  stats.nil? ? '':stats[0][:sixes].nil? ? '':stats[0][:sixes],
								 :wides=> stats.nil? ? '':stats[0][:wides].nil? ? '':stats[0][:wides],
								 :noballs=> stats.nil? ? '':stats[0][:noballs].nil? ? '':stats[0][:noballs],
								 :others=> stats.nil? ? '':stats[0][:others].nil? ? '':stats[0][:others],
								 :wickets=> stats.nil? ? '':stats[0][:wickets].nil? ? '':stats[0][:wickets],
								 :economy=> stats.nil? ? '':stats[0][:economy].nil? ? '':stats[0][:economy]
								 }
				@fielders[b] = player.fullname
				pos = pos+1
				counter = counter + 1
			end
			
			
				
			@bowlers1 = []
			@wktakingbowlers1={}
			@wktakingbowlers1[-2] = ''
			counter = 0
			@fieldingside1.each do |b|
				if b[:playertype] == 'Bowler' or b[:playertype] == 'All Rounder'
					temp = b[:bowlingposition].nil? ? counter:b[:bowlingposition]
					b[:bowlingposition] = temp
					@bowlers1 << b
					@wktakingbowlers1[b[:playerkey]] = [b[:name]]
					counter= counter + 1
				end
			end
			@bowlers1 = @bowlers1.sort_by{|b| b[:bowlingposition]}
		else 
			redirect_to signin_path
		end	
		
		respond_to do |format| 
		  format.html {render :layout => false}
		end

  end

  
  
  def match_analysis
	@runrateperover = 0.0
	@runsperover = 0
	@fallofwickets = []
	@partnerships = []
  end
    
end
