class MatchesController < ApplicationController

	caches_page :scorecard
  # GET /matches
  # GET /matches.json
  def index

		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@matches = Match.all
			else
				@matches = Match.where('clientkey=?', current_user.id ).all
			end
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'order'
			
			respond_to do |format|
			  format.html # index.html.erb
			  format.json { render json: @matches }
			end
		else 
			redirect_to signin_path
		end
  end

  # GET /matches/1
  # GET /matches/1.json
=begin 
 def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @match }
    end
  end
=end

  # GET /matches/new
  # GET /matches/new.json
  def new
		if signed_in?
			@current_client = current_user.username
			@match = Match.new
			
			@matches = Match.all
			
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'order'	
			@img = '/assets/create.png'
			@dImg = 'create'
			
			@formats = Format.all.collect {|t| [ t.name,t.id]}
			@tournaments = Tournament.where('clientkey=?', current_user.id).collect {|t| [ t.name,t.id]}

			@tournaments = @tournaments.sort_by{|k| -k[1]}
			
			@teams = Team.where('clientkey=?', current_user.id).select('distinct teamid, teamname').collect {|t| [ t.teamname,t.teamid]}
			@teams << ['', -2]
			@teams = @teams.sort_by{|k| k[0]}
			
			@electedto = ['','Bat', 'Bowl']

			@venues = Venue.where('clientkey=?', current_user.id).collect {|t| [ t.venuename,t.id]}
			@venues << ['', -2]
			@venues = @venues.sort_by{|k| k[0]}
			
			@matchtypes = MatchType.all.collect {|t| [ t.matchtype,t.id]}
			@matchtypes = @matchtypes.sort_by{|k| -k[1]}

			@match_result = "no_result_yet"

			respond_to do |format|
			  format.html # new.html.erb
			  format.json { render json: @match }
			end
		else 
			redirect_to signin_path
		end
  end
  
  def pitchconditions
	@matches = Match.where('clientkey = ?', current_user.id).select(:pitchcondition).uniq
	@pitchconditions = []
	@matches.each do |m|
		@pitchconditions << m.pitchcondition
	end
	respond_to do |format|
		format.json { render json: @pitchconditions}
	end
  end
  
  

  # GET /matches/1/edit
  def edit
	begin
		if signed_in?
			@current_client = current_user.username
			@match = Match.find(params[:id])

			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'order'	
			@img = '/assets/update.png'
			@dImg = 'update'
			@formats = Format.all.collect {|t| [ t.name,t.id]}
			@tournaments = Tournament.where('clientkey=?', current_user.id).collect {|t| [ t.name,t.id]}

			@tournaments = @tournaments.sort_by{|k| -k[1]}
			
			@teams = Team.where('clientkey=?', current_user.id).select('distinct teamid, teamname').collect {|t| [ t.teamname,t.teamid]}
			@teams << ['', -2]
			@teams = @teams.sort_by{|k| k[0]}
			
			@venues = Venue.where('clientkey=?', current_user.id).collect {|t| [ t.venuename,t.id]}
			@venues << ['', -2]
			@venues = @venues.sort_by{|k| k[0]}
			
			@electedto = ['','Bat', 'Bowl']

			@matchtypes = MatchType.all.collect {|t| [ t.matchtype,t.id]}
			@matchtypes = @matchtypes.sort_by{|k| -k[1]}
			
			case @match.matchwonortied
			when true
				@checked_won = true
			when false
				@checked_tied = true
			end
			@match_result = "match_result"
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'matches#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end	
  end

  # POST /matches
  # POST /matches.json
  def create
	begin
		@match = Match.new(params[:match])
		
		#csv_text = File.read(Rails.root.join('bin', 'scorecards.csv').to_s)
		#	csv = CSV.parse(csv_text, :headers => true)
		#	csv.each do |row|
		#		row = row.to_hash
		#	binding.pry
		#end

		respond_to do |format|
		  if @match.save
			format.html { redirect_to @match, notice: 'Match was successfully created.' }
			format.js   {render 'success_create.js.erb'}
			format.json { render json: @match, status: :created, location: @match }
		  else
			format.html { render action: "new" }
			format.js   {render 'fail_create.js.erb'}
			format.json { render json: @match.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'matches#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /matches/1
  # PUT /matches/1.json
  def update
	begin
		if signed_in?
			@current_client = current_user.username
			@match = Match.find(params[:id])
			respond_to do |format|
			  if @match.update_attributes(params[:match])
				format.html { redirect_to @match, notice: 'Match was successfully updated.' }
				format.js   {render 'success_update.js.erb'}
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @match.errors, status: :unprocessable_entity }
			  end
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'matches#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  
  def match_details

		if 	signed_in?
			@current_client = current_user.username
			@match = Match.find(params[:id])
			respond_to do |format|
			  if @match.update_attributes(:details=> params[:details], :winnerkey=> params[:winnerkey])
				format.json { head :no_content }
			  else
				format.json { render json: @match.errors, status: :unprocessable_entity }
			  end
			end
		else 
			redirect_to signin_path
		end

  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
	begin
		if signed_in?
			@match = Match.find(params[:id])
			@match.destroy
			respond_to do |format|
			  format.html { redirect_to matches_url }
			  format.json { head :no_content }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'matches#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

=begin  
  def match_status
	begin
		if signed_in?
			@match = Match.find_by_id(params[:id])
			@matchid = @match.id
			#@runsperover = Scorecard.find_by_sql('select ballnum, convert(varchar, inning) as inning,SUM(runs) as runs from scorecards s where clientkey= '+current_user.id.to_s+' and matchkey= '+params[:id].to_s+' group by inning, ballnum ')
			
			rpo_sql = '
					select A.[over], convert(varchar,A.inning) as inning , SUM(runs+wides+noballs+legbyes+byes) as runs
					from
					(
					select distinct s.inning, s1.[over], s.clientkey, s.matchkey
					from scorecards s cross join scorecards s1 
					where  s.clientkey= '+current_user.id.to_s+' and s.matchkey= '+params[:id].to_s+'
					and  s1.clientkey= '+current_user.id.to_s+' and s1.matchkey= '+params[:id].to_s+'
					)A
					LEFT join scorecards s on A.inning = s.inning and A.[over] = s.[over] and A.clientkey = s.clientkey and A.matchkey = s.matchkey
					group by A.inning, A.[over] 
					order by A.inning, A.[over]
					' 

			crpo_sql = '
					select A.[over], convert(varchar,A.inning) as inning , SUM(runs+wides+noballs+legbyes+byes) as runs
					from
					(
					select distinct s.inning, s1.[over], s.clientkey, s.matchkey
					from scorecards s cross join scorecards s1 
					where  s.clientkey= '+current_user.id.to_s+' and s.matchkey= '+params[:id].to_s+'
					and  s1.clientkey= '+current_user.id.to_s+' and s1.matchkey= '+params[:id].to_s+'
					)A
					LEFT join scorecards s on A.inning = s.inning and A.[over] >= s.[over] and A.clientkey = s.clientkey and A.matchkey = s.matchkey
					group by A.inning, A.[over] 
					order by A.inning, A.[over]
					'
			@runsperover = Scorecard.find_by_sql(rpo_sql)
			@cumulativerunsperover =  Scorecard.find_by_sql(crpo_sql)

			@ti = Scorecard.where('clientkey=? and matchkey=?', current_user.id, @matchid).select('count(distinct inning) as c_inning')
			@totalinnings = @ti.nil? ? 0:@ti[0].c_inning
			@currentinning = Scorecard.where('clientkey=? and matchkey=?', current_user.id, @matchid).select('max(inning) as inning')
			@current = Scorecard.where('clientkey=? and matchkey=? and inning=?', current_user.id, @matchid, @currentinning[0].inning).select('SUM(runs+wides+noballs+legbyes+byes)/(max([over]*1.0)) as runrate, max([over]) as currentover, sum(runs) as score, max(ballnum) as currball')
			@lastfiveRR = Scorecard.where('clientkey=? and matchkey=? and inning=?', current_user.id, @matchid, @currentinning[0].inning).select('SUM(runs+wides+noballs+legbyes+byes)/(count(distinct [over])*1.0) as runrate').where('[over] between '+(@current[0].currentover-4).to_s + ' and '+ @current[0].currentover.to_s)
			@totalmatchballs = @match.matchovers * 6
			
			@currentoverindecimal = @current[0].currball/6 + @current[0].currball%6/6.0
			@ballsremaining = @totalmatchballs - @current[0].currball
			
			@oversremaining = @ballsremaining/6+@ballsremaining%6/6.0
			
			@projectedwithCurrRR = (@current[0].runrate * @oversremaining).to_i + @current[0].score
			
			@projectedwithsix = (6 * @oversremaining).to_i + @current[0].score
			@projectedwitheight = (8 * @oversremaining).to_i + @current[0].score
			
			@arrRunsPerOver = Match.getChartData(@runsperover)
			@dataRPO = Match.data_stringify(@arrRunsPerOver)
			@arrCumRunsPerOver = Match.getChartData(@cumulativerunsperover)
			@dataCRPO = Match.data_stringify(@arrCumRunsPerOver)

			respond_to do |format|
				format.html	
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'matches#match_status'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end  
=end


  def match_status
	begin
		if signed_in?
			@match = Match.find_by_id(params[:id])
			@matchid = @match.id
			#@runsperover = Scorecard.find_by_sql('select ballnum, convert(varchar, inning) as inning,SUM(runs) as runs from scorecards s where clientkey= '+current_user.id.to_s+' and matchkey= '+params[:id].to_s+' group by inning, ballnum ')
			
			rpo_sql = '
					select A."over", to_char(A.inning, '+"'9'"+') as inning , SUM(runs+wides+noballs+legbyes+byes) as runs
					from
					(
					select distinct s.inning, s1."over", s.clientkey, s.matchkey
					from scorecards s cross join scorecards s1 
					where  s.clientkey= '+current_user.id.to_s+' and s.matchkey= '+params[:id].to_s+'
					and  s1.clientkey= '+current_user.id.to_s+' and s1.matchkey= '+params[:id].to_s+'
					)A
					LEFT join scorecards s on A.inning = s.inning and A."over" = s."over" and A.clientkey = s.clientkey and A.matchkey = s.matchkey
					group by A.inning, A."over" 
					order by A.inning, A."over" 
					' 
			crpo_sql = '
					select A."over", to_char(A.inning, '+"'9'"+') as inning , SUM(runs+wides+noballs+legbyes+byes) as runs
					from
					(
					select distinct s.inning, s1."over", s.clientkey, s.matchkey
					from scorecards s cross join scorecards s1 
					where  s.clientkey= '+current_user.id.to_s+' and s.matchkey= '+params[:id].to_s+'
					and  s1.clientkey= '+current_user.id.to_s+' and s1.matchkey= '+params[:id].to_s+'
					)A
					LEFT join scorecards s on A.inning = s.inning and A."over" >= s."over" and A.clientkey = s.clientkey and A.matchkey = s.matchkey
					group by A.inning, A."over" 
					order by A.inning, A."over" 
					'
			@runsperover = Scorecard.find_by_sql(rpo_sql)
			@cumulativerunsperover =  Scorecard.find_by_sql(crpo_sql)
			@ti = Scorecard.where('clientkey=? and matchkey=?', current_user.id, @matchid).select('count(distinct inning) as c_inning')
			@totalinnings = @ti.nil? ? 0:@ti[0].c_inning
			@currentinning = Scorecard.where('clientkey=? and matchkey=?', current_user.id, @matchid).select('max(inning) as inning')
			@current = Scorecard.where('clientkey=? and matchkey=? and inning=?', current_user.id, @matchid, @currentinning[0].inning).select('SUM(runs+wides+noballs+legbyes+byes)/(max("over"*1.0)) as runrate, max("over") as currentover, sum(runs+wides+noballs+legbyes+byes) as score, max(ballnum) as currball')

			@five = @current[0].currentover.nil? ? 0:@current[0].currentover.to_i-4
			@curr = @current[0].currentover.nil? ? 0:@current[0].currentover
			@currRR = @current[0].runrate.nil? ? 0.0:@current[0].runrate
			@currScore = @current[0].score.nil? ? 0:@current[0].score
			@currBall = @current[0].currball.nil? ? 0:@current[0].currball
			@lastfiveRR = Scorecard.where('clientkey=? and matchkey=? and inning=?', current_user.id, @matchid, @currentinning[0].inning).select('SUM(runs+wides+noballs+legbyes+byes)/(count(distinct "over")*1.0) as runrate').where('"over" between '+(@five).to_s + ' and '+ (@curr).to_s)
			@lfRR = @lastfiveRR[0].runrate.nil? ? 0.0:@lastfiveRR[0].runrate
			@totalmatchballs = @match.matchovers * 6
			
			@currentoverindecimal = @current[0].currball.nil? ? 0:@current[0].currball.to_i/6 + @current[0].currball.to_i%6/6.0
			@ballsremaining = @current[0].currball.nil? ? @totalmatchballs:@totalmatchballs - @current[0].currball.to_i
			
			@oversremaining = @ballsremaining/6+@ballsremaining%6/6.0
			
			@projectedwithCurrRR = @current[0].runrate.nil? ? 0:(@current[0].runrate.to_f * @oversremaining).to_i + @current[0].score.to_i
			@projectedwithsix = (6 * @oversremaining).to_i + (@current[0].score.nil? ? 0:@current[0].score.to_i)
			@projectedwitheight = (8 * @oversremaining).to_i + (@current[0].score.nil? ? 0:@current[0].score.to_i)
			
			@arrRunsPerOver = Match.getChartData(@runsperover)
			@dataRPO = Match.data_stringify(@arrRunsPerOver)
			
			@arrCumRunsPerOver = Match.getChartData(@cumulativerunsperover)
			@dataCRPO = Match.data_stringify(@arrCumRunsPerOver)
			
			respond_to do |format|
				format.html	
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'matches#match_status'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end 
  
  def public
	@clients = Client.where("username != 'admin'")
	@matches = Match.find_by_sql('select * from (select dense_rank() over (partition by clientkey order by matchdate desc) _rank, * from matches)m where _rank<=10')
	
	respond_to do |format|
	  format.html # index.html.erb
	  format.json { render json: @matches }
	end
  end
  
  
  def scorecard
	paramsid = 3
	
	@match = Rails.cache.fetch('_match', :expires_in=>1.minute) do
				match = Match.find_by_id(paramsid)
			end

	#####common entry for all records
	@tournament = Rails.cache.fetch('_tournament', :expires_in=>1.minute) do
					tournament = Tournament.find_by_id(@match.tournamentkey)
				  end
	@venue = Rails.cache.fetch('_venue', :expires_in=>1.minute) do
				venue = Venue.find_all_by_id(@match.venuekey)
			end
	@format = Rails.cache.fetch('_format', :expires_in=>1.minute) do
					format = Format.find_by_id(@match.formatkey)
			 end
	@formatarr = []
	@formatarr << @format.name << @format.id
	
	@batting_side = 0
	@fielding_side = 0
	
	@teamone = Rails.cache.fetch('_teamone', :expires_in=>1.minute) do
					teamone = Team.find_by_teamid_and_wh_current(@match.teamidone, 1)
				end
	@teamtwo = Rails.cache.fetch('_teamtwo', :expires_in=>1.minute) do
					teamtwo = Team.find_by_teamid_and_wh_current(@match.teamidtwo,1)
			   end
	
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
	@runs = Rails.cache.fetch('_runs', :expires_in=>1.minute) do
				Scorecard.first.nil? ? 0:Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).select('sum(runs+wides+noballs+legbyes+byes) as scores')[0][:scores]
		    end
	@runs = @runs.nil? ? 0:@runs
	ballsdelivered = Rails.cache.fetch('_ballsdelivered', :expires_in=>1.minute) do
						Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).sum(:ballsdelivered)
					 end
	@overs = ballsdelivered/6 + ballsdelivered%6/10.0
	@wickets =  Rails.cache.fetch('_wickets', :expires_in=>1.minute) do
					Scorecard.where('matchkey=? and inning= ?', paramsid, @inning).sum(:wicket)
				end


	#batting side players
	@batsmankeys = Rails.cache.fetch('_batsmankeys', :expires_in=>1.minute) do
						batsmankeys = Team.where('teamid= ?', @batting_side ).collect {|b| b.playerid}
					end
				
	
	#beginning of calculation of current bowler or batsman or non striker or fielder in action
	#maxid is the last entry id of Scorecard
	@maxid = Rails.cache.fetch('_maxid', :expires_in=>1.minute) do
				maxid = Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.where('matchkey = ? and inning=?', paramsid, @inning).maximum(:id)
			 end
	@currentstrikerkey = Rails.cache.fetch('_cstriker', :expires_in=>1.minute) do
							Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).batsmankey
						end
	@currentnonstrikerkey = Rails.cache.fetch('_cnonstriker', :expires_in=>1.minute) do
								Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).currentnonstrikerkey
							end
	@strikerposition =  Rails.cache.fetch('_strikerpos', :expires_in=>1.minute) do
							Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).battingposition
						end
	@maxidwherenonstrikerisstriker = Rails.cache.fetch('_maxidwherenonstrikerisstriker', :expires_in=>1.minute) do
										Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.where('matchkey = ? and inning=? and currentstrikerkey = ?', paramsid, @inning, @currentnonstrikerkey).maximum(:id)
									end
	@nonstrikerposition = Rails.cache.fetch('_nonstrikerpos', :expires_in=>1.minute) do
							Scorecard.find_by_id(@maxidwherenonstrikerisstriker).nil? ? -2:Scorecard.find_by_id(@maxidwherenonstrikerisstriker).battingposition
						end
	@currentbowlerkey = Rails.cache.fetch('_cbowler', :expires_in=>1.minute) do
							Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).currentbowlerkey
						end
	@currentbowlingside = Rails.cache.fetch('_cbowlingside', :expires_in=>1.minute) do
							Scorecard.where('matchkey=? and inning = ? and currentbowlerkey=?', paramsid, @inning, @currentbowlerkey).first.nil? ? -2:Scorecard.find_by_id(@maxid).side
						end
	@lastrun = Rails.cache.fetch('_lastrun', :expires_in=>1.minute) do
				Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).runs
			end
	@lastbye = Rails.cache.fetch('_lastbye', :expires_in=>1.minute) do
				Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).byes
			end
	@lastlbye = Rails.cache.fetch('_lastlbye', :expires_in=>1.minute) do
					Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).legbyes
				end
	@lastnoball = Rails.cache.fetch('_lastnoball', :expires_in=>1.minute) do
					Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).noballs
				  end
	@lastwide = Rails.cache.fetch('_lastwide', :expires_in=>1.minute) do
					Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? -2:Scorecard.find_by_id(@maxid).wides
				end
	@battingposition = [1,2,3,4,5,6,7,8,9,10,11]
	@bowlingposition = [1,2,3,4,5,6,7,8,9,10,11]

	
	
	#last batting end and last bowling end
	@battingendkey = Rails.cache.fetch('_battingend', :expires_in=>1.minute) do
						Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? 0:Scorecard.find_by_id(@maxid).battingendkey
					end
	@bowlingendkey = Rails.cache.fetch('_bowlingend', :expires_in=>1.minute) do
						Scorecard.where('matchkey=? and inning = ?', paramsid, @inning).first.nil? ? 1:Scorecard.find_by_id(@maxid).bowlingendkey	
					end
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
		player = Rails.cache.fetch("_player_#{b}", :expires_in=>1.minute) do
					Player.find_by_clientkey_and_formatkey_and_playerid(params[:clientkey], @format.id, b)
				end
		#this is the last entry id of the bastman b
		playerlastentry_id = Rails.cache.fetch("_ple_id#{b}", :expires_in=>1.minute) do
								Scorecard.where('matchkey=? and inning=? and batsmankey=?', paramsid,@inning,b).maximum(:id)
							end
		playerlastentry_id_as_nonstriker = Rails.cache.fetch("_ple_id_as_ns#{b}", :expires_in=>1.minute) do
												Scorecard.where('matchkey=? and inning=? and currentnonstrikerkey=?', paramsid,@inning,b).maximum(:id)
											end
		
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
						from scorecards where matchkey = '+paramsid.to_s+' and clientkey = '+params[:clientkey].to_s+' and batsmankey = '+b.to_s+' and inning='+@inning.to_s+'
						)A
						'
		stats = Rails.cache.fetch("_stats#{paramsid}_#{params[:clientkey]}_#{b}_#{@inning}", :expires_in=>1.minute) do
					Scorecard.find_by_sql(stats_query)
				end
		

		
		hilite = ''
		if @currentstrikerkey == b
			hilite='hilite'
		elsif @currentnonstrikerkey == b
			hilite='hilite-nonstriker'
		end

			
		#get the last entry of the batsman b and get his information
		playerlastentry = Rails.cache.fetch('_ple1', :expires_in=>1.minute) do
							Scorecard.find_by_id(playerlastentry_id)
						end
		playerlastentry_as_NS = Rails.cache.fetch('_pls_as_ns1', :expires_in=>1.minute) do
									Scorecard.find_by_id(playerlastentry_id_as_nonstriker)
								end
		
		#dismissed batsman key (dbk)
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
		

		@batsmen << {:name=> player.fullname, :playerkey=>b, :playerid=>player.playerid, :bts=>player.battingstyle,
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
	@dismissals = Rails.cache.fetch('_dismissals', :expires_in=>1.minute) do
					Dismissal.all.collect{|d| [d.dismissaltype, d.id]}
				end
	@dismissals << ['', -2]
	
	@fielders = [['', -2]]
	@fieldingkeys = Rails.cache.fetch('_fieldingkeys', :expires_in=>1.minute) do
						Team.where('teamid= ?', @fielding_side ).collect {|b| b.playerid}
					end
	
	@fieldingside = []
	pos = 0
	counter = 0
	@fieldingkeys.each do |b|
		player = Rails.cache.fetch("_player#{b}", :expires_in=>1.minute) do
					Player.find_by_clientkey_and_formatkey_and_playerid(params[:clientkey], @format.id, b)
				end
		playerlastentry_id = Rails.cache.fetch("_ple_id#{b}", :expires_in=>1.minute) do
								Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', paramsid,@inning,b).maximum(:id)
							end
		playerlastentry = Rails.cache.fetch("_ple#{b}", :expires_in=>1.minute) do
							Scorecard.find_by_id(playerlastentry_id)
						end
		stats = Rails.cache.fetch("_stats#{paramsid}_#{@inning}_#{b}", :expires_in=>1.minute) do
					Scorecard.where('matchkey=? and inning=? and currentbowlerkey=?', paramsid,@inning,b).select('sum(runs+wides+noballs) as runs, sum(wides) as wides, sum(noballs) as noballs, sum(byes+legbyes) as others,sum(zeros) as zeros, sum(ones) as ones, sum(twos) as twos, sum(threes) as threes, sum(fours) as fours, sum(fives) as fives, sum(sixes) as sixes, sum(sevens) as sevens, sum(eights) , sum(maiden) as maidens, sum(ballsdelivered) as ballsdelivered, sum(wicket) as wickets, max(spell) as spell, case when sum(ballsdelivered) = 0 then 0 else sum(runs+wides+noballs)/(sum(ballsdelivered)/6.0) end as economy') 
				end
		wickets_stats = Rails.cache.fetch("_wicketstats#{paramsid}_#{@inning}_#{b}", :expires_in=>1.minute) do
							Scorecard.where('matchkey=? and inning=? and currentbowlerkey=? and outtypekey not in (4,5,6,7)', paramsid,@inning,b).select('sum(wicket) as wickets') 
						end
		
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
						 :wickets=> wickets_stats.nil? ? '':wickets_stats[0][:wickets].nil? ? '':wickets_stats[0][:wickets],
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
			@wktakingbowlers << [b[:name],b[:playerid]]
			counter= counter + 1
		end
	end
	@bowlers = @bowlers.sort_by{|b| b[:bowlingposition]}
  end
  
end