class MatchesController < ApplicationController
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
    begin
		if signed_in?
			@current_client = current_user.username
			@match = Match.new

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
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'matches#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
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

		if signed_in?
			@match = Match.find_by_id(params[:id])

			@matchid = @match.id
			#@runsperover = Scorecard.find_by_sql('select ballnum, convert(varchar, inning) as inning,SUM(runs) as runs from scorecards s where clientkey= '+current_user.id.to_s+' and matchkey= '+params[:id].to_s+' group by inning, ballnum ')
			@runsperover = Scorecard.find_by_sql('select "over", to_char(inning, '+"'9'"+') as inning,SUM(runs+wides+noballs+legbyes+byes) as runs from scorecards s where clientkey= '+current_user.id.to_s+' and matchkey= '+params[:id].to_s+' group by inning, "over" ')
			
			@cumulativerunsperover =  Scorecard.find_by_sql('select distinct "over", to_char(inning, '+"'9'"+') as inning,(select SUM(runs+wides+noballs+legbyes+byes) from scorecards s1 where clientkey = s.clientkey and matchkey = s.matchkey and inning=s.inning and "over"<= s."over") as runs from scorecards s where clientkey= '+current_user.id.to_s+' and matchkey= '+params[:id].to_s)
			
			@currentinning = Scorecard.where('clientkey=? and matchkey=?', current_user.id, @matchid).select('max(inning) as inning')
			@current = Scorecard.where('clientkey=? and matchkey=? and inning=?', current_user.id, @matchid, @currentinning[0].inning).select('SUM(runs+wides+noballs+legbyes+byes)/(max("over"*1.0)) as runrate, max("over") as currentover, sum(runs) as score, max(ballnum) as currball')
			
			@five = @current[0].currentover.nil? ? 0:@current[0].currentover-4
			@curr = @current[0].currentover.nil? ? 0:@current[0].currentover
			@lastfiveRR = Scorecard.where('clientkey=? and matchkey=? and inning=?', current_user.id, @matchid, @currentinning[0].inning).select('SUM(runs+wides+noballs+legbyes+byes)/(count(distinct "over")*1.0) as runrate').where('"over" between '+(@five).to_s + ' and '+ (@curr).to_s)
			@totalmatchballs = @match.matchovers * 6
			
			@currentoverindecimal = @current[0].currball.nil? ? 0:@current[0].currball/6 + @current[0].currball%6/6.0
			@ballsremaining = @current[0].currball.nil? ? @totalmatchballs:@totalmatchballs - @current[0].currball
			
			@oversremaining = @ballsremaining/6+@ballsremaining%6/6.0
			
			@projectedwithCurrRR = @current[0].runrate.nil? ? 0:(@current[0].runrate * @oversremaining).to_i + @current[0].score
			
			@projectedwithsix = (6 * @oversremaining).to_i + (@current[0].score.nil? ? 0:@current[0].score)
			@projectedwitheight = (8 * @oversremaining).to_i + (@current[0].score.nil? ? 0:@current[0].score)
			
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

  end	
  
 
 
end