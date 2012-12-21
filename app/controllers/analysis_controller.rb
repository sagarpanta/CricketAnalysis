class AnalysisController < ApplicationController
  def index
	begin
		if signed_in?
			if current_user.username == 'admin'
				@current_client = current_user.username
				@countries = Country.all

				@players = Player.all

				@tournaments = Tournament.all

				@venues = Venue.all

				#@teams = Team.group(:teamid, :teamname).select('teamid, teamname')
				@teams = Team.select('distinct teamid, teamname')
				@coaches = Coach.all

				@managers = Manager.all
				@pitchconditions = Match.where('clientkey=?', current_user.id)

			else
				@current_client = current_user.name
				
				@tournaments = Tournament.where('clientkey=?', current_user.id ).all
				@countries = Country.where('clientkey=?', current_user.id )

				@players = Player.where('clientkey=?', current_user.id )

				@tournaments = Tournament.where('clientkey=?', current_user.id )

				@venues = Venue.where('clientkey=?', current_user.id )

				#@teams = Team.group(:teamid, :teamname).where('clientkey=?', current_user.id ).all
				@teams = Team.select('distinct teamid, teamname').where('clientkey=?', current_user.id )

				@coaches = Coach.where('clientkey=?', current_user.id )

				@managers = Manager.where('clientkey=?', current_user.id )
				@pitchconditions = Match.where('clientkey=?', current_user.id)
			end

			@formats = Format.all
			#@_matchformats = [{id:-2, name:'All'}]
			#@formats.each do |c|
			#	@_matchformats << {id:c.id, name:c.name}
			#end

			@battingstyles = Player.select('distinct battingstyle')
			@bowlingstyles = Player.select('distinct bowlingstyle')
			@bowlingtypes = Player.select('distinct bowlingtype')

			@playertypes = Player.select('playertype')
			
			@battingpositions = @bowlingpositions = [1,2,3,4,5,6,7,8,9,10,11]
			
			@dismissaltypes = Dismissal.all

			@matchtypes = MatchType.all
			
			@innings = [1,2,3,4]

			@teamtypes = TeamType.all
			@ends = []
			@venues.each do |v|
				@ends << [v.venuename, v.endone, v.endonekey]
				@ends << [v.venuename, v.endtwo, v.endtwokey]
			end
			
			@lines = Line.all
			@lengths = Length.all
			@shottypes = Shottype.all
			@sides = [{'side'=>'RTW', 'val'=>0}, {'side'=>'OTW', 'val'=>1}]
			@directions = Scorecard.where('clientkey=?', current_user.id).select('distinct direction')
		else 
			redirect_to signin_path
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'analysis#index'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  end
  
  
  def matchwins
	begin
		query = '	Select c1.country as grp2, count(distinct mat.id) as won , count(distinct mat1.id) as lost 
					from scorecards s 
					inner join players p on p.clientkey = s.clientkey and p.id = s.batsmankey 
					inner join teams tm on s.clientkey = tm.clientkey and tm.playerkey = s.batsmankey 
					 
					inner join players p1 on s.currentbowlerkey = p1.id and s.clientkey = p1.clientkey 
					inner join teams tm1 on s.clientkey = tm1.clientkey and tm1.playerkey = s.currentbowlerkey 

					LEFT join (select * from matches where winnerkey<>-2) mat on tm.clientkey = mat.clientkey and tm.teamid = mat.winnerkey and tm1.teamid = mat.teamidtwo
					LEFT join (select * from matches where winnerkey<>-2) mat1 on tm.clientkey = mat1.clientkey and tm.teamid <> mat1.winnerkey and tm1.teamid = mat1.teamidtwo
					inner join clients cl on tm.clientkey = cl.id
					inner join countries c on c.country = cl.country and tm.countrykey = c.id
					inner join countries c1 on c1.id = tm1.countrykey
					where s.clientkey = '+params[:clientkey]+'
					group by c1.country
				'
		@chartdata = Scorecard.find_by_sql(query)
		
		@chartdata = @chartdata == []? nil:@chartdata
			
		@data = Scorecard.getChartWonLost(@chartdata)

		
		respond_to do |format|
		  format.json { render json: @data }
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'analysis#matchwins'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end
  
  end
  

  def generate
	begin
		lastXmatches = params[:filters][:lxm].to_i
		
		if lastXmatches == -2
			matchcount = Scorecard.count('distinct matchkey')
		else
			matchcount = lastXmatches
		end

		lastXballs = params[:filters][:lxb].to_i
		
		if lastXballs == -2
			scorecards = ' scorecards '
			ballnumber_betn = '0 and 300'
		else
			scorecards = ' (select ballnum = rank() over (partition by matchkey, batsmankey order by matchkey, batsmankey, ballnum desc), clientkey, ballsdelivered, ballsfaced, batsmankey, battingposition, bowlerkey, bowlingendkey, bowlingposition, byes, currentbowlerkey, currentnonstrikerkey, currentstrikerkey, dismissedbatsmankey, eights, fielderkey, fives, formatkey, fours, inning, legbyes, maiden, matchkey, noballs, ones, others, outbywk, outtypekey, runs, sevens, sixes, teamidone, teamtwoid, threes, tournamentkey, twos, venuekey, wicket, wides, zeros, "over", line, length, shottype, side, spell, direction from scorecards) '
			ballnumber_betn = '0 and '+lastXballs.to_s
		end
	
		
		analysiskey = params[:filters][:akey]
		clientkey = params[:filters][:clkey]	
		countrykey = params[:filters][:ckey]
		formatkey = params[:filters][:fkey]
		tournamentkey = params[:filters][:tkey]
		venuekey = params[:filters][:vkey]
		teamtypekey = params[:filters][:ttkey]
		teamkey = params[:filters][:tmkey]
		matchtypekey = params[:filters][:mtkey]
		coachkey = params[:filters][:chkey]
		managerkey = params[:filters][:mkey]
		playertypename = params[:filters][:ptname]
		#playerkey = params[:filters][:pkey]
		batsmankey = params[:filters][:btkey]
		endkey = params[:filters][:ekey]
		battingstylename = params[:filters][:bts]
		battingposition = params[:filters][:bp]
		inningkey = params[:filters][:inn]
		shottypekey = params[:filters][:st]
		shotdirectionkey = params[:filters][:sd]
		pitchconditionkey = params[:filters][:pckey]
		
		countrykey1 = params[:filters][:ckey1]
		formatkey1 = params[:filters][:fkey1]
		tournamentkey1 = params[:filters][:tkey1]
		venuekey1 = params[:filters][:vkey1]
		teamtypekey1 = params[:filters][:ttkey1]
		teamkey1 = params[:filters][:tmkey1]
		matchtypekey1 = params[:filters][:mtkey1]
		coachkey1 = params[:filters][:chkey1]
		managerkey1 = params[:filters][:mkey1]
		playertypename1 = params[:filters][:ptname1]
		#playerkey = params[:filters][:pkey]
		bowlerkey1 = params[:filters][:blkey1]
		endkey1 = params[:filters][:ekey1]
		bowlingtypename1 = params[:filters][:btn1]
		bowlingstylename1 = params[:filters][:bls1]
		bowlingposition1 = params[:filters][:blp1]
		inningkey1 = params[:filters][:inn1]
		linekey1 = params[:filters][:lk1]
		lengthkey1 = params[:filters][:lnk1]
		bowlingsidekey1 = params[:filters][:bskey1]
		spellkey1 = params[:filters][:spkey1]
		pitchconditionkey1 = params[:filters][:pckey1]
		
		metric = params[:filters][:metric]
		group1 = params[:filters][:group1]
		group2 = params[:filters][:group2]

		if group1 == group2
			group2 = ''		
		end

		combination = countrykey.product(formatkey, tournamentkey, venuekey, teamtypekey, teamkey, matchtypekey, coachkey, managerkey, playertypename, batsmankey, endkey, battingstylename, battingposition, inningkey, shottypekey, shotdirectionkey, pitchconditionkey)

		combination1 = countrykey1.product(formatkey1, tournamentkey1, venuekey1, teamtypekey1, teamkey1, matchtypekey1, coachkey1, managerkey1, playertypename1, bowlerkey1, endkey1, bowlingtypename1, bowlingstylename1, bowlingposition1, inningkey1, linekey1, lengthkey1, bowlingsidekey1, spellkey1, pitchconditionkey1)

		countrykeys = formatkeys = tournamentkeys = venuekeys = teamtypekeys = teamkeys = matchtypekeys = coachkeys = managerkeys = playertypekeys = batsmankeys  = endkeys = battingstylekeys  = batpositionkeys  = inningkeys = shottypekeys = shotdirectionkeys=pitchconditionkeys = '('
		countrykeys1 = formatkeys1 = tournamentkeys1 = venuekeys1 = teamtypekeys1 = teamkeys1 = matchtypekeys1 = coachkeys1 = managerkeys1 = playertypekeys1  = bowlerkeys1 = endkeys1  = bowlingstylekeys1 = bowlingtypekeys1  = bowlpositionkeys1 = inningkeys1 = linekeys1 = lengthkeys1 = bowlingsidekeys1 = spellkeys1 = pitchconditionkeys1='('
		
		iscountryempty = isformatempty = istournamentempty = isvenueempty = isteamtypeempty = isteamempty = ismatchtypeempty = iscoachempty = isshottypekeyempty = isshotdirectionkeyempty = 0
		ismanagerempty = isplayertypeempty = isbatsmanempty  = isendempty = isbatstyleempty  = isbatposempty  =isinningempty = ispitchconditionkeyempty = 0
		
		iscountryempty1 = isformatempty1 = istournamentempty1 = isvenueempty1 = isteamtypeempty1 = isteamempty1 = ismatchtypeempty1 = iscoachempty1 = islinekeyempty1 = isbowlingsidekeyempty1 = isspellkeyempty1 =0
		ismanagerempty1 = isplayertypeempty1  = isbowlerempty1 = isendempty1  = isbowlstyleempty1 = isbowltypeempty1  = isbowlposempty1 =isinningempty1 = islengthkeyempty1 = ispitchconditionkeyempty1 = 0
		
	
		for i in 0...combination.length
			countrykeys  += combination[i][0] +','
			iscountryempty = combination[i][0] == ''? 1:0
			formatkeys  += combination[i][1] +','
			isformatempty = combination[i][1] == ''? 1:0
			tournamentkeys  += combination[i][2] +','
			istournamentempty = combination[i][2] == ''? 1:0
			venuekeys  += combination[i][3] +','
			isvenueempty = combination[i][3] == ''? 1:0
			teamtypekeys  += combination[i][4] +','
			isteamtypeempty = combination[i][4] == ''? 1:0
			teamkeys  += combination[i][5] +','
			isteamempty = combination[i][5] == ''? 1:0
			matchtypekeys  += combination[i][6] +','
			ismatchtypeempty = combination[i][6] == ''? 1:0
			coachkeys  += combination[i][7] +','
			iscoachempty = combination[i][7] == ''? 1:0
			managerkeys  += combination[i][8] +','
			ismanagerempty = combination[i][8] == ''? 1:0
			playertypekeys  += "'"+combination[i][9] +"',"
			isplayertypeempty = combination[i][9] == ''? 1:0
			batsmankeys  += combination[i][10] +','
			isbatsmanempty = combination[i][10] == ''? 1:0
			endkeys  += combination[i][11] +','
			isendempty = combination[i][11] == ''? 1:0
			battingstylekeys  += "'"+combination[i][12] +"',"
			isbatstyleempty = combination[i][12] == ''? 1:0
			batpositionkeys += combination[i][13] +','
			isbatposempty = combination[i][13] == ''? 1:0
			inningkeys += combination[i][14] +','
			isinningempty = combination[i][14] == ''? 1:0
			shottypekeys += combination[i][15] +','
			isshottypekeyempty = combination[i][15] == ''? 1:0
			shotdirectionkeys += "'"+combination[i][16] +"',"
			isshotdirectionkeyempty = combination[i][16] == ''? 1:0
			pitchconditionkeys += "'"+combination[i][17] +"',"
			ispitchconditionkeyempty = combination[i][17] == ''? 1:0
		end
		for i in 0...combination1.length
			countrykeys1  += combination1[i][0] +','
			iscountryempty1 = combination1[i][0] == ''? 1:0
			formatkeys1  += combination1[i][1] +','
			isformatempty1 = combination1[i][1] == ''? 1:0
			tournamentkeys1  += combination1[i][2] +','
			istournamentempty1 = combination1[i][2] == ''? 1:0
			venuekeys1  += combination1[i][3] +','
			isvenueempty1 = combination1[i][3] == ''? 1:0
			teamtypekeys1  += combination1[i][4] +','
			isteamtypeempty1 = combination1[i][4] == ''? 1:0
			teamkeys1  += combination1[i][5] +','
			isteamempty1 = combination1[i][5] == ''? 1:0
			matchtypekeys1  += combination1[i][6] +','
			ismatchtypeempty1 = combination1[i][6] == ''? 1:0
			coachkeys1  += combination1[i][7] +','
			iscoachempty1 = combination1[i][7] == ''? 1:0
			managerkeys1  += combination1[i][8] +','
			ismanagerempty1 = combination1[i][8] == ''? 1:0
			playertypekeys1  += "'"+combination1[i][9] +"',"
			isplayertypeempty1 = combination1[i][9] == ''? 1:0
			bowlerkeys1  += combination1[i][10] +','
			isbowlerempty1 = combination1[i][10] == ''? 1:0
			endkeys1  += combination1[i][11] +','
			isendempty1 = combination1[i][11] == ''? 1:0
			bowlingtypekeys1  += "'"+combination1[i][12] +"',"
			isbowltypeempty1 = combination1[i][12] == ''? 1:0
			bowlingstylekeys1  += "'"+combination1[i][13] +"',"
			isbowlstyleempty1 = combination1[i][13] == ''? 1:0
			bowlpositionkeys1 += combination1[i][14] +','
			isbowlposempty1 = combination1[i][14] == ''? 1:0
			inningkeys1 += combination1[i][15] +','
			isinningempty1 = combination1[i][15] == ''? 1:0
			linekeys1 += combination1[i][16] +','
			islinekeyempty1 = combination1[i][16] == ''? 1:0
			lengthkeys1 += combination1[i][17] +','
			islengthkeyempty1 = combination1[i][17] == ''? 1:0
			bowlingsidekeys1 += combination1[i][18] +','
			isbowlingsidekeyempty1 = combination1[i][18] == ''? 1:0
			spellkeys1 += combination1[i][19] +','
			isspellkeyempty1 = combination1[i][19] == ''? 1:0
			pitchconditionkeys1 += "'"+combination1[i][20] +"',"
			ispitchconditionkeyempty1 = combination1[i][20] == ''? 1:0
			
		end
		countrykeys = iscountryempty == 1?  'not in (-2)':'in '+countrykeys[0...-1] + ')'
		formatkeys  = isformatempty==1? 'not in (-2)':'in '+formatkeys[0...-1] + ')'
		tournamentkeys  = istournamentempty==1? 'not in (-2)':'in '+tournamentkeys[0...-1] + ')'
		venuekeys  = isvenueempty==1? 'not in (-2)':'in '+venuekeys[0...-1] + ')'
		teamtypekeys  = isteamtypeempty==1? 'not in (-2)':'in '+teamtypekeys[0...-1] + ')'
		teamkeys  = isteamempty==1? 'not in (-2)':'in '+teamkeys[0...-1] + ')'
		matchtypekeys  = ismatchtypeempty==1? 'not in (-2)':'in '+matchtypekeys[0...-1] + ')'
		coachkeys  = iscoachempty==1? 'not in (-2)':'in '+coachkeys[0...-1] + ')'
		managerkeys  = ismanagerempty==1? 'not in (-2)':'in '+managerkeys[0...-1] + ')'
		playertypekeys  = isplayertypeempty==1? "not in ('n/a')":'in '+playertypekeys[0...-1] + ')'
		batsmankeys  = isbatsmanempty==1? 'not in (-2)':'in '+batsmankeys[0...-1] + ')'
		endkeys  = isendempty==1? 'not in (-2)':'in '+endkeys[0...-1] + ')'
		battingstylekeys  = isbatstyleempty==1? "not in ('n/a')":'in '+battingstylekeys[0...-1] + ')'
		batpositionkeys  = isbatposempty==1? 'not in (-2)':'in '+batpositionkeys[0...-1] + ')'
		inningkeys  = isinningempty==1? 'not in (-2)':'in '+inningkeys[0...-1] + ')'
		shottypekeys  = isshottypekeyempty==1? 'not in (-2)':'in '+shottypekeys[0...-1] + ')'		
		shotdirectionkeys  = isshotdirectionkeyempty==1? "not in ('n/a')":'in '+shotdirectionkeys[0...-1] + ')'	
		pitchconditionkeys  = ispitchconditionkeyempty==1? "not in ('n/a')":'in '+pitchconditionkeys[0...-1] + ')'	
		
		
		countrykeys1 = iscountryempty1 == 1?  'not in (-2)':'in '+countrykeys1[0...-1] + ')'
		formatkeys1  = isformatempty1==1? 'not in (-2)':'in '+formatkeys1[0...-1] + ')'
		tournamentkeys1  = istournamentempty1==1? 'not in (-2)':'in '+tournamentkeys1[0...-1] + ')'
		venuekeys1  = isvenueempty1==1? 'not in (-2)':'in '+venuekeys1[0...-1] + ')'
		teamtypekeys1  = isteamtypeempty1==1? 'not in (-2)':'in '+teamtypekeys1[0...-1] + ')'
		teamkeys1  = isteamempty1==1? 'not in (-2)':'in '+teamkeys1[0...-1] + ')'
		matchtypekeys1  = ismatchtypeempty1==1? 'not in (-2)':'in '+matchtypekeys1[0...-1] + ')'
		coachkeys1  = iscoachempty1==1? 'not in (-2)':'in '+coachkeys1[0...-1] + ')'
		managerkeys1  = ismanagerempty1==1? 'not in (-2)':'in '+managerkeys1[0...-1] + ')'
		playertypekeys1  = isplayertypeempty1==1? "not in ('n/a')":'in '+playertypekeys1[0...-1] + ')'
		bowlerkeys1  = isbowlerempty1==1? 'not in (-2)':'in '+bowlerkeys1[0...-1] + ')'
		endkeys1  = isendempty1==1? 'not in (-2)':'in '+endkeys1[0...-1] + ')'
		bowlingtypekeys1  = isbowltypeempty1==1? "not in ('n/a')":'in '+bowlingtypekeys1[0...-1] + ')'
		bowlingstylekeys1  = isbowlstyleempty1==1? "not in ('n/a')":'in '+bowlingstylekeys1[0...-1] + ')'
		bowlpositionkeys1  = isbowlposempty1==1? 'not in (-2)':'in '+bowlpositionkeys1[0...-1] + ')'
		inningkeys1  = isinningempty1==1? 'not in (-2)':'in '+inningkeys1[0...-1] + ')'
		linekeys1  = islinekeyempty1==1? 'not in (-2)':'in '+linekeys1[0...-1] + ')'	
		lengthkeys1  = islengthkeyempty1==1? 'not in (-2)':'in '+lengthkeys1[0...-1] + ')'	
		bowlingsidekeys1  = isbowlingsidekeyempty1==1? 'not in (-2)':'in '+bowlingsidekeys1[0...-1] + ')'			
		spellkeys1  = isspellkeyempty1==1? 'not in (-2)':'in '+spellkeys1[0...-1] + ')'	
		pitchconditionkeys1  = ispitchconditionkeyempty1==1? "not in ('n/a')":'in '+pitchconditionkeys1[0...-1] + ')'			

		#player_filter = 'countrykey '+countrykeys +' and formatkey '+formatkeys + ' and playertype '+playertypekeys+ ' and id ' +playerkeys+' and battingstyle '+battingstylekeys+' and bowlingstyle '+bowlingstylekeys+' and bowlingtype '+bowlingtypekeys
		#@players = Player.where(player_filter)

		_joins = {}
		_group1 = {}
		_group2 = {}
		
		if analysiskey == 'Batting'
			_group1['bts'] = 'p.battingstyle'
			_group1['bls'] = 'p1.bowlingstyle'
			_group1['team'] = 'tm.teamname'
			_group1['teamagainst'] = 'tm1.teamname'
			_group1['tournament'] = 't.name'
			_group1['venue'] = 'venuename'
			_group1['matchtype'] = 'matchtype'
			_group1['teamtype'] = 'teamtype'	
			_group1['battingposition'] = 'battingposition'
			_group1['bowlingposition'] = 'bowlingposition'
			_group1['coach'] = 'c.name'
			_group1['manager'] = 'm.name'	
			_group1['bowlingtype'] = 'p1.bowlingtype'
			_group1['year'] = 'cast(extract(year from s.created_at) as integer)'
			_group1['inning'] = 'inning'	
			_group1['format'] = 'f.name'
			_group1['country'] = 'cn.country'	
			_group1['countryagainst'] = 'cn1.country'
			_group1['bowler'] = 'p1.fullname'
			_group1['batsman'] = 'p.fullname'
			_group1['dismissal'] = 'dismissaltype'
			_group1['cr'] = 'cr'
			_group1['pship'] = "case when currentstrikerkey<currentnonstrikerkey then p.fullname+'-'+p2.fullname else p2.fullname+'-'+p.fullname end"
			#_group1['match'] = 's.matchkey'
			_group1['match'] = "'vs '||tm1.teamname"
			_group1['shottype'] = 'st.shottype'
			_group1['line'] = 'l.line'
			_group1['length'] = 'ln.length'
			_group1['side'] = "case when s.side=0 then 'RTW' ELSE 'OTW' END"
			_group1['direction'] = 's.direction'
			_group1['spell'] = 's.spell'
			_group1['condition'] = 'mat.pitchcondition'
		
			_group2['bts'] = ',p.battingstyle'
			_group2['bls'] = ',p1.bowlingstyle'
			_group2['team'] = ',tm.teamname'
			_group2['teamagainst'] = ',tm1.teamname'
			_group2['tournament'] = ',t.name'
			_group2['venue'] = ',venuename'
			_group2['matchtype'] = ',matchtype'
			_group2['teamtype'] = ',teamtype'	
			_group2['battingposition'] = ',battingposition'
			_group2['bowlingposition'] = ',bowlingposition'
			_group2['coach'] = ',c.name'
			_group2['manager'] = ',m.name'	
			_group2['bowlingtype'] = ',p.bowlingtype'
			#_group2['year'] = ',datepart(yy, s.created_at)'
			_group2['year'] = ',cast(extract(year from s.created_at) as integer)'
			_group2['inning'] = ',inning'	
			_group2['format'] = ',f.name'
			_group2['country'] = ',cn.country'	
			_group2['countryagainst'] = ',cn1.country'
			_group2['bowler'] = ',p1.fullname'
			_group2['batsman'] = ',p.fullname'
			_group2['dismissal'] = ',dismissaltype'
			_group2['cr'] = ',cr'
			_group2['pship'] = ",case when currentstrikerkey<currentnonstrikerkey then p.fullname+'-'+p2.fullname else p2.fullname+'-'+p.fullname end"
			#_group2['match'] = ',s.matchkey'
			_group2['match'] = ",'vs '||tm1.teamname"
			_group2['shottype'] = ',st.shottype'
			_group2['line'] = ',l.line'
			_group2['length'] = ',ln.length'
			_group2['side'] = ",case when s.side=0 then 'RTW' ELSE 'OTW' END"
			_group2['direction'] = ',s.direction'
			_group2['spell'] = ',s.spell'
			_group2['condition'] = ',mat.pitchcondition'
			
			
			if metric == 'c_nonstrike'
				batsman_part = ' inner join players p on p.clientkey = s.clientkey and p.id = s.currentnonstrikerkey '
			else
				batsman_part = ' inner join players p on p.clientkey = s.clientkey and p.id = s.batsmankey '
			end
			nonstriker_part = ' inner join players p2 on p2.id = s.currentbowlerkey and p2.clientkey = s.clientkey '
			country_part = ' inner join countries cn on p.countrykey = cn.id	and p.clientkey = cn.clientkey '
			tournament_part = ' inner join tournaments t on s.clientkey = t.clientkey and s.tournamentkey = t.id '
			venue_part =' inner join venues v on s.clientkey = v.clientkey and s.venuekey = v.id '
			team_part = ' inner join teams tm on s.clientkey = tm.clientkey and tm.playerkey = s.batsmankey '
			teamtype_part = ' inner join team_types tt on tm.teamtypekey = tt.id '
			coach_part= ' inner join coaches c on tm.coachkey = c.id and tm.clientkey = c.clientkey '
			manager_part= ' inner join managers m on tm.managerkey = m.id and tm.clientkey = m.clientkey '
			match_part =' inner join matches mat on mat.id = s.matchkey and mat.clientkey = s.clientkey '
			matchtype_part = ' inner join match_types mt on mt.id = mat.matchtypekey '
			format_part = ' inner join formats f on f.id = s.formatkey '
			#teamidone is always the client who logs in
			#mtchwinner_part = ' inner join (select distinct teamid, clientkey from teams) tms on s.clientkey = tms.clientkey and s.teamidone = tms.teamid inner join (select teamidone, matchwon = case when winnerkey = teamidone then 1 else 0 end from matches) mw on s.teamidone = mw.teamidone '
			#teamidone is always the client who logs in
			#mtchloser_part = ' inner join (select distinct teamid, clientkey from teams) tms on s.clientkey = tms.clientkey and s.teamidone = tms.teamid inner join (select teamidone, matchlost = case when winnerkey = teamidtwo then 1 else 0 end from matches) mw on s.teamoneid = mw.teamidone '
			
			bowler_part = ' inner join players p1 on s.currentbowlerkey = p1.id and s.clientkey = p1.clientkey '
			countryagainst_part = ' inner join countries cn1 on p1.countrykey = cn1.id and p1.clientkey = cn1.clientkey '
			teamagainst_part = ' inner join teams tm1 on s.clientkey = tm1.clientkey and tm1.playerkey = s.currentbowlerkey ' 
			teamtypeagainst_part = ' inner join team_types tt1 on tm1.teamtypekey = tt1.id '
			coachagainst_part= ' inner join coaches c1 on tm1.coachkey = c1.id	and tm1.clientkey = c1.clientkey '
			manageragainst_part= ' inner join managers m1 on tm1.managerkey = m1.id and tm1.clientkey = m1.clientkey '
			dismissal_part = ' inner join dismissals d on d.id = s.outtypekey inner join players p3 on s.dismissedbatsmankey = p3.id and s.clientkey = p3.clientkey ' 
			pship_part = ' inner join players p2 on s.currentnonstrikerkey = p2.id and s.clientkey = p2.clientkey '
			shottype_part = ' inner join shottypes st on s.shottype = st.id '
			line_part = ' inner join lines l on s.line = l.id '
			length_part = ' inner join lengths ln on s.length = ln.id '

			
		   where_batsmankeys =  ' and s.batsmankey '+batsmankeys
		   where_countrykeys = ' and p.countrykey ' + countrykeys
		   where_battingstylekeys = ' and p.battingstyle '+battingstylekeys
		   where_playertypekeys = ' and p.playertype '+playertypekeys
		   where_tournamentkeys = ' and s.tournamentkey '+tournamentkeys
		   where_inningkeys =' and s.inning '+inningkeys
		   where_batpositionkeys =' and s.battingposition '+batpositionkeys
		   where_venuekeys =' and s.venuekey '+venuekeys
		   where_teamtypekeys =' and tm.teamtypekey '+teamtypekeys
		   where_teamkeys =' and tm.teamid '+teamkeys
		   where_coachkeys =' and tm.coachkey '+coachkeys
		   where_managerkeys =' and tm.managerkey '+managerkeys
		   where_matchtypekeys =' and mt.id '+matchtypekeys
		   where_formatkeys =' and s.formatkey '+formatkeys
		   where_shottypekeys = ' and st.id '+shottypekeys
		   where_shotdirectionkeys = ' and s.direction '+shotdirectionkeys
		   where_pitchconditionkeys = ' and mat.pitchcondition '+pitchconditionkeys
		   
		   where_bowlerkeys =' and s.currentbowlerkey '+bowlerkeys1
		   where_countrykeys1 = ' and p1.countrykey ' + countrykeys1
		   where_countryagainstkeys1 = ' and p1.countrykey '+countrykeys1
		   where_bowlingstylekeys1 =' and p1.bowlingstyle '+bowlingstylekeys1
		   where_bowlingtypekeys1 =' and p1.bowlingtype '+bowlingtypekeys1
		   where_playertypekeys1 =' and p1.playertype '+playertypekeys1
		   where_tournamentkeys1 =' and s.tournamentkey '+tournamentkeys1
		   where_venuekeys1 =' and s.venuekey '+venuekeys1
		   where_teamtypekeys1 =' and tm1.teamtypekey '+teamtypekeys1
		   where_teamkeys1 =' and tm1.teamid '+teamkeys1
		   where_teamagainstkeys1 =' and tm1.teamid '+teamkeys1
		   where_coachkeys1 =' and tm1.coachkey '+coachkeys1
		   where_managerkeys1 =' and tm1.managerkey '+managerkeys1
		   where_matchtypekeys1 =' and mt.id '+matchtypekeys1
		   where_formatkeys1 =' and s.formatkey '+formatkeys1
		   where_inningkeys1 =' and s.inning '+inningkeys1
		   where_bowlpositionkeys1 =' and s.bowlingposition '+bowlpositionkeys1
		   where_linekeys1 = ' and l.id '+linekeys1
		   where_lengthkeys1 = ' and ln.id '+lengthkeys1
		   where_bowlingsidekeys1 = ' and s.side '+bowlingsidekeys1
		   where_spellkeys1 = ' and s.spell '+spellkeys1
		   where_pitchconditionkeys1 = ' and mat.pitchcondition '+pitchconditionkeys1
		   
		   where_always =' where s.clientkey = '+current_user.id.to_s + ' and ballnum between ' + ballnumber_betn		

			build_query = ''
			build_query_match = ''
			where_clause = ''


			against_group = ['bowler' , 'bls' , 'bowlingposition' , 'bowlingtype' , 'teamagainst' , 'countryagainst']
			
			#followings are the groups/filters...when applied, players p table need to be joined with scorecards s  so that team, country and so on can then join
			batsman_group = ['batsman', 'bts', 'team', 'venue', 'matchtype', 'country','teamtype' , 'coach', 'manager', 'cr', 'pship']
			
			#follwings are the pure bowler group which are used to monitor filters in the bowling side. 
			#such as when country is selected on the right hand side and one of the groups is in the group, then the filter will apply to the bowling group rather than the batting group
			bowler_group = ['bowler' , 'bls' , 'bowlingposition' , 'bowlingtype', 'side', 'match']	

			pure_batting_group = ['batsman', 'bts', 'team', 'venue', 'dismissal','matchtype','teamtype' , 'tournament', 'coach', 'battingposition', 'direction', 'spell','manager', 'year', 'inning', 'format', 'country' ,'cr', 'pship' , 'shottype' , 'line', 'length', 'condition']
			#the followings are the part of batting group, but they are not requirement for adding batting_part...ie if they belong to group2
			not_required = ['matchtype', 'condition','venue', 'tournament', 'format', 'battingposition', 'year', 'shottype' , 'line', 'length', 'direction', 'spell']
			
			#the match won and match lost queries require players and teams table no matter what
			#the teams table come with coaches managers and teamtypes table
			#Therefore this is how the following condition work
			#if pure batting group contains the user clicked first group in the group selection, or team or team type or coach or manager from the left hand side filter,
			#then add batsman part and rest of the part
			#else if only second group is in the pure batting group array, or any of the given filters are selected on the left hand side, 
			#then just add batsman part
			#also if the second group contains team or coach or manager or teamtype, then add their part
			#we dont need to worry about format or venue or tournament or so on as their part will be added in the latter checks
			
			build_query_match = batsman_part + team_part
			if ['coach', 'manager', 'teamtype'].include? group1 or ['coach', 'manager', 'teamtype'].include? group2 or teamtypekey[0] != '' or coachkey[0] != '' or managerkey[0] != ''
				build_query_match += teamtype_part + coach_part + manager_part
			end
						
			checked = 0
			batsman_group.each do |g|
				if checked == 0
					#if any of the right side batting filters present, and group1 is not teamagainst or coutryagainst
					#if (!group1[g].nil? or !group2[g].nil? or batsmankey[0] != '' or countrykey[0] != '' or countrykey1[0] != '' or playertypename[0] != '' or battingstylename[0] != '') 
					if (batsman_group.include? group1 or batsman_group.include? group2 or batsmankey[0] != '' or countrykey[0] != '' or playertypename[0] != '' or battingstylename[0] != '') 						
						build_query += batsman_part
						checked = 1
					end
				end
			end
			
			if !group1['pship'].nil? or !group2['pship'].nil? 
				build_query += pship_part
				build_query_match += pship_part
			end	


			#if (group1['countryagainst'].nil? and group2['countryagainst'].nil?) and (!group1['country'].nil? or !group2['country'].nil? or countrykey[0] != '')
			if ['country'].include? group1 or ['country'].include? group2 or countrykey[0] != ''
				build_query += country_part
				build_query_match += country_part
			end
			if !group1['format'].nil? or !group2['format'].nil? or formatkey[0] != ''
				build_query += format_part
				build_query_match += format_part
			end
			if !group1['tournament'].nil? or !group2['tournament'].nil? or tournamentkey[0] != ''
				build_query += tournament_part
				build_query_match += tournament_part
			end
			if !group1['venue'].nil? or !group2['venue'].nil? or venuekey[0] != ''
				build_query+= venue_part
				build_query_match += venue_part
			end
			if !group1['shottype'].nil? or !group2['shottype'].nil? or shottypekey[0] != ''
				build_query+= shottype_part
				build_query_match += shottype_part
			end
			if !group1['line'].nil? or !group2['line'].nil? or linekey1[0] != ''
				build_query+= line_part
				build_query_match += line_part
			end
			if !group1['length'].nil? or !group2['length'].nil? or lengthkey1[0] != ''
				build_query+= length_part
				build_query_match += length_part
			end
			
			#to add the match part either group1 or group2 should be match or pitch condition or the 
			#left hand pitch condition filter should be present to add the match part
			#but the metric should not be match won or lost because there is a separate query
			#down the line, which has hardcoded match match and match type part.
			#for query related with match won or match lost, the match part and the match type part 
			#is most required, so it  must be hardcoded in the query.
			#if  (metric!='mtchwon' and metric!='mtchlost') and (!group1['match'].nil? or !group2['match'].nil? or !group1['condition'].nil? or !group2['condition'].nil? or pitchconditionkey[0]!= '' or pitchconditionkey1[0]!= '' or !group1['matchtype'].nil? or !group2['matchtype'].nil? or !group2['countryagainst'].nil?  or matchtypekey[0] != '' or matchtypekey1[0] != '' )
			if  (metric!='mtchwon' and metric!='mtchlost') and (!group1['match'].nil? or !group2['match'].nil? or !group1['condition'].nil? or !group2['condition'].nil? or pitchconditionkey[0]!= '' or pitchconditionkey1[0]!= '' or !group1['matchtype'].nil? or !group2['matchtype'].nil?  or matchtypekey[0] != '' or matchtypekey1[0] != '' )
				build_query += match_part + matchtype_part
			end
			if !group1['dismissal'].nil? or !group2['dismissal'].nil?
				build_query += dismissal_part
				build_query_match += dismissal_part
			end
			build_query_match += bowler_part + teamagainst_part
			checked = 0
			bowler_group.each do |g|
				if checked == 0
					#the following if statement checks that if there is bowling group either in group1 or group2, then it will add bowler part
					#also if there are filters in the bowling filter section, then it will casue to add bowler part to the query
					#tournament, venue and format on the rigth hand side are not checked  because batting side and bowling side will have this common.
					if !group1['teamagainst'].nil? or !group2['teamagainst'].nil? or !group1['countryagainst'].nil? or !group2['countryagainst'].nil? or !group1[g].nil? or !group2[g].nil? or bowlerkey1[0] != '' or bowlingstylename1[0] != '' or bowlingtypename1[0] != '' or playertypename1[0] != ''  or countrykey1[0] != '' or teamkey1[0] != '' or managerkey1[0] != '' or coachkey1[0] != '' or teamtypekey1[0] != ''
						build_query += bowler_part
						checked = 1
					end
				end
			end
			#team against , match groups take teamagainst part and if the metric is matchwon or lost, the teamagainst part is there
			#but since there is already a check for team against, this is only a check for match
			#it means , add teamagainst_part if group is match, but the other group shoud not be teamagainst and metic should not be
			#match lost or won, otherwise the query part will be duplicated
			if (group1['teamagainst'].nil? or group2['teamagainst'].nil?) and ((!group1['match'].nil? or !group2['match'].nil?) and (metric!='mtchwon' and metric!='mtchlost'))
				build_query+= teamagainst_part 
			end
			if ((!group1['team'].nil? and group1['teamagainst'].nil?) or (!group2['team'].nil? and group2['teamagainst'].nil?) or !group1['teamtype'].nil? or !group2['teamtype'].nil? or !group1['coach'].nil? or !group2['coach'].nil? or !group1['manager'].nil? or !group2['manager'].nil? or  teamkey[0] != '' or teamtypekey[0] != '' or coachkey[0] != '' or managerkey[0] != '')
				build_query += team_part + teamtype_part + coach_part + manager_part
			end
			
			#check only for teams, coaches, managers and teamtypes from the right hand side, because the bowler filter has added the necessary joins before the current filter adds the team against joins
			if (group1['match'].nil? and group2['match'].nil?)and (!group1['teamagainst'].nil? or !group2['teamagainst'].nil? or teamkey1[0] != '' or managerkey1[0] != '' or coachkey1[0] != '' or teamtypekey1[0] != '')
				build_query += teamagainst_part + teamtypeagainst_part + coachagainst_part + manageragainst_part
			end

			#check only for country from the right hand side, because the bowler filter has added the necessary joins before the current filter adds the country against joins
			if  !group1['countryagainst'].nil? or !group2['countryagainst'].nil?  or countrykey1[0] != ''
				build_query += countryagainst_part
				build_query_match += countryagainst_part
			end	
			
			if teamtypekey1[0] != '' or coachkey1[0] != '' or managerkey1[0] != ''
				build_query_match += teamtypeagainst_part + coachagainst_part + manageragainst_part
			end			

	
			#build_query += where_always
			#matchkeys = Scorecard.find_by_sql('select distinct top '+matchcount.to_s+' matchkey from scorecards s '+ build_query + where_clause +' order by s.matchkey desc')
		    matchkeys = Scorecard.find_by_sql('select distinct s.matchkey from scorecards s '+ build_query + where_clause +' order by s.matchkey desc limit '+matchcount.to_s) 
			where_matchkeys = ' and s.matchkey in (' 
			matchkeys.each do |m| 
				where_matchkeys += m.matchkey.to_s + ','
			end
			where_matchkeys = where_matchkeys[0...-1]+')'
			
			build_query += where_always+ where_matchkeys
			#query variable for match lost
			build_query_match_lost = ''
			
			build_query_match_lost = ''
			if  pure_batting_group.include? group1
				build_query_match_lost = build_query_match + ' LEFT join (select * from matches where winnerkey<>-2) mat on tm.clientkey = mat.clientkey and tm.teamid <> mat.winnerkey ' +matchtype_part+ where_always	+ where_matchkeys			
				build_query_match += ' LEFT join (select * from matches where winnerkey<>-2) mat on tm.clientkey = mat.clientkey and tm.teamid = mat.winnerkey  ' + matchtype_part+ where_always + where_matchkeys	
			else
				#build query match lost is before than build query match because bqml uses bqm without where clause
				build_query_match_lost = build_query_match + ' LEFT join (select * from matches where winnerkey<>-2) mat on tm1.clientkey = mat.clientkey and tm1.teamid <> mat.winnerkey ' + matchtype_part+where_always + where_matchkeys	
				build_query_match += ' LEFT join (select * from matches where winnerkey<>-2) mat on tm1.clientkey = mat.clientkey and tm1.teamid = mat.winnerkey  ' + matchtype_part+where_always + where_matchkeys	
			end
			
			if batsmankey[0] != ''
				where_clause += where_batsmankeys
			end
			if countrykey[0] != ''
				where_clause += where_countrykeys
			end

			if playertypename[0] != ''
				where_clause += where_playertypekeys
			end
			if battingstylename[0] != ''
				where_clause += where_battingstylekeys
			end
			if formatkey[0] != ''
				where_clause += where_formatkeys
			end
			if tournamentkey[0] != ''
				where_clause += where_tournamentkeys
			end
			if venuekey[0] != ''
				where_clause += where_venuekeys
			end
			if teamkey[0] != ''
				where_clause += where_teamkeys
			end
			if teamtypekey[0] != ''
				where_clause += where_teamtypekeys
			end
			if coachkey[0] != ''
				where_clause += where_coachkeys
			end
			if managerkey[0] != ''
				where_clause += where_managerkeys
			end
			if matchtypekey[0] != ''
				where_clause += where_matchtypekeys
			end
			if battingposition[0] != ''
				where_clause += where_batpositionkeys
			end
			if shottypekey[0] != ''
				where_clause += where_shottypekeys
			end
			if shotdirectionkey[0] != ''
				where_clause += where_shotdirectionkeys
			end
			if pitchconditionkey[0] != ''
				where_clause += where_pitchconditionkeys
			end
			
			
			if bowlerkey1[0] != ''
				where_clause += where_bowlerkeys
			end
			if bowlingstylename1[0]!= ''
				where_clause += where_bowlingstylekeys1
			end
			if bowlingtypename1[0] != ''
				where_clause += where_bowlingtypekeys1
			end
			if countrykey1[0] != '' #and group1 != 'countryagainst' and group1 != 'teamagainst' and !bowler_group.include? group1
				where_clause += where_countrykeys1
			end
			if playertypename1[0] != ''
				where_clause += where_playertypekeys1
			end
			if formatkey1[0] != ''
				where_clause += where_formatkeys1
			end
			if tournamentkey1[0] != ''
				where_clause += where_tournamentkeys1
			end
			if venuekey1[0] != ''
				where_clause += where_venuekeys1
			end
			if teamkey1[0] != ''
				where_clause += where_teamkeys1
			end
			if teamtypekey1[0] != ''
				where_clause += where_teamtypekeys1
			end
			if coachkey1[0] != ''
				where_clause += where_coachkeys1
			end
			if managerkey1[0] != ''
				where_clause += where_managerkeys1
			end
			if matchtypekey1[0] != ''
				where_clause += where_matchtypekeys1
			end
			if bowlingposition1[0] != ''
				where_clause += where_bowlpositionkeys1
			end
			if linekey1[0] != ''
				where_clause += where_linekeys1
			end
			if lengthkey1[0] != ''
				where_clause += where_lengthkeys1
			end
			if bowlingsidekey1[0] != ''
				where_clause += where_bowlingsidekeys1
			end	
			if spellkey1[0] != ''
				where_clause += where_spellkeys1
			end
			if pitchconditionkey1[0] != ''
				where_clause += where_pitchconditionkeys1
			end			
			
			build_query += where_clause
			build_query_match += where_clause
			build_query_match_lost += where_clause
						
			_join = build_query
			
		


		else
			_group1['bts'] = 'p.battingstyle'
			_group1['bls'] = 'p1.bowlingstyle'
			_group1['team'] = 'tm1.teamname'
			_group1['teamagainst'] = 'tm.teamname'
			_group1['tournament'] = 't1.name'
			_group1['venue'] = 'venuename'
			_group1['matchtype'] = 'matchtype'
			_group1['teamtype'] = 'teamtype'	
			_group1['battingposition'] = 'battingposition'
			_group1['bowlingposition'] = 'bowlingposition'
			_group1['coach'] = 'c1.name'
			_group1['manager'] = 'm1.name'	
			_group1['bowlingtype'] = 'p1.bowlingtype'
			#_group1['year'] = 'datepart(yy, s.created_at)'
			_group1['year'] = 'cast(extract(year from s.created_at) as integer)'
			_group1['inning'] = 'inning'	
			_group1['format'] = 'f1.name'
			_group1['country'] = 'cn1.country'	
			_group1['countryagainst'] = 'cn.country'
			_group1['bowler'] = 'p1.fullname'
			_group1['batsman'] = 'p.fullname'
			_group1['dismissal'] = 'dismissaltype'
			_group1['cr'] = 'cr'
			_group1['pship'] = "case when currentstrikerkey<currentnonstrikerkey then p.fullname+'-'+p2.fullname else p2.fullname+'-'+p.fullname end"
			#_group1['match'] = 's.matchkey'
			_group1['match'] = "'vs '||tm.teamname"
			_group1['shottype'] = 'st.shottype'
			_group1['line'] = 'l.line'
			_group1['length'] = 'ln.length'
			_group1['side'] = "case when s.side=0 then 'RTW' ELSE 'OTW' END"
			_group1['direction'] = 's.direction'
			_group1['spell'] = 's.spell'
			_group1['condition'] = 'mat1.pitchcondition'
		
			_group2['bts'] = ',p.battingstyle'
			_group2['bls'] = ',p1.bowlingstyle'
			_group2['team'] = ',tm1.teamname'
			_group2['teamagainst'] = ',tm.teamname'
			_group2['tournament'] = ',t1.name'
			_group2['venue'] = ',venuename'
			_group2['matchtype'] = ',matchtype'
			_group2['teamtype'] = ',teamtype'	
			_group2['battingposition'] = ',battingposition'
			_group2['bowlingposition'] = ',bowlingposition'
			_group2['coach'] = ',c1.name'
			_group2['manager'] = ',m1.name'	
			_group2['bowlingtype'] = ',p1.bowlingtype'
			#_group2['year'] = ',datepart(yy, s.created_at)'
			_group2['year'] = ',cast(extract(year from s.created_at) as integer)'
			_group2['inning'] = ',inning'	
			_group2['format'] = ',f1.name'
			_group2['country'] = ',cn1.country'	
			_group2['countryagainst'] = ',cn.country'
			_group2['bowler'] = ',p1.fullname'
			_group2['batsman'] = ',p.fullname'
			_group2['dismissal'] = ',dismissaltype'
			_group2['cr'] = ',cr'
			_group2['pship'] = ",case when currentstrikerkey<currentnonstrikerkey then p.fullname+'-'+p2.fullname else p2.fullname+'-'+p.fullname end"
			#_group2['match'] = ',s.matchkey'
			_group2['match'] = ",'vs '||tm.teamname"
			_group2['shottype'] = ',st.shottype'
			_group2['line'] = ',l.line'
			_group2['length'] = ',ln.length'
			_group2['side'] = ",case when s.side=0 then 'RTW' ELSE 'OTW' END"
			_group2['direction'] = ',s.direction'
			_group2['spell'] = ',s.spell'
			_group2['condition'] = ',mat1.pitchcondition'
			

			batsman_part = ' inner join players p on p.clientkey = s.clientkey and p.id = s.batsmankey '
			nonstriker_part = ' inner join players p2 on p2.id = s.currentbowlerkey and p2.clientkey = s.clientkey '
			country_part = ' inner join countries cn1	on p1.countrykey = cn1.id	and p1.clientkey = cn1.clientkey '
			tournament_part = ' inner join tournaments t1	on s.clientkey = t1.clientkey and s.tournamentkey = t1.id '
			venue_part =' inner join venues v1 on s.clientkey = v1.clientkey and s.venuekey = v1.id '
			team_part = ' inner join teams tm1 on s.clientkey = tm1.clientkey and tm1.playerkey = s.currentbowlerkey ' 
			teamtype_part = ' inner join team_types tt1 on tm1.teamtypekey = tt1.id '
			coach_part= ' inner join coaches c1 on tm1.coachkey = c1.id	and tm1.clientkey = c1.clientkey '
			manager_part= ' inner join managers m1 on tm1.managerkey = m1.id and tm1.clientkey = m1.clientkey '
			match_part =' inner join matches mat on mat.id = s.matchkey and mat.clientkey = s.clientkey '
			matchtype_part = ' inner join match_types mt on mt.id = mat.matchtypekey '
			format_part = ' inner join formats f1 on f1.id = s.formatkey '
			
			bowler_part = ' inner join players p1 on s.currentbowlerkey = p1.id and s.clientkey = p1.clientkey '
			countryagainst_part = ' inner join countries cn on p.countrykey = cn.id and p.clientkey = cn.clientkey '
			teamagainst_part = ' inner join teams tm on s.clientkey = tm.clientkey and tm.playerkey = s.batsmankey '
			teamtypeagainst_part = ' inner join team_types tt on tm.teamtypekey = tt.id '
			coachagainst_part= ' inner join coaches c on tm.coachkey = c.id	and tm.clientkey = c.clientkey '
			manageragainst_part= ' inner join managers m on tm.managerkey = m.id and tm.clientkey = m.clientkey '
			dismissal_part = ' inner join dismissals d on d.id = s.outtypekey inner join players p3 on s.dismissedbatsmankey = p3.players and s.clientkey = p3.clientkey ' 
			pship_part = ' inner join players p2 on s.currentnonstrikerkey = p2.id and s.clientkey = p2.clientkey '
			length_part = ' inner join lengths ln on s.length = ln.id '
			dismissal_part = ' inner join dismissals d on d.id = s.outtypekey inner join players p3 on s.dismissedbatsmankey = p3.id and s.clientkey = p3.clientkey ' 
			shottype_part = ' inner join shottypes st on s.shottype = st.id '
			line_part = ' inner join lines l on s.line = l.id '
			length_part = ' inner join lengths ln on s.length = ln.id '

		   where_bowlerkeys1 =' and s.currentbowlerkey '+bowlerkeys1
		   where_countrykeys1 = ' and p1.countrykey ' + countrykeys1
		   where_bowlingstylekeys1 = ' and p1.bowlingstyle '+bowlingstylekeys1
		   where_bowlingtypekeys1 = ' and p1.bowlingtype '+bowlingtypekeys1
		   where_playertypekeys1 = ' and p1.playertype '+playertypekeys1
		   where_tournamentkeys1 = ' and s.tournamentkey '+tournamentkeys1
		   where_inningkeys1 =' and s.inning '+inningkeys1
		   where_bowlpositionkeys1 =' and s.bowlingposition '+bowlpositionkeys1
		   where_venuekeys1 =' and s.venuekey '+venuekeys1
		   where_teamtypekeys1 =' and tm1.teamtypekey '+teamtypekeys1
		   where_teamkeys1 =' and tm1.teamid '+teamkeys1
		   where_coachkeys1 =' and tm1.coachkey '+coachkeys1
		   where_managerkeys1 =' and tm1.managerkey '+managerkeys1
		   where_matchtypekeys1 =' and mt.id '+matchtypekeys1
		   where_formatkeys1 =' and s.formatkey '+formatkeys1
		   where_linekeys1 = ' and l.id '+linekeys1
		   where_lengthkeys1 = ' and l.id '+lengthkeys1
		   where_spellkeys1 = ' and s.spell '+spellkeys1
		   where_bowlingsidekeys1 = ' and s.side '+bowlingsidekeys1
		   where_pitchconditionkeys1 = ' and mat1.pitchcondition '+pitchconditionkeys1

		   where_batsmankeys =  ' and s.batsmankey '+batsmankeys
		   where_countrykeys = ' and p.countrykey ' + countrykeys
		   where_batpositionkeys =' and s.battingposition '+batpositionkeys
		   where_battingstylekeys = ' and p.battingstyle '+battingstylekeys
		   where_countryagainstkeys = ' and p.countrykey '+countrykeys
		   where_battingstylekeys =' and p.battingstyle '+battingstylekeys
		   where_playertypekeys =' and p.playertype '+playertypekeys
		   where_tournamentkeys =' and s.tournamentkey '+tournamentkeys
		   where_venuekeys =' and s.venuekey '+venuekeys
		   where_teamtypekeys =' and tm.teamtypekey '+teamtypekeys
		   where_teamkeys =' and tm.teamid '+teamkeys
		   where_teamagainstkeys =' and tm.teamid '+teamkeys
		   where_coachkeys =' and tm.coachkey '+coachkeys
		   where_managerkeys =' and tm.managerkey '+managerkeys
		   where_matchtypekeys =' and mt.id '+matchtypekeys
		   where_formatkeys =' and s.formatkey '+formatkeys
		   where_inningkeys =' and s.inning '+inningkeys
		   where_shottypekeys = ' and st.id '+shottypekeys
		   where_shotdirectionkeys = ' and s.direction '+shotdirectionkeys
		   where_pitchconditionkeys = ' and mat1.pitchcondition '+pitchconditionkeys
		   
		   where_always =' where s.clientkey = '+current_user.id.to_s + ' and ballnum between ' + ballnumber_betn			

			build_query = ''
			build_query_match = ''
			where_clause = ''
	
			against_group = ['batsman', 'bts', 'battingposition' ,'cr', 'pship' , 'battingstyle', 'teamagainst', 'countryagainst']
			batsman_group = ['batsman', 'bts', 'battingposition' ,'cr', 'pship' , 'battingstyle']
			bowler_group = ['bowler' , 'bls'  , 'bowlingtype', 'team', 'venue', 'matchtype', 'match', 'teamtype' , 'coach','manager', 'country']						

			pure_bowling_group = ['bowler' , 'bls'  , 'bowlingtype', 'team', 'venue', 'dismissal','matchtype', 'match','teamtype' , 'tournament', 'coach', 'bowlingposition', 'manager', 'year', 'inning', 'format', 'country' ,'cr', 'pship' , 'shottype' , 'line', 'length','side', 'direction', 'spell', 'condition']
			#the followings are the part of bowling group, but they are not required for adding bowling_part...ie if they belong to group2
			not_required = ['matchtype',  'condition', 'venue', 'tournament', 'format', 'bowlingposition', 'year', 'shottype' , 'line', 'length' ,'side','direction', 'spell']


			build_query_match = bowler_part + team_part
			if ['coach', 'manager', 'teamtype'].include? group1 or ['coach', 'manager', 'teamtype'].include? group2 or teamtypekey1[0] != '' or coachkey1[0] != '' or managerkey1[0] != ''
				build_query_match += teamtype_part + coach_part + manager_part
			end			
			
			checked = 0
			bowler_group.each do |g|
				if checked == 0
					#if any of the left side bowling filters present, and group1 is not teamagainst or coutryagainst
					if(bowler_group.include? group1 or bowler_group.include? group2 or !group1[g].nil? or !group2[g].nil? or bowlerkey1[0] != '' or bowlingstylename1[0] != '' or bowlingtypename1[0] != '' or  countrykey1[0] != '' or playertypename[0] != '')
						build_query += bowler_part
						checked = 1

					end
				end
			end
		
			if (group1['countryagainst'].nil? and group2['countryagainst'].nil?) and (!group1['country'].nil? or !group2['country'].nil? or countrykey1[0] != '')
				build_query += country_part
				build_query_match+= country_part
			end
			
			if !group1['format'].nil? or !group2['format'].nil? or formatkey1[0] != ''
				build_query += format_part
				build_query_match+= format_part
			end
			if !group1['tournament'].nil? or !group2['tournament'].nil? or tournamentkey1[0] != ''
				build_query += tournament_part
				build_query_match+= tournament_part
			end
			if !group1['venue'].nil? or !group2['venue'].nil? or venuekey1[0] != ''
				build_query+= venue_part
				build_query_match+= venue_part
			end
			if !group1['shottype'].nil? or !group2['shottype'].nil? or shottypekey[0] != ''
				build_query+= shottype_part
				build_query_match+= shottype_part
			end
			if !group1['line'].nil? or !group2['line'].nil? or linekey1[0] != ''
				build_query+= line_part
				build_query_match+= line_part
			end
			if !group1['length'].nil? or !group2['length'].nil? or lengthkey1[0] != ''
				build_query+= length_part
				build_query_match+= length_part
			end
			if  (metric!='mtchwon' and metric!='mtchlost') and (!group1['match'].nil? or !group2['match'].nil? or !group1['condition'].nil? or !group2['condition'].nil? or pitchconditionkey[0]!= '' or pitchconditionkey1[0]!= '' or !group1['matchtype'].nil? or !group2['matchtype'].nil?  or matchtypekey[0] != '' or matchtypekey1[0] != '' )
				build_query += match_part + matchtype_part
			end
			if (group1['teamagainst'].nil? and group2['teamagainst'].nil?) and (!group1['team'].nil? or !group2['team'].nil? or !group1['teamtype'].nil? or !group2['teamtype'].nil? or !group1['coach'].nil? or !group2['coach'].nil? or !group1['manager'].nil? or !group2['manager'].nil? or  teamkey1[0] != '' or teamtypekey1[0] != '' or coachkey1[0] != '' or managerkey1[0] != '')
				build_query += team_part + teamtype_part + coach_part + manager_part
			end
			if !group1['dismissal'].nil? or !group2['dismissal'].nil?
				build_query += dismissal_part
				build_query_match+= dismissal_part
			end
			build_query_match += batsman_part + teamagainst_part
			checked = 0
			batsman_group.each do |g|
				if checked == 0
					#if any of the right side batting filters present, and group1 is not teamagainst or coutryagainst
					#if (!group1[g].nil? or !group2[g].nil? or batsmankey[0] != '' or countrykey[0] != '' or countrykey1[0] != '' or playertypename[0] != '' or battingstylename[0] != '') 
					if (batsman_group.include? group1 or batsman_group.include? group2 or batsmankey[0] != '' or countrykey[0] != '' or playertypename[0] != '' or battingstylename[0] != '' or countrykey[0] != '' or teamkey[0] != '' or managerkey[0] != '' or coachkey[0] != '' or teamtypekey[0] != '' )					
						build_query += batsman_part
						checked = 1
					end
				end
			end
			#this is for match group only, but teamagainst and metric match won or lost should not be there
			#otherwise query part would get duplicated
			if (group1['teamagainst'].nil? or group2['teamagainst'].nil?) and ((!group1['match'].nil? or !group2['match'].nil?) and (metric!='mtchwon' and metric!='mtchlost'))
				build_query+= teamagainst_part 
			end
			if !group1['pship'].nil? or !group2['pship'].nil? 
				build_query += pship_part
				build_query_match+= pship_part
			end	
			#now in this check, match should not be there 
			if (group1['match'].nil? and group2['match'].nil?)and (!group1['teamagainst'].nil? or !group2['teamagainst'].nil? or teamkey[0] != '' or managerkey[0] != '' or coachkey[0] != '' or teamtypekey[0] != '')
				build_query += teamagainst_part + teamtypeagainst_part + coachagainst_part + manageragainst_part
			end
			if  !group1['countryagainst'].nil? or !group2['countryagainst'].nil?  or countrykey[0]!=''
				build_query += countryagainst_part
				build_query_match+= countryagainst_part
			end
			
		
						
			#build_query += where_always
			#matchkeys = Scorecard.find_by_sql('select distinct '+matchcount.to_s+' matchkey from scorecards s '+ build_query + where_clause +' order by s.matchkey desc')
			matchkeys = Scorecard.find_by_sql('select distinct s.matchkey from scorecards s '+ build_query + where_clause +' order by s.matchkey desc limit '+matchcount.to_s)

			where_matchkeys = ' and s.matchkey in (' 
			matchkeys.each do |m| 
				where_matchkeys += m.matchkey.to_s + ','
			end
			where_matchkeys = where_matchkeys[0...-1]+')'
			
			build_query += where_always+ where_matchkeys
			
			#query variable for match lost
			build_query_match_lost = ''
			
			build_query_match_lost = ''
			if  pure_bowling_group.include? group1
				build_query_match_lost = build_query_match + ' LEFT join (select * from matches where winnerkey<>-2) mat on tm1.clientkey = mat.clientkey and tm1.teamid <> mat.winnerkey ' + matchtype_part+where_always	+ where_matchkeys			
				build_query_match += ' LEFT join (select * from matches where winnerkey<>-2) mat on tm1.clientkey = mat.clientkey and tm1.teamid = mat.winnerkey ' +matchtype_part+ where_always+ where_matchkeys
			else
				#build query match lost is before than build query match because bqml uses bqm without where clause
				build_query_match_lost = build_query_match + ' LEFT join (select * from matches where winnerkey<>-2) mat on tm1.clientkey = mat.clientkey and tm1.teamid <> mat.winnerkey ' +matchtype_part+ where_always+ where_matchkeys	
				build_query_match += ' LEFT join (select * from matches where winnerkey<>-2) mat on tm1.clientkey = mat.clientkey and tm1.teamid = mat.winnerkey ' +matchtype_part+ where_always+ where_matchkeys
			end			
			
			
			if batsmankey[0] != ''
				where_clause += where_batsmankeys
			end
			if countrykey[0] != ''
				where_clause += where_countrykeys
			end
=begin
			if countrykey[0] != '' and (group1 == 'countryagainst'  or group1 == 'teamagainst') and against_group.include? group1
				where_clause += where_countryagainstkeys
			end
			if countrykey[0] != '' and group1 != 'countryagainst' and group1 != 'teamagainst' and batsman_group.include? group1
				where_clause += where_countryagainstkeys
			end
=end
			if playertypename[0] != ''
				where_clause += where_playertypekeys
			end
			if battingstylename[0] != ''
				where_clause += where_battingstylekeys
			end
			if formatkey[0] != ''
				where_clause += where_formatkeys
			end
			if tournamentkey[0] != ''
				where_clause += where_tournamentkeys
			end
			if venuekey[0] != ''
				where_clause += where_venuekeys
			end
			if teamkey[0] != ''
				where_clause += where_teamagainstkeys
			end
			if teamtypekey[0] != ''
				where_clause += where_teamtypekeys
			end
			if coachkey[0] != ''
				where_clause += where_coachkeys
			end
			if managerkey[0] != ''
				where_clause += where_managerkeys
			end
			if matchtypekey[0] != ''
				where_clause += where_matchtypekeys
			end
			if battingposition[0] != ''
				where_clause += where_batpositionkeys
			end
			if shottypekey[0] != ''
				where_clause += where_shottypekeys
			end
			if shotdirectionkey[0] != ''
				where_clause += where_shotdirectionkeys
			end
			if pitchconditionkey[0] != ''
				where_clause += where_pitchconditionkeys
			end
			
			
			
			if bowlerkey1[0] != ''
				where_clause += where_bowlerkeys1
			end
			if bowlingstylename1[0]!= ''
				where_clause += where_bowlingstylekeys1
			end
			if bowlingtypename1[0] != ''
				where_clause += where_bowlingtypekeys1
			end
			if countrykey1[0] != ''
				where_clause += where_countrykeys1
			end

			if playertypename1[0] != ''
				where_clause += where_playertypekeys1
			end
			if formatkey1[0] != ''
				where_clause += where_formatkeys1
			end
			if tournamentkey1[0] != ''
				where_clause += where_tournamentkeys1
			end
			if venuekey1[0] != ''
				where_clause += where_venuekeys1
			end
			if teamkey1[0] != '' 
				where_clause += where_teamkeys1
			end
			if teamtypekey1[0] != ''
				where_clause += where_teamtypekeys1
			end
			if coachkey1[0] != ''
				where_clause += where_coachkeys1
			end
			if managerkey1[0] != ''
				where_clause += where_managerkeys1
			end
			if matchtypekey1[0] != ''
				where_clause += where_matchtypekeys1
			end
			if bowlingposition1[0] != ''
				where_clause += where_bowlpositionkeys1
			end
			if linekey1[0] != ''
				where_clause += where_linekeys1
			end
			if lengthkey1[0] != ''
				where_clause += where_lengthkeys1
			end	
			if bowlingsidekey1[0] != ''
				where_clause += where_bowlingsidekeys1
			end		
			if spellkey1[0] != ''
				where_clause += where_spellkeys1
			end
			if pitchconditionkey1[0] != ''
				where_clause += where_pitchconditionkeys1
			end
			
			build_query += where_clause
			build_query_match += where_clause
			build_query_match_lost += where_clause
			
			_join = build_query

		end
		
		
		###################################   bbr  bbb   dbx dbr dbb sql string variable definitions #############################################	
			bbr = '
				WITH 
				CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey, inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', runs from '+scorecards+' s '+ _join + '
					)A
					where runs = 0
				),
				CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A._rank = B._rank+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)

				,
				CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A._rank+1 = B._rank and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				),
				_CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey,inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', runs from '+scorecards+' s '+ _join + '
					)A
					where runs > 0
				),
				_CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM _CTE A LEFT OUTER JOIN _CTE B
					  ON A._rank = B._rank+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)

				,
				_CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM _CTE A LEFT OUTER JOIN _CTE B
					  ON A._rank+1 = B._rank and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)
			
				SELECT X.grp1 '+(!_group2[group2].nil? ? ' ,X.grp2':'')+', tot/(1.0*(cnt+coalesce(_adds,0))) as val
				from
				(
				select  t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+', SUM(t2._rank - t1._rank+1) tot,(1.0*count(t2._rank - t1._rank+1)) cnt
				from CTE2 t2
				inner join CTE1 t1 on t2._order = t1._order
				group by t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+'
				)X
				LEFT join 
				(
				select grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+', _adds
				from
				(
					select SUM(A._rank - B._rank) as _adds,A.grp1 '+(!_group2[group2].nil? ? ' ,A.grp2':'')+'
					from
					(
						select c1._rank, c1.grp1 '+(!_group2[group2].nil? ? ' ,c1.grp2':'')+',ROW_NUMBER() OVER( ORDER BY c1._rank)_order 
						 from _CTE2 c1
						left outer join _CTE2 c2 on c1._rank = c2._rank+1
					)A
					INNER JOIN 
					(
						select c1._rank, c1.grp1 '+(!_group2[group2].nil? ? ' ,c1.grp2':'')+',ROW_NUMBER() OVER( ORDER BY c1._rank)_order
						from _CTE1 c1
						left outer join _CTE1 c2 on c1._rank+1 = c2._rank
					)B ON A._order = B._order
					group by a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+'
				)y 
				)z ON X.grp1 = z.grp1 '+(!_group2[group2].nil? ? ' and x.grp2 = Z.grp2':'')+' 
			'	

			bbb = '
				WITH 
				CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey,inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', fours, sixes, runs from '+scorecards+' s '+ _join + '
					)A
					where fours +sixes = 0
				),
				CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A._rank = B._rank+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)

				,
				CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A._rank+1 = B._rank and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				),
				_CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey,inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', fours, sixes, runs from '+scorecards+' s '+ _join + '
					)A
					where fours > 0 or sixes >0 
				),
				_CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM _CTE A LEFT OUTER JOIN _CTE B
					  ON A._rank = B._rank+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)

				,
				_CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM _CTE A LEFT OUTER JOIN _CTE B
					  ON A._rank+1 = B._rank and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)
			
				SELECT X.grp1 '+(!_group2[group2].nil? ? ' ,X.grp2':'')+', tot/(1.0*(cnt+coalesce(_adds,0))) as val
				from
				(
				select  t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+', SUM(t2._rank - t1._rank+1) tot,(1.0*count(t2._rank - t1._rank+1)) cnt
				from CTE2 t2
				inner join CTE1 t1 on t2._order = t1._order
				group by t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+'
				)X
				LEFT join 
				(
				select grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+', _adds
				from
				(
					select SUM(A._rank - B._rank) as _adds,A.grp1 '+(!_group2[group2].nil? ? ' ,A.grp2':'')+'
					from
					(
						select c1._rank, c1.grp1 '+(!_group2[group2].nil? ? ' ,c1.grp2':'')+',ROW_NUMBER() OVER( ORDER BY c1._rank)_order 
						 from _CTE2 c1
						left outer join _CTE2 c2 on c1._rank = c2._rank+1
					)A
					INNER JOIN 
					(
						select c1._rank, c1.grp1 '+(!_group2[group2].nil? ? ' ,c1.grp2':'')+',ROW_NUMBER() OVER( ORDER BY c1._rank)_order
						from _CTE1 c1
						left outer join _CTE1 c2 on c1._rank+1 = c2._rank
					)B ON A._order = B._order
					group by a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+'
				)y 
				)z ON X.grp1 = z.grp1 '+(!_group2[group2].nil? ? ' and x.grp2 = Z.grp2':'')+' 
			'	
			dbx = '
				WITH 
				CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey,inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', wides+noballs+byes+legbyes as extras, runs from '+scorecards+' s '+ _join + '
					)A
					where extras = 0
				),
				CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A._rank = B._rank+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)

				,
				CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A._rank+1 = B._rank and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				),
				_CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey,inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', wides+noballs+byes+legbyes as extras, runs from '+scorecards+' s '+ _join + '
					)A
					where extras >0
				),
				_CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM _CTE A LEFT OUTER JOIN _CTE B
					  ON A._rank = B._rank+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)

				,
				_CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A._rank, ROW_NUMBER() OVER( ORDER BY a._rank) _order
					FROM _CTE A LEFT OUTER JOIN _CTE B
					  ON A._rank+1 = B._rank and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B._rank IS NULL
				)
			
				SELECT X.grp1 '+(!_group2[group2].nil? ? ' ,X.grp2':'')+', tot/(1.0*(cnt+coalesce(_adds,0))) as val
				from
				(
				select  t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+', SUM(t2._rank - t1._rank+1) tot,(1.0*count(t2._rank - t1._rank+1)) cnt
				from CTE2 t2
				inner join CTE1 t1 on t2._order = t1._order
				group by t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+'
				)X
				LEFT join 
				(
				select grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+', _adds
				from
				(
					select SUM(A._rank - B._rank) as _adds,A.grp1 '+(!_group2[group2].nil? ? ' ,A.grp2':'')+'
					from
					(
						select c1._rank, c1.grp1 '+(!_group2[group2].nil? ? ' ,c1.grp2':'')+',ROW_NUMBER() OVER( ORDER BY c1._rank)_order 
						 from _CTE2 c1
						left outer join _CTE2 c2 on c1._rank = c2._rank+1
					)A
					INNER JOIN 
					(
						select c1._rank, c1.grp1 '+(!_group2[group2].nil? ? ' ,c1.grp2':'')+',ROW_NUMBER() OVER( ORDER BY c1._rank)_order
						from _CTE1 c1
						left outer join _CTE1 c2 on c1._rank+1 = c2._rank
					)B ON A._order = B._order
					group by a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+'
				)y 
				)z ON X.grp1 = z.grp1 '+(!_group2[group2].nil? ? ' and x.grp2 = Z.grp2':'')+' 
			'

			cnonstrike = '
				WITH 
				CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey,inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', runs from '+scorecards+' s '+ _join + '
					)A
				),
				CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A.ballnum, ROW_NUMBER() OVER( ORDER BY a.ballnum) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A.ballnum = B.ballnum+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B.ballnum IS NULL
				)

				,
				CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A.ballnum, ROW_NUMBER() OVER( ORDER BY a.ballnum) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A.ballnum+1 = B.ballnum and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B.ballnum IS NULL
				)
			
				SELECT X.grp1 '+(!_group2[group2].nil? ? ' ,X.grp2':'')+', tot/(1.0*cnt) as val
				from
				(
				select  t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+', SUM(t2.ballnum - t1.ballnum+1) tot,(1.0*count(t2.ballnum - t1.ballnum+1)) cnt
				from CTE2 t2
				inner join CTE1 t1 on t2._order = t1._order
				group by t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+'
				)X
			'	

			cstrike = '
				WITH 
				CTE AS 
				(
					select _rank, ballnum, grp1 '+(!_group2[group2].nil? ? ' ,grp2':'')+' , runs as val
					from
					(
					select rank() over (order by  s.matchkey,inning,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+' , ballnum) as _rank, 
						   ballnum, '+_group1[group1]+' as grp1 '+(!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', runs from '+scorecards+' s '+ _join + '
					)A
				),
				CTE1 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A.ballnum, ROW_NUMBER() OVER( ORDER BY a.ballnum) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A.ballnum = B.ballnum+1 and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B.ballnum IS NULL
				)

				,
				CTE2 AS
				(
					SELECT  a.grp1 '+(!_group2[group2].nil? ? ' ,a.grp2':'')+',A.ballnum, ROW_NUMBER() OVER( ORDER BY a.ballnum) _order
					FROM CTE A LEFT OUTER JOIN CTE B
					  ON A.ballnum+1 = B.ballnum and  a.grp1 = b.grp1 '+(!_group2[group2].nil? ? ' and a.grp2 = b.grp2':'')+'
					WHERE B.ballnum IS NULL
				)
			
				SELECT X.grp1 '+(!_group2[group2].nil? ? ' ,X.grp2':'')+', tot/(1.0*cnt) as val
				from
				(
				select  t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+', SUM(t2.ballnum - t1.ballnum+1) tot,(1.0*count(t2.ballnum - t1.ballnum+1)) cnt
				from CTE2 t2
				inner join CTE1 t1 on t2._order = t1._order
				group by t2.grp1 '+(!_group2[group2].nil? ? ' ,t2.grp2':'')+'
				)X
			'			
		############################################### end of variable definitions #####################################################3	
	
		
		if metric == 'runs'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:runs)
			#@chartdata = Scorecard.joins(_joins[group]['join']).group('battingposition, bowlingposition').sum(:runs)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(runs) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))

			#logger.info bbr
		elsif metric == 'avg'
			#@avgbybts = Scorecard.joins(_joins[group]['join']).select('case when sum(wicket)=0 then 0 else sum(runs)/sum(wicket) end as avg, '+_joins[group]['group'] +' as grp').group(_joins[group]['group'])
			#@chartdata = {}
			#@avgbybts.each do |a|
			#	@chartdata[a.grp] = a.avg	
			#end
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', case when sum(wicket)=0 then 0 else sum(runs)/sum(wicket) end as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))

		elsif metric == 'sr'
			#@srbybts = Scorecard.joins(_joins[group]['join']).select('case when sum(ballsfaced)=0 then 0 else sum(runs)/(1.0*sum(ballsfaced))*100 end as sr, '+_joins[group]['group']+' as grp').group(_joins[group]['group'])
			#@chartdata = {}
			#@srbybts.each do |a|
			#	@chartdata[a.grp] = a.sr
			#end
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', case when sum(ballsfaced)=0 then 0 else sum(runs)/(1.0*sum(ballsfaced))*100 end as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'dsmsl'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:wicket)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(wicket) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'bbh'
			#@bbhbybts = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).select('case when count(ballsbeforerun)=0 then 0 else sum(ballsbeforerun)/(count(ballsbeforerun)*1.0) end as bbh,'+_joins[group]['group']+' as grp')
			#@chartdata = {}
			#@bbhbybts.each do |a|
			#	@chartdata[a.grp] = a.bbh
			#end
			@chartdata = Scorecard.find_by_sql(bbr)
			#@client = current_user
			#ClientMailer.Error_Delivery(bbr, @client, 'bbh').deliver
		elsif metric == 'bbb'
			#@bbbbybts = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).select('case when count(ballsbeforeboundary)=0 then 0 else sum(ballsbeforeboundary)/(count(ballsbeforeboundary)*1.0) end as bbb,'+_joins[group]['group']+' as grp')
			#@chartdata = {}
			#@bbbbybts.each do |a|
			#	@chartdata[a.grp] = a.bbb
			#end
			@chartdata = Scorecard.find_by_sql(bbb)
		elsif metric == 'dbx'
			@chartdata = Scorecard.find_by_sql(dbx)
		elsif metric == 'c_strike'
			@chartdata = Scorecard.find_by_sql(cstrike)
		elsif metric == 'c_nonstrike'
			@chartdata = Scorecard.find_by_sql(cnonstrike)
		elsif metric == 'inns'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).count('distinct matchkey')	
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', count(distinct matchkey) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'zero'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:zeros)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(zeros) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'one'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:ones)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(ones) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))

		elsif metric == 'two'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:twos)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(twos) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'three'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:threes)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(threes) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'four'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:fours)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(fours) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		
		elsif metric == 'six'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:sixes)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(sixes) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'wides'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:wides)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(wides) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'noballs'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:noballs)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(noballs) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'byes'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:byes)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(byes) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'legbyes'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum(:legbyes)
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(legbyes) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		
		elsif metric == 'extras'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum('wides+noballs+byes+legbyes')		
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(wides+noballs+byes+legbyes) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'econ'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum('wides+noballs+byes+legbyes')		
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(wides+noballs+byes+legbyes+runs)/(SUM(ballsdelivered)/6+SUM(ballsdelivered)%6/6.0) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'bavg'
			#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum('wides+noballs+byes+legbyes')		
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(wides+noballs+byes+legbyes+runs)/(1.0*SUM(wicket)) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))		
		elsif metric == 'fifties'
			if group1=='batsman' or group2=='batsman'
				#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum('wides+noballs+byes+legbyes')		
				@chartdata = Scorecard.find_by_sql('select grp1 '+ (!_group2[group2].nil? ? ',grp2':'')+', count(distinct val) as val from (Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', s.matchkey, case when sum(runs)>=50 and sum(runs)<100 then 1 end as val from '+scorecards+' s '+ _join + ' group by s.matchkey,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+')A group by grp1'+(!_group2[group2].nil? ? ',grp2':''))
			end
		elsif metric == 'hundreds'
			if group1=='batsman' or group2=='batsman'
				#@chartdata = Scorecard.joins(_joins[group]['join']).group(_joins[group]['group']).sum('wides+noballs+byes+legbyes')		
				@chartdata = Scorecard.find_by_sql('select grp1 '+ (!_group2[group2].nil? ? ',grp2':'')+', count(distinct val) as val from (Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', s.matchkey, case when sum(runs)>=100 then 1 end as val from '+scorecards+' s '+ _join + ' group by s.matchkey,'+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:'')+')A group by grp1'+(!_group2[group2].nil? ? ',grp2':''))
			end
		elsif metric == 'mtchwon'
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', count(distinct mat.id) as val from '+scorecards+' s '+ build_query_match+ '  group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'mtchlost'
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', count(distinct mat.id) as val from '+scorecards+' s '+ build_query_match_lost+ '  group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'noofdels'
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(ballsdelivered) as val from '+scorecards+' s '+ _join + ' group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		elsif metric == 'noofshots'
			@chartdata = Scorecard.find_by_sql('Select '+_group1[group1]+' as grp1 '+ (!_group2[group2].nil? ? _group2[group2]+' as grp2':'')+', sum(ballsdelivered) as val from '+scorecards+' s '+ _join + ' and runs>0  group by '+_group1[group1]+(!_group2[group2].nil? ? _group2[group2]:''))
		end
		
		@chartdata = @chartdata == []? nil:@chartdata
		
		@data = Scorecard.getChartData(@chartdata, group1, group2, metric)
		
		respond_to do |format|
		  #format.json {render json:@chartdata}
		  format.json {render json:@data}
		  format.pdf 
		end
	rescue => e
		 @message = e.message
		 @client = current_user
		 @caught_at = 'analysis#generate'
		 ClientMailer.Error_Delivery(@message, @client, @caught_at).deliver
	end

  end
  
end