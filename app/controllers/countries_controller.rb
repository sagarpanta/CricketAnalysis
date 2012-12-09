class CountriesController < ApplicationController
  # GET /countries
  # GET /countries.json
  def index
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@countries = Country.all
			else
				@countries = Country.where('clientkey = ?', current_user.id)
			end
			@countryorder = 'order'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
			

			respond_to do |format|
			  format.html # index.html.erb
			  format.json { render json: @countries }
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'countries#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /countries/1
  # GET /countries/1.json
=begin  
  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @country }
    end
  end
=end

  # GET /countries/new
  # GET /countries/new.json
  def new
	begin
		if signed_in?
			@current_client = current_user.username
			@country = Country.new
			
			@countryorder = 'order'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
			@img = '/assets/create.png'
			@dImg = 'create'
			respond_to do |format|
			  format.html # new.html.erb
			  format.json { render json: @country }
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'countries#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /countries/1/edit
  def edit
	begin
		if signed_in?
			@current_client = current_user.username
			@country = Country.find(params[:id])
			
			@countryorder = 'order'
			@tournamentorder = 'links'
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
		 @caught_at = 'countries#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # POST /countries
  # POST /countries.json
  def create
	begin
		@country = Country.new(params[:country])

		respond_to do |format|
		  if @country.save
			format.html { redirect_to countries_path, notice: 'Country was successfully created.' }
			format.js {render 'success_create.js.erb'}
		  else
			format.html { render action: "new" }
			format.js {render 'fail_create.js.erb'}
			format.json { render json: @country.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'countries#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /countries/1
  # PUT /countries/1.json
  def update
    begin
		if signed_in?
			@current_client = current_user.username
			@country = Country.find(params[:id])
			respond_to do |format|
			  if @country.update_attributes(params[:country])
				format.html { redirect_to @country, notice: 'Country was successfully updated.' }
				format.js {render 'success_update.js.erb'}
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @country.errors, status: :unprocessable_entity }
			  end
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'countries#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
	begin
		if signed_in?
			@country = Country.find(params[:id])
			@country.destroy
			respond_to do |format|
			  format.html { redirect_to countries_url }
			  format.json { head :no_content }
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'countries#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
end
