class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.json  
  def index

		if signed_in?
			@current_client = current_user.username
			if current_user.username == 'admin'
				@reports = Report.order(:reportname)
			else
				@reports = Report.where('clnkey=?', current_user.id.to_s).order(:created_at)
				
				@tags=[]
				@reports.each do |r|
					if !@tags.include? r.tag1 and !r.tag1.nil?
						@tags<<r.tag1
					end
					if !@tags.include? r.tag2 and !r.tag2.nil?
						@tags<<r.tag2
					end
					if !@tags.include? r.tag3 and !r.tag3.nil?
						@tags<<r.tag3
					end
				end
				
				@tags = @tags.sort_by{|k| k}
			end
			
			
			
			@countryorder = 'links'
			@tournamentorder = 'links'
			@playerorder = 'links'
			@managerorder = 'links'
			@coachorder = 'links'
			@teamorder = 'links'
			@venueorder = 'links'
			@matchorder = 'links'
		else 
			redirect_to signin_path
		end
		
		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render json: @reports }
		end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])
	
	players_hash = {}
	countries_hash = {}
	formats_hash = {}
	tournaments_hash = {}
	teams_hash = {}
	teamtypes_hash = {}
	coaches_hash = {}
	managers_hash = {}
	shottypes_hash = {}
	angles_hash = {}
	lines_hash = {}
	lengths_hash = {}
	venues_hash = {}
	
	reports_hash = {}
	
	keys_hash = {}
	keys_hash['id'] = 'id'
	keys_hash['clnkey'] = 'Client'
	keys_hash['akey'] = 'Analysis'
	keys_hash['ckey'] = 'Country'
	keys_hash['fkey'] = 'Format'
	keys_hash['tkey'] = 'Tournament'
	keys_hash['inn'] = 'Inning'
	keys_hash['vkey'] = 'Venue'
	keys_hash['ttkey'] = 'Team Type'
	keys_hash['tmkey'] = 'Team'
	keys_hash['mtkey'] = 'Match'
	keys_hash['ptname'] = 'Player Type'
	keys_hash['ekey'] = 'End'
	keys_hash['btkey'] = 'Batsman'
	keys_hash['bts'] = 'Batting Style'
	keys_hash['bp'] = 'Batting Position'
	keys_hash['st'] = 'Shot Type'
	keys_hash['sd'] = 'Shot Direction'
	keys_hash['pckey'] = 'Pitch Condition'
	keys_hash['ckey1'] = 'Opp. Country'
	keys_hash['fkey1'] = 'Format'
	keys_hash['tkey1'] = 'Tournament'
	keys_hash['inn1'] = 'Inning'
	keys_hash['vkey1'] = 'Venue'
	keys_hash['ttkey1'] = 'Team Type'
	keys_hash['tmkey1'] = 'Opp. Team'
	keys_hash['mtkey1'] = 'Match'
	keys_hash['ptname1'] = 'Opp. Player Type'
	keys_hash['ekey1'] = 'End'
	keys_hash['blkey1'] = 'Bowler'
	keys_hash['bts1'] = 'Opp. Batting Style'
	keys_hash['bls1'] = 'Bowling Style'
	keys_hash['btn1'] = 'Bowling Type'
	keys_hash['blp1'] = 'Bowling Position'
	keys_hash['lk1'] = 'Line'
	keys_hash['lnk1'] = 'Length'
	keys_hash['bskey1'] = 'Bowling Side'
	keys_hash['spkey1'] = 'Spell'
	keys_hash['ankey1'] = 'Bowling Angle'
	keys_hash['pckey1'] = 'Pitch Condition'
	keys_hash['group1'] = 'Group 1'
	keys_hash['group2'] = 'Group 2'
	keys_hash['metric'] = 'Metric'
	keys_hash['lxm'] = 'Last X Matches'
	keys_hash['lxb'] = 'Last X Balls'
	keys_hash['fxb'] = 'First X Balls'
	keys_hash['fq'] = 'Frequency'
	keys_hash['vid'] = 'Video'
	keys_hash['bp1'] = 'Batting Position'
	
	
	
	players = Player.where('clientkey=?', current_user.id).select('distinct fullname, playerid')
	players.each do |player|
		players_hash[player.playerid.to_s] = player.fullname
	end
	reports_hash['btkey'] = players_hash
	reports_hash['blkey1'] = players_hash
	
	countries = Country.where('clientkey=?', current_user.id).select('country, id')
	countries.each do |country|
		countries_hash[country.id.to_s] = country.country
	end	
	reports_hash['ckey'] = countries_hash
	reports_hash['ckey1'] = countries_hash
	
	formats = Format.select('name, id')
	formats.each do |f|
		formats_hash[f.id.to_s] = f.name
	end	
	reports_hash['fkey'] = formats_hash
	reports_hash['fkey1'] = formats_hash
	tournaments = Tournament.where('clientkey=?', current_user.id).select('distinct name, id')
	tournaments.each do |t|
		tournaments_hash[t.id.to_s] = t.name
	end
	reports_hash['tkey'] = tournaments_hash
	reports_hash['tkey1'] = tournaments_hash
	teams = Team.where('clientkey=?', current_user.id).select('distinct teamname, teamid')
	teams.each do |t|
		teams_hash[t.teamid.to_s] = t.teamname
	end	
	reports_hash['tmkey'] = teams_hash
	reports_hash['tmkey1'] = teams_hash
	teamtypes = TeamType.select('teamtype, id')
	teamtypes.each do |t|
		teamtypes_hash[t.id.to_s] = t.teamtype
	end
	reports_hash['ttkey'] = teamtypes_hash	
	reports_hash['ttkey1'] = teamtypes_hash	
	venues = Venue.where('clientkey=?', current_user.id).select('venuename, id')
	venues.each do |v|
		venues_hash[v.id.to_s] = v.venuename
	end	
	reports_hash['vkey'] = venues_hash
	reports_hash['vkey1'] = venues_hash
	coaches = Coach.where('clientkey=?', current_user.id).select('name, id')
	coaches.each do |c|
		coaches_hash[c.id.to_s] = c.name
	end	
	reports_hash['chkey'] = coaches_hash
	reports_hash['chkey1'] = coaches_hash
	managers = Manager.where('clientkey=?', current_user.id).select('name, id')
	managers.each do |m|
		managers_hash[m.id.to_s] = m.name
	end
	reports_hash['mkey'] = managers_hash
	reports_hash['mkey1'] = managers_hash
	shotypes = Shottype.select('shottype, id')
	shotypes.each do |m|
		shottypes_hash[m.id.to_s] = m.shottype
	end
	reports_hash['st'] = shottypes_hash
	lines = Line.select('line, id')
	lines.each do |l|
		lines_hash[l.id.to_s] = l.line
	end
	reports_hash['lk1'] = lines_hash
	lengths = Length.select('length, id')
	lengths.each do |l|
		lengths_hash[l.id.to_s] = l.length
	end
	reports_hash['lnk1'] = lengths_hash	
	
	angles_hash[1.to_s]='Rt|Lf'
	angles_hash[2.to_s]='Rt|St'
	angles_hash[3.to_s]='Rt|Rt'
	angles_hash[4.to_s]='St|Lf'
	angles_hash[5.to_s]='St|St'
	angles_hash[6.to_s]='St|Rt'
	angles_hash[7.to_s]='Lf|Lf'
	angles_hash[8.to_s]='Lf|St'
	angles_hash[9.to_s]='Lf|Rt'
	angles_hash[10.to_s]='CLf'
	angles_hash[11.to_s]='CLf|St'
	angles_hash[12.to_s]='Clf|Rt'
	angles_hash[13.to_s]='CRt|Lf'
	angles_hash[14.to_s]='CRt|St'
	angles_hash[15.to_s]='Crt'
	
	reports_hash['ankey1'] = angles_hash	
	
	@selected_filters = {}
	@report.attributes.each do |key, value| 
		if !['', -2, 0, '0'].include? value and !['id', 'clnkey', 'group1', 'group2', 'metric', 'reportname', 'created_at', 'updated_at', 'charttype'].include? key
			temp = ''
			for v in value.to_s.split(',')
				if ['spkey1','bskey1','bp', 'bp1','pckey','pckey1','bts','bts1', 'btn1', 'blp1','bls1','inn', 'inn1','sdkey', 'ptname', 'ptname1', 'lxm', 'lxb', 'fxb', 'akey', 'fq' ,'vid', 'sd'].include? key 
					temp = v+','+temp
				else
					temp = reports_hash[key][v]+','+temp
				end
			end
			@selected_filters[keys_hash[key]] = temp
		end
	end
	filter_count = @selected_filters.count
	@selected_filters['report'] = @report
	@selected_filters['fcount'] = filter_count
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @selected_filters }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url }
      format.json { head :no_content }
    end
  end
  
end
