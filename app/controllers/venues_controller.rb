class VenuesController < ApplicationController
  # GET /venues
  # GET /venues.json
  def index   
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@venues = Venue.all
			else
				@venues = Venue.where('clientkey=?', current_user.id ).all
			end
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'order'
			@matchorder = 'links'
			respond_to do |format|
			  format.html # index.html.erb
			  format.json { render json: @venues }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'venues#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @venue }
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new
	begin
		if signed_in?
			@current_client = current_user.username
			@venue = Venue.new
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'order'
			@matchorder = 'links'
			@img = '/assets/create.png'
			@dImg = 'create'

			respond_to do |format|
			  format.html # new.html.erb
			  format.json { render json: @venue }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'venues#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /venues/1/edit
  def edit
    begin
		if signed_in?
			@current_client = current_user.username
			@venue = Venue.find(params[:id])
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'order'
			@matchorder = 'links'
			@img = '/assets/update.png'
			@dImg = 'update'
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'venues#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # POST /venues
  # POST /venues.json
  def create
	begin
		@venue = Venue.new(params[:venue])

		respond_to do |format|
		  if @venue.save
			format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
			format.js   {render 'success_create.js.erb'}
			format.json { render json: @venue, status: :created, location: @venue }
		  else
			format.html { render action: "new" }
			format.js   {render 'fail_create.js.erb'}
			format.json { render json: @venue.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'venues#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
	begin
		if signed_in?
			@current_client = current_user.username
			@venue = Venue.find(params[:id])

			respond_to do |format|
			  if @venue.update_attributes(params[:venue])
				format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
				format.js   {render 'success_update.js.erb'}
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @venue.errors, status: :unprocessable_entity }
			  end
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'venues#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
	begin
		if signed_in?
			@venue = Venue.find(params[:id])
			@venue.destroy

			respond_to do |format|
			  format.html { redirect_to venues_url }
			  format.json { head :no_content }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message 
		 @client = current_user
		 @caught_at = 'venues#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
end
