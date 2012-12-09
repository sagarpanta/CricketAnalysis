class ManagersController < ApplicationController
  # GET /managers
  # GET /managers.json
  def index
    begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@managers = Manager.all
			else
				@managers = Manager.where('clientkey=?', current_user.id )
			end
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'order'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
			respond_to do |format|
			  format.html # index.html.erb
			  format.json { render json: @managers }
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'managers#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /managers/1
  # GET /managers/1.json
=begin  
  def show
    @manager = Manager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager }
    end
  end
=end

  # GET /managers/new
  # GET /managers/new.json
  def new
	begin
		if signed_in?
			@current_client = current_user.username
			@manager = Manager.new

			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'order'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'	
			@img = '/assets/create.png'
			@dImg = 'create'
			respond_to do |format|
			  format.html # new.html.erb
			  format.json { render json: @manager }
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'managers#new'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # GET /managers/1/edit
  def edit
    begin
		if signed_in?
			@current_client = current_user.username
			@manager = Manager.find(params[:id])

			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'order'
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
		 @caught_at = 'managers#edit'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end		
  
  end

  # POST /managers
  # POST /managers.json
  def create
	begin
		@manager = Manager.new(params[:manager])

		respond_to do |format|
		  if @manager.save
			format.html { redirect_to @manager, notice: 'Manager was successfully created.' }
			format.js {render 'success_create.js.erb'}
			format.json { render json: @manager, status: :created, location: @manager }
		  else
			format.html { render action: "new" }
			format.js {render 'fail_create.js.erb'}
			format.json { render json: @manager.errors, status: :unprocessable_entity }
		  end
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'managers#create'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # PUT /managers/1
  # PUT /managers/1.json
  def update
    begin
		if signed_in?
			@current_client = current_user.username
			@manager = Manager.find(params[:id])
			respond_to do |format|
			  if @manager.update_attributes(params[:manager])
				format.html { redirect_to @manager, notice: 'Manager was successfully updated.' }
				format.js {render 'success_update.js.erb'}
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @manager.errors, status: :unprocessable_entity }
			  end
			end
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'managers#update'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  # DELETE /managers/1
  # DELETE /managers/1.json
  def destroy
	begin
		if signed_in?
			@manager = Manager.find(params[:id])
			@manager.destroy

			respond_to do |format|
			  format.html { redirect_to managers_url }
			  format.json { head :no_content }
			end
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'managers#destroy'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

end