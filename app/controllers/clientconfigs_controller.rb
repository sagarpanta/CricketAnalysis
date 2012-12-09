class ClientconfigsController < ApplicationController
  # GET /clientconfigs
  # GET /clientconfigs.json
  def index
    
	
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@clientconfigs = Clientconfig.all
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end	

  end

  # GET /clientconfigs/1
  # GET /clientconfigs/1.json
  def show
    @clientconfig = Clientconfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clientconfig }
    end
  end

  # GET /clientconfigs/new
  # GET /clientconfigs/new.json
  def new
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@clientconfig = Clientconfig.new
			@clients = Client.all.collect  {|c| [c.name, c.id]}
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clientconfig }
    end
  end

  # GET /clientconfigs/1/edit
  def edit
    
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@clientconfig = Clientconfig.find(params[:id])
			@clients = Client.all.collect  {|c| [c.name, c.id]}
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end
  end

  # POST /clientconfigs
  # POST /clientconfigs.json
  def create
    @clientconfig = Clientconfig.new(params[:clientconfig])

    respond_to do |format|
      if @clientconfig.save
        format.html { redirect_to @clientconfig, notice: 'Clientconfig was successfully created.' }
        format.json { render json: @clientconfig, status: :created, location: @clientconfig }
      else
        format.html { render action: "new" }
        format.json { render json: @clientconfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clientconfigs/1
  # PUT /clientconfigs/1.json
  def update
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@clientconfig = Clientconfig.find(params[:id])
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end

    respond_to do |format|
      if @clientconfig.update_attributes(params[:clientconfig])
        format.html { redirect_to @clientconfig, notice: 'Clientconfig was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clientconfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientconfigs/1
  # DELETE /clientconfigs/1.json
  def destroy
    
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@clientconfig = Clientconfig.find(params[:id])
			@clientconfig.destroy
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end

    respond_to do |format|
      format.html { redirect_to clientconfigs_url }
      format.json { head :no_content }
    end
  end
  
 
  def settings
	@clientconfig = Clientconfig.find_by_clientkey(params[:clientkey])
	respond_to do |format|
		format.json { render json: @clientconfig }
	end
  end
end
