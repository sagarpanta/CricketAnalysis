class TournamentsController < ApplicationController
  # GET /tournaments
  # GET /tournaments.json
  def index
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@tournaments = Tournament.all
			else
				@tournaments = Tournament.where('clientkey=?', current_user.id ).all
			end
			@countryorder = 'links'
			@tournamentorder = 'order'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
			respond_to do |format|
			  format.html # index.html.erb
			  format.json { render json: @tournaments }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'tournaments#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
=begin
  def show
	begin
		@tournament = Tournament.find(params[:id])

		respond_to do |format|
		  format.html # show.html.erb
		  format.json { render json: @tournament }
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'tournaments#show'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
=end


  # GET /tournaments/new
  # GET /tournaments/new.json
  def new
	begin
		if signed_in?
			@current_client = current_user.username
			@tournament = Tournament.new

			@countryorder = 'links'
			@tournamentorder = 'order'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
			@img = '/assets/create.png'
			@dImg = 'create'
			@formats = Format.all.collect {|t| [ t.name,t.id]}

			respond_to do |format|
			  format.html # new.html.erb
			  format.json { render json: @tournament }
			end
		else 
			redirect_to signin_path
		end	
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'tournaments#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /tournaments/1/edit
  def edit
	begin
		if signed_in?
			@current_client = current_user.username
			@tournament = Tournament.find(params[:id])
			@formats = Format.all.collect {|t| [ t.name,t.id]}
			
			@countryorder = 'links'
			@tournamentorder = 'order'
			@playerorder = 'links'
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
		 @caught_at = 'tournaments#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
	   
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
	begin
		@tournament = Tournament.new(params[:tournament])

		respond_to do |format|
		  if @tournament.save
			format.html { redirect_to tournaments_path }
			format.js {render 'success_create.js.erb'}
			format.json { render json: @tournament, status: :created, location: @tournament }
		  else
			format.html { render action: "new" }
			format.js {render 'fail_create.js.erb'}
			format.json { render json: @tournament.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'tournaments#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.json
  def update
	begin
		if signed_in?
			@current_client = current_user.username
			@tournament = Tournament.find(params[:id])

			respond_to do |format|
			  if @tournament.update_attributes(params[:tournament])
				format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
				format.js {render 'success_update.js.erb'}
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @tournament.errors, status: :unprocessable_entity }
			  end
			end
		else 
			redirect_to signin_path
		end	
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'tournaments#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
	begin
		if signed_in?
			@tournament = Tournament.find(params[:id])
			@tournament.destroy

			respond_to do |format|
			  format.html { redirect_to tournaments_url }
			  format.json { head :no_content }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'tournaments#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
end
