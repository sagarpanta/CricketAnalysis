require 'csv'

class ExternalsController < ApplicationController
  # GET /externals
  # GET /externals.json
  def index
    @externals = External.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @externals }
    end
  end

  # GET /externals/1
  # GET /externals/1.json
  def show
    @external = External.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @external }
    end
  end

  # GET /externals/new
  # GET /externals/new.json
  def new
    @external = External.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @external }
    end
  end

  # GET /externals/1/edit
  def edit
    @external = External.find(params[:id])
  end

  # POST /externals
  # POST /externals.json
  def create
    @external = External.new(params[:external])

    respond_to do |format|
      if @external.save
        format.html { redirect_to @external, notice: 'External was successfully created.' }
        format.json { render json: @external, status: :created, location: @external }
      else
        format.html { render action: "new" }
        format.json { render json: @external.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /externals/1
  # PUT /externals/1.json
  def update
    @external = External.find(params[:id])

    respond_to do |format|
      if @external.update_attributes(params[:external])
        format.html { redirect_to @external, notice: 'External was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @external.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /externals/1
  # DELETE /externals/1.json
  def destroy
    @external = External.find(params[:id])
    @external.destroy

    respond_to do |format|
      format.html { redirect_to externals_url }
      format.json { head :no_content }
    end
  end
  
  
  def upload 
	begin
		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@coaches = Coach.all	
			else
				@tournaments = Tournament.where('clientkey=?', current_user.id ).all
				@venues = Venue.where('clientkey=?', current_user.id ).all
				@matches = Match.find_by_sql("select distinct m.id, t.teamname||' - '||t1.teamname from matches m inner join (select distinct teamid, clientkey, teamname from teams) t on m.teamidone=t.teamid and m.clientkey = t.clientkey inner join (select distinct teamid, clientkey, teamname from teams) t1 on m.teamidtwo=t1.teamid and m.clientkey = t1.clientkey where m.clientkey = "+current_user.id.to_s	)
			end
			
			filename = 'C:/Users/spant/Downloads/Spreadsheet.csv'  
			@rows = []
			CSV.foreach(filename, :headers => true) do |row|
			  #Moulding.create!(row.to_hash)
			  @rows << row
			end

		else 
			redirect_to signin_path
		end
		respond_to do |format|
			format.html
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'externals#upload'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  
  end
  
end
