class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.json
  def index
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@teams = Team.select('distinct teamname, countrykey, teamid')
			else
				@teams = Team.where('clientkey=?', current_user.id ).select('distinct teamname, countrykey, teamid')
			end
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'order'
			@venueorder = 'links'
			@matchorder = 'links'
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'teams#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /teams/1
  # GET /teams/1.json
=begin
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end
=end

  # GET /teams/new
  # GET /teams/new.json
  def new
    begin
		if signed_in?
			@current_client = current_user.username
			@team = Team.new

		
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'order'
			@venueorder = 'links'
			@matchorder = 'links'
			@img = '/assets/create.png'
			@dImg = 'create'
		
			@players = Player.where('wh_current = ? and clientkey=?', 1, current_user.id)
			@countries = Country.where('clientkey=?', current_user.id).collect {|t| [ t.country, t.id]}
			@countries << ['', -2]
			@countries = @countries.sort_by{|k|k[1]}
			
			@formats = Format.all.collect {|t| [ t.name,t.id]}
			
			@teamtypes = TeamType.all.collect{|t| [t.teamtype, t.id]}
			
			respond_to do |format|
			  format.html # new.html.erb
			  format.json { render json: @team }
			end
		else 
			redirect_to signin_path
		end	
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'teams#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /teams/1/edit
  def edit
	begin
		if signed_in?
			@current_client = current_user.username
			@team = Team.find(params[:id])		
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'teams#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # POST /teams
  # POST /teams.json
  def create
	begin
		@team = Team.new(params[:team])
		respond_to do |format|
		  if @team.save
			format.json { render json: @team, status: :created, location: @team }
		  else
			format.html { render action: "new" }
			format.json { render json: @team.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'teams#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
	begin
		if signed_in?
			@current_client = current_user.username
			@team = Team.find(params[:id])
			

			respond_to do |format|
			  if @team.update_attributes(params[:team])
				format.html { redirect_to @team, notice: 'Team was successfully updated.' }
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @team.errors, status: :unprocessable_entity }
			  end
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'teams#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
	begin
		if signed_in?
			@team = Team.find(params[:id])
			@team.destroy

			respond_to do |format|
			  format.json { head :no_content }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'teams#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  def team
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username =="admin"
				 @teams = Team.find_all_by_teamid(params[:teamid])
				 @lineup = [];
				 
				 @teams.each do |t|
					@player_name = Player.where('wh_current = ?', 1).find_by_id(t.playerkey).fullname
					@player_type = Player.where('wh_current = ?', 1).find_by_id(t.playerkey).playertype
					@country = Country.find_by_id(t.countrykey).country
					t['player_name'] = @player_name
					t['player_type'] = @player_type
					t['country'] = @country
					@lineup<<t
				 end
				 
			else
				 @teams = Team.find_all_by_teamid_and_clientkey(params[:teamid], current_user.id)
				 @lineup = [];
				 @current_userkey = current_user.id
				 
				 @teams.each do |t|
					@player_name = Player.where('wh_current = ? and clientkey=?', 1,@current_userkey).find_by_id(t.playerkey).fullname
					@player_type = Player.where('wh_current = ? and clientkey=?', 1,@current_userkey).find_by_id(t.playerkey).playertype
					@country = Country.find_by_id_and_clientkey(t.countrykey, @current_userkey).country
					t['player_name'] = @player_name
					t['player_type'] = @player_type
					t['country'] = @country
					@lineup<<t
				 end	
			
			end		

			respond_to do |format|
				format.json { render json: @teams }
				format.html
			end
		else
			redirect_to signin_path
		end			  
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'teams#team'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  
  def modify_team
	begin
		if signed_in?
			@current_client = current_user.username
			@current_userkey = current_user.id
			if current_user.username == 'admin'
				@team = Team.find_by_teamid(params[:teamid]) 
				@countries = Country.where('clientkey=?', current_user.id).collect {|t| [ t.country, t.id]}
				@country_selected = @team.countrykey
				@teamtypes = TeamType.all.collect{|t| [t.teamtype, t.id]}
				@teamname = @team.teamname
				@teamtype = @team.teamtypekey
				@formats = Format.all.collect {|t| [ t.name,t.id]}
				@format_selected = @team.formatkey
				@coaches = Coach.all.collect {|t| [ t.name, t.id]}
				@coach_selected = @team.coachkey
				@managers = Manager.all.collect {|t| [ t.name,t.id]}
				@manager_selected = @team.managerkey
				@players = Player.where('wh_current = ?', 1)
				@selected_players = Team.find_all_by_teamid(params[:teamid])	
			else
				@team = Team.find_by_teamid_and_clientkey(params[:teamid],@current_userkey) 
				@countries = Country.where('clientkey=?', @current_userkey).collect {|t| [ t.country, t.id]}
				@country_selected = @team.countrykey
				@teamtypes = TeamType.all.collect{|t| [t.teamtype, t.id]}
				@teamname = @team.teamname
				@teamtype = @team.teamtypekey
				@formats = Format.all.collect {|t| [ t.name,t.id]}
				@format_selected = @team.formatkey
				@coaches = Coach.where('clientkey=?', @current_userkey).collect {|t| [ t.name, t.id]}
				@coach_selected = @team.coachkey
				@managers = Manager.where('clientkey=?', @current_userkey).collect {|t| [ t.name,t.id]}
				@manager_selected = @team.managerkey
				@players = Player.where('wh_current = ? and clientkey=?', 1, @current_userkey)
				@selected_players = Team.find_all_by_teamid_and_clientkey(params[:teamid],@current_userkey )		
			
			end
			
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'order'
			@venueorder = 'links'
			@matchorder = 'links'
			@img = '/assets/update.png'
			@dImg = 'update'


			respond_to do |format|
			  format.html # index.html.erb
			  format.json { render json: @selected_players }
			end
		else 
			redirect_to signin_path
		end 
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'teams#modify_team'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
	
	
  end
  
end
