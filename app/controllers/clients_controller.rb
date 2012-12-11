class ClientsController < ApplicationController
  # GET /clients
  # GET /clients.json
  def index
	if signed_in? or Client.first.nil?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@clients = Client.all
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end

  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new 
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@client = Client.new
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end
  end

  # GET /clients/1/edit
  def edit
    
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@client = Client.find(params[:id])
			
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])

    respond_to do |format|
      if @client.save
		ClientMailer.registration_confirmation(@client).deliver
		Country.create!({'clientkey'=>@client.id, 'country'=>@client.country})
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
	
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
	if signed_in?
		@current_client = current_user.username
		if current_user.username == 'admin'
			@client = Client.find(params[:id])
			
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end
    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to clients_path}
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy

	if signed_in?
		if current_user.username == 'admin'
			@client = Client.find(params[:id])
			@client.destroy
		else
			redirect_to home_path
		end
	else
		redirect_to signin_path
	end
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end
  

  def signin
	if signed_in?
		redirect_to home_path
	else
		@title = 'Sign In'
	end
  end
  
  def home
    begin
		if signed_in?
			@current_client = current_user.username
		else
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'clients#home'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  def new_session
	begin
		client = Client.find_by_username(params[:client][:username])
		if client && Client.authenticate(params[:client][:username], params[:client][:password])
			#sign in user and redirect to user's show page.
			sign_in client
			flash[:error] = ''
			redirect_to home_path
		else 
			flash[:error] = 'Invalid email/password combination'
			render 'signin'
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'clients#new_session'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end

  def signout
	begin
		sign_out
		redirect_to '/signin'
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'clients#signout'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  
  def forgotu
  end
  
  def showu
	client = Client.find_by_email(params[:email])
		if client
			@username = client.username
			@error = ''
		else
			
			@error = 'The email does not exist'
		end
  end
  
  def send_temp_password
	client = Client.find_by_email(params[:email])
	if client
		@username = client.username
		temppass = (0...6).map{ ('a'..'z').to_a[rand(26)] }.join
		client.update_attribute(:encrypted_password, temppass)
		client.save
		ClientMailer.send_temp_password(client, temppass).deliver
		
	else
		flash[:error] = 'The email does not exist'
	end
  end
  
  def generatePass
    begin
		if signed_in?
			@client = Client.where('id = ?',params[:id])
			temppass = (0...6).map{ ('a'..'z').to_a[rand(26)] }.join
			Client.where('id = ? ', @client[0].id).update_all(:temppass=> temppass)
			@client = Client.find_by_id(params[:id])
			ClientMailer.temporary_password(@client).deliver
		else
			redirect_to signin_path
		end

		respond_to do |format|
			format.html {render 'generatePass.html.erb'}
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'clients#generatePass'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  def change_password
  end
  
  def changedpassword
	begin
		username = ''
		if signed_in?
			@client = Client.find(current_user.id)
			username = @client.username
			@client.update_attribute(:encrypted_password,params[:client][:new])
			@client.save
		end  
		redirect_to :controller=>'clients' , :action=> 'new_session' , :client=>{:username=>username, :password=>params[:client][:new]}
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'clients#changedpassword'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end	  
  end
 
end
