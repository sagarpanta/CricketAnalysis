class MatchesController < ApplicationController
  caches_action :firstinning, :cache_path => Proc.new { |c| c.params }
  caches_action :secondinning, :cache_path => Proc.new { |c| c.params }
  caches_action :public
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
		@match = Match.new(params[:match])
		#csv_text = File.read(Rails.root.join('bin', 'scorecards.csv').to_s)
		#	csv = CSV.parse(csv_text, :headers => true)
		#	csv.each do |row|
		#		row = row.to_hash
		#	binding.pry
		#end

		respond_to do |format|
		  if @match.save
			expire_action(:controller => 'matches', :action => 'public') 
			@teamone = Team.find_by_teamid_and_wh_current(@match.teamidone, 1)
			@teamtwo = Team.find_by_teamid_and_wh_current(@match.teamidtwo,1)
			@inning = 0
			if @match.tosswon == @match.teamidone
				if @match.electedto == 'Bat'
					@inning = 1
				else
					@inning = 2
				end
			else
				if @match.electedto == 'Bat'
					@inning = 2
				else
					@inning = 1
				end
			end
			
			@teamone_players = Team.where('teamid= ?', @teamone.teamid ).collect {|b|  [b.playerid,b.teamname]}
			@teamtwo_players = Team.where('teamid= ?', @teamtwo.teamid ).collect {|b| [b.playerid,b.teamname]}
			
			@counter = 1
			@format = Format.find_by_id(@match.formatkey).name
			@tournament = Tournament.find_by_id(@match.tournamentkey).name
			@teamone_players.each do |b|
				break if @counter >11
				@player = Player.find_by_formatkey_and_playerid(@match.formatkey, b[0])
				@playername = @player.fname[0]+' '+@player.lname
				Battingscorecard.create!(:clientkey=>@match.clientkey, :teamname=>b[1], :batsman=>@playername, :batsmankey=>b[0], :position=>11, :fielder=>'', :fielderkey=>-2,:outtype=>'', :outtypekey=>-2, :bowler=>'', :bowlerkey=>-2, :played=>0, :matchkey=>@match.id, :tournamentkey=>@match.tournamentkey, :tournament=>@tournament, :inning=>@inning, :formatkey=>@match.formatkey, :format=>@format)
				Bowlingscorecard.create!(:clientkey=>@match.clientkey,:teamname=>b[1], :bowler=>@playername, :bowlerkey=>b[0], :position=>11, :bowled=>0, :matchkey=>@match.id, :tournamentkey=>@match.tournamentkey, :tournament=>@tournament, :inning=>(@inning==1? 2:1), :formatkey=>@match.formatkey, :format=>@format,:totalovers=>0.0, :wicketsgone=>0)
				@counter = @counter+1
			end
			
			@inning = @inning==1? 2:1
			@counter = 1
			@teamtwo_players.each do |b|	
				break if @counter >11
				@player = Player.find_by_formatkey_and_playerid(@match.formatkey, b[0])
				@playername = @player.fname[0]+' '+@player.lname
				
				Battingscorecard.create!(:clientkey=>@match.clientkey,:teamname=>b[1], :batsman=>@playername, :batsmankey=>b[0], :position=>11, :fielder=>'', :fielderkey=>-2,:outtype=>'', :outtypekey=>-2, :bowler=>'', :bowlerkey=>-2, :played=>0, :matchkey=>@match.id, :tournamentkey=>@match.tournamentkey, :tournament=>@tournament, :inning=>@inning, :formatkey=>@match.formatkey, :format=>@format)
				Bowlingscorecard.create!(:clientkey=>@match.clientkey,:teamname=>b[1], :bowler=>@playername, :bowlerkey=>b[0], :position=>11, :bowled=>0, :matchkey=>@match.id, :tournamentkey=>@match.tournamentkey, :tournament=>@tournament, :inning=>(@inning==2? 1:2), :formatkey=>@match.formatkey, :format=>@format, :totalovers=>0.0, :wicketsgone=>0)
				@counter = @counter+1
			end			

			format.html { redirect_to @match, notice: 'Match was successfully created.' }
			format.js   {render 'success_create.js.erb'}
			format.json { render json: @match, status: :created, location: @match }
		  else
			format.html { render action: "new" }
			format.js   {render 'fail_create.js.erb'}
			format.json { render json: @match.errors, status: :unprocessable_entity }
		  end
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
				expire_action(:controller => 'matches', :action => 'firstinning' , :id=>@match.id, :clientkey=> current_user.id)
				expire_action(:controller => 'matches', :action => 'secondinning' , :id=>@match.id, :clientkey=> current_user.id)
				expire_action(:controller => 'matches', :action => 'public') 
				
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
	
	@clients = Rails.cache.fetch("clients", :expires_in=>1.day) do
		(Client.where("username != 'admin'").select('id, country') << {'id'=> -2 , 'country'=>'Select One'}).sort_by{|k|k['id']}
	end
	

	
	@matches = Rails.cache.fetch("matches", :expires_in=>5.minutes) do
		Match.find_by_sql('select * from (select dense_rank() over (partition by clientkey order by matchdate desc) _rank, * from matches)m where _rank<=10')
	end
	
	respond_to do |format|
	  format.html # index.html.erb
	  format.json { render json: @matches }
	end
  end
  
  
  def firstinning
	maxentry = Scorecard.find(:all, :order=>"id", :conditions=>["clientkey=? and inning=?",params[:clientkey],1]).last
	maxid = maxentry.nil? ? 0:maxentry.id
	@clientkey = params[:clientkey]

	@match = Rails.cache.fetch("_match_#{params[:id]}", :expires_in=>24.hours) do
				match = Match.find_by_id(params[:id].to_s)
			end	
	@tournament = Rails.cache.fetch("tournament_#{params[:id]}", :expires_in=>24.hours) do
		Tournament.find_by_id(@match.tournamentkey)
	end
	
	@venue = Rails.cache.fetch("venue_#{params[:id]}", :expires_in=>24.hours) do
		Venue.find_by_id(@match.venuekey)
	end
	
	@format = Rails.cache.fetch("format_#{params[:id]}", :expires_in=>24.hours) do
		Format.find_by_id(@match.formatkey)
	end
	
	@batsmen = Rails.cache.fetch("batsmen_#{params[:id]}_#{maxid}_inning1" , :expires_in=>45.seconds) do
		Battingscorecard.find(:all,:order=>:position,:conditions=>{:matchkey=>params[:id], :inning=>1})
	end
	
	@bowlers = Rails.cache.fetch("bowlers_#{params[:id]}_#{maxid}_inning1" , :expires_in=>45.seconds) do
		Bowlingscorecard.find(:all,:order=>:position,:conditions=>{:matchkey=>params[:id], :inning=>1})
	end
	
	@runs = Rails.cache.fetch("runs_#{params[:id]}_#{maxid}_inning1" , :expires_in=>45.seconds) do
		Bowlingscorecard.where('matchkey=? and inning=?', params[:id], 1).sum('coalesce(runs,0)+coalesce(byes,0)+coalesce(legbyes,0)')
	end
	
	@wickets = Rails.cache.fetch("wickets_#{params[:id]}_#{maxid}_inning1" , :expires_in=>45.seconds) do
		Battingscorecard.where('matchkey=? and inning=?', params[:id], 1).sum('case when outtypekey=-2 then 0 else 1 end')
	end
	
	@overs = Rails.cache.fetch("overs_#{params[:id]}_#{maxid}_inning1" , :expires_in=>45.seconds) do
		maxentry.nil? ? 0.0:maxentry.ballnum/6+maxentry.ballnum%6/10.0
	end
		
	@teams = Rails.cache.fetch("teams_#{params[:id]}" , :expires_in=>24.hours) do
		Battingscorecard.where('matchkey=?', params[:id]).select('distinct teamname')
	end
	
	@last18balls = Rails.cache.fetch("last18balls_#{params[:id]}_#{maxid}_inning1" , :expires_in=>45.seconds) do
		Scorecard.where('matchkey=? and inning=?',params[:id], 1).order("id desc").limit(18).select('runs+wides+byes+legbyes+noballs as runs, ballnum')
	end
	
	
	@counts = Rails.cache.fetch("last18ballscount_#{params[:id]}_#{maxid}_inning1" , :expires_in=>45.seconds) do
		@last18balls.count
	end
	@inning = 1
  end
  
  def secondinning

	maxentry = Scorecard.find(:all, :order=>"id", :conditions=>["clientkey=? and inning=?",params[:clientkey],2]).last
	maxid = maxentry.nil? ? 0:maxentry.id
	@maxdate = maxentry.nil? ? '1/1/2999':maxentry.updated_at
	@clientkey = params[:clientkey]
	@match = Rails.cache.fetch("_match_#{params[:id]}", :expires_in=>24.hours) do
				match = Match.find_by_id(params[:id])
			end	
	@tournament = Rails.cache.fetch("tournament_#{params[:id]}", :expires_in=>24.hours) do
		Tournament.find_by_id(@match.tournamentkey)
	end
	@venue = Rails.cache.fetch("venue_#{params[:id]}", :expires_in=>24.hours) do
		Venue.find_by_id(@match.venuekey)
	end
	@format = Rails.cache.fetch("format_#{params[:id]}", :expires_in=>24.hours) do
		Format.find_by_id(@match.formatkey)
	end
	
	@batsmen = Rails.cache.fetch("batsmen_#{params[:id]}_#{maxid}_inning2" , :expires_in=>45.seconds) do
		Battingscorecard.find(:all,:order=>:position,:conditions=>{:matchkey=>params[:id], :inning=>2})
	end
	
	@bowlers = Rails.cache.fetch("bowlers_#{params[:id]}_#{maxid}_inning2", :expires_in=>45.seconds) do
		Bowlingscorecard.find(:all,:order=>:position,:conditions=>{:matchkey=>params[:id], :inning=>2})
	end
	
	@runs = Rails.cache.fetch("runs_#{params[:id]}_#{maxid}_inning2", :expires_in=>45.seconds) do
		Bowlingscorecard.where('matchkey=? and inning=?', params[:id], 2).sum('coalesce(runs,0)+coalesce(byes,0)+coalesce(legbyes,0)')
	end
	

	@wickets = Rails.cache.fetch("wickets_#{params[:id]}_#{maxid}_inning2", :expires_in=>45.seconds) do
		Battingscorecard.where('matchkey=? and inning=?', params[:id], 2).sum('case when outtypekey=-2 then 0 else 1 end')
	end
	
	@overs = Rails.cache.fetch("overs_#{params[:id]}_#{maxid}_inning2", :expires_in=>45.seconds) do
		maxentry.nil? ? 0.0:maxentry.ballnum/6+maxentry.ballnum%6/10.0
	end
	
	@teams = Rails.cache.fetch("teams_#{params[:id]}", :expires_in=>24.hours) do
		Battingscorecard.where('matchkey=?', params[:id]).select('distinct teamname')
	end
	
	@last18balls = Rails.cache.fetch("last18balls_#{params[:id]}_#{maxid}_inning2", :expires_in=>45.seconds) do
		Scorecard.where('matchkey=? and inning=?',params[:id], 2).order("id desc").limit(18).select('runs+wides+byes+legbyes+noballs as runs, ballnum')
	end
	
	@counts = Rails.cache.fetch("counts_#{params[:id]}_#{maxid}_inning2", :expires_in=>45.seconds) do
		Scorecard.where('matchkey=? and inning=?',params[:id], 1).order("id desc").limit(18).count
	end
	@target = Rails.cache.fetch("target_#{params[:id]}_inning2", :expires_in=>5.minutes) do
		Bowlingscorecard.where('matchkey=? and inning=?',params[:id], 1).sum('coalesce(runs,0)+coalesce(byes,0)+coalesce(legbyes,0)')
	end
	
	@inning = 2
  end
  
end