class PlayersController < ApplicationController
  # GET /players
  # GET /players.json
  def index
	begin
		if signed_in?
			@current_client = current_user.username
			#@players = Player.where('wh_current = ?', 1)
			session[:clientkey] = !session[:clientkey]
			session[:age] = !session[:age]
			session[:batstyle] = !session[:batstyle]
			session[:bowlstyle] = !session[:bowlstyle]
			session[:bowltype] = !session[:bowltype]
			session[:dob] = !session[:dob]
			session[:fname] = !session[:fname]
			session[:lname] = !session[:lname]
			session[:fullname] = !session[:fullname]
			session[:format] = !session[:format]
			session[:playertype] = !session[:playertype]
			session[:playerid] = !session[:playerid]
			session[:country] = !session[:country]

			sort = params[:sort] || session[:sort]
			case sort
			when 'client'
			  @client_header = 'lite'
			  ordering = session[:clientkey]? {:order => 'clientkey desc'}: {:order => 'clientkey'}
			when 'age'
			  @age_header = 'lite'
			  ordering = session[:age]? {:order => 'age desc'}: {:order => 'age'}
			when 'fullname'
			  @fullname_header =  'lite'
			  ordering = session[:fullname]? {:order => 'fullname desc'}: {:order => 'fullname'} 
			when 'batstyle'
			  @batstyle_header = 'lite'
			  ordering = session[:batstyle]? {:order => 'battingstyle desc'}: {:order => 'battingstyle'}
			when 'bowlstyle'
			  @bowlstyle_header = 'lite'
			  ordering = session[:bowlstyle]? {:order => 'bowlingstyle desc'}: {:order => 'bowlingstyle'}
			when 'bowltype'
			  @bowltype_header = 'lite'
			  ordering = session[:bowltype]? {:order => 'bowlingtype desc'}: {:order => 'bowlingtype'}
			when 'dob'
			  @dob_header = 'lite'
			  ordering = session[:dob]? {:order => 'dob desc'}: {:order => 'dob'}	
			when 'fname'
			  @fname_header = 'lite'
			  ordering = session[:fname]? {:order => 'fname desc'}: {:order => 'fname'}		
			when 'lname'
			  @lname_header = 'lite'
			  ordering = session[:lname]? {:order => 'lname desc'}: {:order => 'lname'}	  
			when 'format'
			  @format_header = 'lite'
			  ordering = session[:format]? {:order => 'format desc'}: {:order => 'format'}	
			when 'playertype'
			  @playertype_header = 'lite'
			  ordering = session[:playertype]? {:order => 'playertype desc'}: {:order => 'playertype'}
			when 'playerid'
			  @playerid_header = 'lite'
			  ordering = session[:playerid]? {:order => 'playerid desc'}: {:order => 'playerid'}
			when 'country'
			  @country_header = 'lite'
			  ordering = session[:country]? {:order => 'countrykey desc'}: {:order => 'countrykey'}	  
			end
			if params[:sort] != session[:sort]
			  session[:sort] = sort
			  redirect_to :sort => sort and return
			end
			if current_user.username == 'admin'
				@players = Player.all(ordering)
			else
				@players = Player.where('wh_current=? and clientkey=?',1, current_user.id).all(ordering)
			end
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'order'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
		else
			redirect_to signin_path
		end
		#respond_to do |format|
		#  format.html # index.html.erb
		#  format.json { render json: @players }
		#end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end

  end
  

  # GET /players/1
  # GET /players/1.json
=begin  
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player }
    end
  end
=end

  # GET /players/new
  # GET /players/new.json
  def new
	begin
		if signed_in?
			@current_client = current_user.username
			@player = Player.new
			@countries = Country.where('clientkey=?', current_user.id).collect {|t| [ t.country, t.id]}
			@formats = Format.all.collect {|t| [ t.name,t.id]}
			@maxidtext = 'Enter '+Player.maxplayerid.to_s+ ' or more'
			
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'order'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
			
			@img = '/assets/create.png'
			@dImg = 'create'
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @player }
    #end
  end

  # GET /players/1/edit
  def edit
	begin
		if signed_in?
			@current_client = current_user.username
			@player = Player.find(params[:id])
			@countries = Country.where('clientkey=?', current_user.id).collect {|t| [ t.country, t.id]}
			@formats = Format.all.collect {|t| [ t.name,t.id]}
			@disabled = 'disabled'
			@maxidtext = ''

			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'order'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
			
			@img = '/assets/update.png'
			@dImg = 'update'
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # POST /players
  # POST /players.json
  def create
	begin
		referrer_path = request.env['HTTP_REFERER'].nil? ? '': request.env['HTTP_REFERER']
		origin_path = request.env['HTTP_ORIGIN'].nil? ? '': request.env['HTTP_ORIGIN']
		path = referrer_path[origin_path.length..referrer_path.length]  
		#when  a temporary user creates a new player then sign out.
		if path == '/allow_temp_connection'
			sign_out
		end
		@player = Player.new(params[:player])
		@player.save
		respond_to do |format|
		  if @player.save
			format.html { redirect_to players_path }
			format.js {render 'success_create.js.erb'}
			format.json { render json: @player, status: :created, location: @player }
		  else
			format.html { render action: "new" }
			format.js {render 'fail_create.js.erb'}
			format.json { render json: @player.errors, status: :unprocessable_entity }
		  end
		end
	
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end	
  end

  # PUT /players/1
  # PUT /players/1.json
  def update
	begin
		if signed_in?
			@current_client = current_user.username
			@player = Player.find(params[:id])
			
=begin			if @player.battingstyle != params[:player][:battingstyle] or @player.bowlingstyle != params[:player][:bowlingstyle] or @player.bowlingtype != params[:player][:bowlingtype] or @player.playertype != params[:player][:playertype]
				@player.update_attribute(:wh_current, 0)
				Player.create!(params[:player])
				respond_to do |format|
					format.html { redirect_to players_path}
					format.js {render 'success_update.js.erb'}
					format.json { render json: @player, status: :created, location: @player }
				end
=end
			respond_to do |format|
			  if @player.update_attributes(params[:player])
				format.html { redirect_to @player, notice: 'Player was successfully updated.' }
				format.js {render 'success_update.js.erb'}
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @player.errors, status: :unprocessable_entity }
			  end
			end

		else
			redirect_to signin_path	
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
	begin
		if signed_in?
			@player = Player.find(params[:id])
			@player.destroy
			respond_to do |format|
			  format.html { redirect_to players_path }
			  format.json { head :no_content }
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  def all_players
    
	if signed_in?
		@current_client = current_user.username
		@players = Player.all
		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render json: @players }
		end
	else
		redirect_to signin_path
	end	
  end
  
  def temp_login
	begin
		@c = Client.where('name <> ? or username <> ? or id <> ?', 'Administrator' , 'admin', 1).select('id, name')
		
		@clients = {''=> -2}
		@c.each do |c|
			@clients[c.name] = c.id
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#temp_login'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end

  end
  
  def allow_temp_connection
	begin
		@client = Client.find_by_id(params[:client][:clientkey])
		if @client and params[:password] == @client.temppass
			sign_in @client
			@player = Player.new
			@countries = Country.where('clientkey=?', current_user.id).collect {|t| [ t.country, t.id]}
			@formats = Format.all.collect {|t| [ t.name,t.id]}
			@maxidtext = 'Enter '+Player.maxplayerid.to_s+ ' or more'	
			@countryorder = ''
			@tournamentorder = ''
			@playerorder = 'order'
			@managerorder = ''
			@coachorder = ''
			@teamorder = ''
			@venueorder = ''
			@matchorder = ''	
		else
			redirect_to '/temp_login'
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'players#allow_temp_connection'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end	
  end	
  
end