class Bowlingscorecard < ActiveRecord::Base
  attr_accessible :bowled, :bowler, :bowlerkey, :byes, :clientkey, :economy, :fives, :format, :formatkey, :fours, :hilite, :inning, :last_run, :legbyes, :maidens, :match, :matchkey, :noballs, :ones, :overs, :position, :runs, :sixes, :teamname, :threes, :tournament, :tournamentkey, :twos, :wickets, :wides, :zeros, :totalovers, :wicketsgone
end
