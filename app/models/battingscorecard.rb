class Battingscorecard < ActiveRecord::Base
  attr_accessible :ballsfaced, :batsman, :batsmankey, :bowler, :bowlerkey,:clientkey, :fielder, :fielderkey, :fives, :format, :formatkey, :fours, :hilite, :inning, :match, :matchkey, :nonstrikerkey, :ones, :outtypekey, :outtype, :played, :position, :runs, :sixes, :strikerate, :teamname,:threes, :tournament, :tournamentkey, :twos, :zeros
end
