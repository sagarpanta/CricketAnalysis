class CoachesController < ApplicationController
  # GET /coaches
  # GET /coaches.json
  def index
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@coaches = Coach.all	
			else
				@coaches = Coach.where('clientkey=?', current_user.id ).all
			end
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'order'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'coaches#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /coaches/1
  # GET /coaches/1.json
  def show
    @coach = Coach.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coach }
    end
  end

  # GET /coaches/new
  # GET /coaches/new.json
  def new
	begin
		if signed_in?
			@current_client = current_user.username
			@coach = Coach.new
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'order'
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
		 @caught_at = 'coaches#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /coaches/1/edit
  def edit
	begin
		if signed_in?
			@current_client = current_user.username
			@coach = Coach.find(params[:id])
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'order'
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
		 @caught_at = 'coaches#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # POST /coaches
  # POST /coaches.json
  def create
	begin
		@coach = Coach.new(params[:coach])

		respond_to do |format|
		  if @coach.save
			format.html { redirect_to @coach, notice: 'Coach was successfully created.' }
			format.js {render 'success_create.js.erb'}
			format.json { render json: @coach, status: :created, location: @coach }
		  else
			format.html { render action: "new" }
			format.js {render 'fail_create.js.erb'}
			format.json { render json: @coach.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'coaches#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /coaches/1
  # PUT /coaches/1.json
  def update
	begin
		if signed_in?
			@current_client = current_user.username
			@coach = Coach.find(params[:id])

			respond_to do |format|
			  if @coach.update_attributes(params[:coach])
				format.html { redirect_to @coach, notice: 'Coach was successfully updated.' }
				format.js {render 'success_update.js.erb'}
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @coach.errors, status: :unprocessable_entity }
			  end
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'coaches#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /coaches/1
  # DELETE /coaches/1.json
  def destroy
    begin
		if signed_in?
			@coach = Coach.find(params[:id])
			@coach.destroy

			respond_to do |format|
			  format.html { redirect_to coaches_url }
			  format.json { head :no_content }
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'coaches#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

end
