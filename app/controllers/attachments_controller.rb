require 'nokogiri'

class AttachmentsController < ApplicationController
	def index		
	end

    def show
        @attachment = Attachment.find(params[:id])
        send_data @attachment.data, :filename => @attachment.filename, :type => @attachment.content_type
    end
	
	def new
		@attachment = Attachment.new
		@tournaments = Tournament.where('clientkey=?', current_user.id).collect {|t| [ t.name,t.id]}
		@tournaments << ['', -2]
		@tournaments = @tournaments.sort_by{|k| k[0]}
		
		@venues = Venue.where('clientkey=?', current_user.id).collect {|t| [ t.venuename,t.id]}
		@venues << ['', -2]
		@venues = @venues.sort_by{|k| k[0]}
		
		@matches = Match.find_by_sql("select distinct m.id, t.teamname||' - '||t1.teamname as match from matches m inner join (select distinct teamid, clientkey, teamname from teams) t on m.teamidone=t.teamid and m.clientkey = t.clientkey inner join (select distinct teamid, clientkey, teamname from teams) t1 on m.teamidtwo=t1.teamid and m.clientkey = t1.clientkey where m.clientkey = "+current_user.id.to_s+ " order by m.id desc").collect {|m| [ m.match,m.id]}
		@matches << ['', -2]
		@matches = @matches.sort_by{|k| k[0]}
		
		respond_to do |format|
		  format.html # new.html.erb
		end
	end

    def create     
        return if params[:attachment].blank?
        @attachment = Attachment.new
        @attachment.uploaded_file = params[:attachment]
		
        if @attachment.save
			doc = Nokogiri::HTML(@attachment.data)
			table = doc.xpath('//table').max_by {|table| table.xpath('.//tr').length}

			rows = table.search('tr')[1..-1]
			rows.each do |row|

				cells = row.search('td//text()').collect {|text| CGI.unescapeHTML(text.to_s.strip)}
				wides = cells[27]
				noballs = cells[28]
				byes = cells[29]
				legbyes = cells[30]
				External.create!({_over: cells[7], ballnum:cells[8],striker:cells[10], nonstriker:cells[13], bowler:cells[16], fielder:cells[51], runs:cells[25], extras:cells[26],wides:wides, noballs:noballs, byes:byes, legbyes:legbyes, balltype:cells[8], shottype:cells[9], line:cells[10], length:cells[11], uncomfortable:cells[15], wicket:cells[16],beaten:cells[17], releaseshot: cells[18], bowlingend:cells[20], bowlingside:cells[21]})
			end
=begin			
			externals = External.all
			
			spells = {}
			bowler_overs = {}
			bowlers = External.select('bowler, _over')
			bowlers_n_positions = {}
			unique_bowlers = []
			position = 1
			bowlers.each do |b|
				if !unique_bowlers.include? b.bowler
					unique_bowlers << b.bowler
					bowlers_n_positions[b.bowler] =  position
					position = position+1
					
					temp = []
					overs = External.where('bowler = ?', b.bowler).select('distinct bowler, _over')
					overs.each do |o|
						temp << o._over
					end
					bowler_overs[b.bowler] = temp.sort				
				end
			end
			
			unique_bowlers.each do |b|
				_temp = [1]
				counter = 1
				current_over = bowler_overs[b][0]
				bowler_overs[b][1..-1].each do |o|
					
					if o == current_over+2
						spells[o] = _temp
						current_over = o
					else
						counter = counter+1
						spells[o] = _temp
						current_over = o
					end
					
				end
				
			end
			
			all_strikers_and_non_strikers = []
			externals.each do |e|
				all_strikers_and_non_strikers << e.striker << e.nonstriker
			end
			unique_batsmen = [] 
			batsmen_n_positions = {}
			position = 1
			all_strikers_and_non_strikers.each do |b|
				if !unique_batsmen.include? b
					unique_batsmen << b
					batsmen_n_positions[b] =  position
					position = position+1
				end
			end
			
			@match = Match.find_by_id_and_clientkey(params[:matchkey], current_user.id)
			teamidone = @match.teamidone
			teamidtwo = @match.teamidtwo
			
			lines = {}
			lines['OutsideOffStump'] = 1
			lines['Middle'] = 2
			lines['OffStump'] = 2
			lines['LegStump'] = 3
			lines['OutsideLegStump'] = 4
			
			lengths = {}
			lengths['YorkerLength'] = 1
			lengths['FullLength'] = 2
			lengths['GoodLength'] = 3
			lengths['ShortOfGoodLength'] = 4
			lengths['ShortLength'] = 5
			
			shottypes = {}
			
			shottypes['Forward Defence'] = 9
			shottypes['Cut Shot'] = 52
			shottypes['Backfoot Defence'] = 3
			shottypes['Frontfoot CoverDrive'] = 8
			shottypes['Backfoot CoverDrive'] = 5
			shottypes['Square Drive'] = 53
			shottypes['Straight Drive'] = 54
			shottypes['On Drive'] = 44
			shottypes['Off Drive'] = 45
			shottypes['Flick'] = 12
			shottypes['Glance'] = 13
			shottypes['Edge'] = 10
			shottypes['Hook'] = 15
			shottypes['Late Cut'] = 16
			shottypes['Pull Shot'] = 47
			shottypes['Lofted'] = 27
			shottypes['Left Alone'] = 17
			shottypes['Sweep Shot'] = 55
			shottypes['Reverse Sweep'] = 48
			shottypes['Switch Hit'] = 56
			shottypes['Forward Defence'] = 9
			shottypes['Beaten'] = 7
			shottypes['Paddle Sweep'] = 46
			shottypes['Uncomfortable'] = 28  #represents all mishits and edge
			
			
			

			formatkey = Match.where('clientkey=? and id=?', current_user.id, params[:matchkey]).select('formatkey')[0].formatkey
			
			externals.each do |e|
				clientkey = current_user.id
				ballsdelivered = e.wides+e.noballs == 0? 1:0
				ballsfaced = e.wides ==0? 1:0
				batsmankey = Player.where('clientkey=? and fullname=? and formatkey=?', clientkey, e.striker, formatkey).select('distinct playerid')[0].playerid
				battingendkey = -2
				battingposition = batsmen_n_positions[e.striker]
				currentbowlerkey = Player.where('clientkey=? and fullname=? and formatkey=?', clientkey, e.bowler, formatkey).select('distinct playerid')[0].playerid
				bowlerkey = e.wicket == 'Yes'? currentbowlerkey:-2
				bowlingendkey = -2
				bowlingposition = bowlers_n_positions[e.bowler]
				byes = e.byes
				currentstrikerkey = batsmankey
				currentnonstrikerkey = Player.where('clientkey=? and fullname=? and formatkey=?', clientkey, e.nonstriker, formatkey).select('distinct playerid')[0].playerid
				eights = e.runs == 8? 1:0
				fielderkey = -2 #e.wicket == 'Yes'? Player.where('clientkey=? and fullname=? and format=?', clientkey, e.fielder, params[:formatkey]).select('distinct playerid'):-2
				fives = e.runs == 5? 1:0
				formatkey = formatkey
				fours = e.runs == 4? 1:0
				inning = Match.find(params[:matchkey]).nil? ? 1:2
				legbyes = e.legbyes
				maiden = 0
				matchkey = params[:matchkey]
				noballs = e.noballs
				ones = e.runs == 1? 1:0
				others = e.runs > 8? 1:0
				outtypekey = -2 #find how out
				outbywk = -2 #find the fielder
				runs = e.runs
				sevens = e.runs == 7? 1:0
				sixes = e.runs == 6? 1:0
				teamidone = teamidone
				teamtwoid = teamidtwo
				threes = e.runs == 3? 1:0
				tournamentkey = params[:tournamentkey]
				twos = e.runs == 2? 1:0
				venuekey = params[:venuekey]
				wicket = e.wicket == 'Yes'? 1:0
				wides = e.wides
				zeros = e.runs == 0? 1:0
				dismissedbatsmankey = batsmankey  #findout from raman
				line = lines[e.line]
				length = lengths[e.length]
				if e.beaten == 'Yes'
					shottype = shottypes['Beaten']
				elsif e.uncomfortable == 'Yes' and e.beaten == 'No'
					shottype = shottypes['Uncomfortable']
				else
					shottype = shottypes[e.shottype]
				end
				side = e.bowlingside == 'Over' ? 1:2
				over = e._over
				ballnum = e.wides+e.noballs != 0? e._over-1 * 6 + e.ballnum-1:e._over-1 * 6 + e.ballnum
				spell = spells[e._over]
				
				
				#Scorecard.create!({clientkey:clientkey, ballsdelivered:ballsdelivered, ballsfaced:ballsfaced,batsmankey:batsmankey,	battingendkey:battingendkey,battingposition:battingposition,currentbowlerkey:currentbowlerkey,bowlerkey:bowlerkey,bowlingendkey:bowlingendkey,bowlingposition:bowlingposition,byes:byes,currentstrikerkey:currentstrikerkey,currentnonstrikerkey:currentnonstrikerkey,eights:eights,fielderkey:fielderkey,fives:fives,formatkey:formatkey,fours:fours,inning:inning,legbyes:legbyes,maiden:maiden,matchkey:matchkey,noballs:noballs,ones:ones,others:others,outtypekey:outtypekey,outbywk:outbywk,runs:runs,sevens:sevens,sixes:sixes,teamidone:teamidone,teamtwoid:teamtwoid,threes:threes,tournamentkey:tournamentkey,twos:twos,venuekey:venuekey,wicket:wicket,wides:wides,zeros:zeros,dismissedbatsmankey:dismissedbatsmankey,line:line,length:length,shottype:shottype,side:side,over:over,ballnum:ballnum,spell:spell})
			end	

=end	
            flash[:notice] = "Thank you for your submission..."
            redirect_to matches_url
        else
            flash[:error] = "There was a problem submitting your attachment."
            render :action => "new"
        end
    end
end
