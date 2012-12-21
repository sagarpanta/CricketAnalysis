# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121221045513) do

  create_table "battings", :force => true do |t|
    t.integer  "teamkey"
    t.integer  "tournamentkey"
    t.integer  "matchkey"
    t.integer  "battingendkey"
    t.integer  "batsmankey"
    t.integer  "bowlerkey"
    t.integer  "runs"
    t.integer  "zeros"
    t.integer  "ones"
    t.integer  "twos"
    t.integer  "threes"
    t.integer  "fours"
    t.integer  "fives"
    t.integer  "sixes"
    t.integer  "other"
    t.integer  "position"
    t.integer  "outtypekey"
    t.string   "fielderkey"
    t.string   "integer"
    t.boolean  "outbywk"
    t.integer  "formatkey"
    t.integer  "dotconversionkey"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "bowling_styles", :force => true do |t|
    t.string   "style"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bowlings", :force => true do |t|
    t.integer  "teamkey"
    t.integer  "tournamentkey"
    t.integer  "matchkey"
    t.integer  "bowlingendkey"
    t.integer  "batsmankey"
    t.integer  "bowlerkey"
    t.boolean  "ballsdelivered"
    t.integer  "zeros"
    t.integer  "ones"
    t.integer  "twos"
    t.integer  "threes"
    t.integer  "fours"
    t.integer  "fives"
    t.integer  "sixes"
    t.integer  "other"
    t.integer  "wides"
    t.integer  "noballs"
    t.integer  "legbyes"
    t.integer  "byes"
    t.integer  "wicketkeeperkey"
    t.integer  "wicket"
    t.integer  "outtypekey"
    t.integer  "fielderkey"
    t.boolean  "outbywk"
    t.integer  "formatkey"
    t.integer  "position"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "clientconfigs", :force => true do |t|
    t.integer  "clientkey"
    t.integer  "runs"
    t.integer  "avg"
    t.integer  "sr"
    t.integer  "econ"
    t.integer  "bavg"
    t.integer  "dsmsl"
    t.integer  "bbh"
    t.integer  "bbb"
    t.integer  "dbx"
    t.integer  "mtchwon"
    t.integer  "mtchlost"
    t.integer  "inns"
    t.integer  "zero"
    t.integer  "one"
    t.integer  "two"
    t.integer  "three"
    t.integer  "four"
    t.integer  "five"
    t.integer  "six"
    t.integer  "wides"
    t.integer  "noballs"
    t.integer  "byes"
    t.integer  "legbyes"
    t.integer  "extras"
    t.integer  "covrsnratio"
    t.integer  "fifties"
    t.integer  "hundreds"
    t.integer  "noofdels"
    t.integer  "noofshots"
    t.integer  "c_strike"
    t.integer  "c_nonstrike"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "encrypted_password_confirmation"
    t.string   "remember_token"
    t.string   "country"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "salt"
    t.string   "email"
    t.string   "temppass"
    t.string   "name"
    t.date     "expiry"
    t.string   "actype"
  end

  create_table "coaches", :force => true do |t|
    t.integer  "clientkey"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "clientkey"
    t.string   "country_s"
  end

  create_table "dismissals", :force => true do |t|
    t.string   "dismissaltype"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "fieldings", :force => true do |t|
    t.integer  "teamkey"
    t.integer  "tournamentkey"
    t.integer  "matchkey"
    t.integer  "venuekey"
    t.integer  "playerkey"
    t.integer  "runssaved"
    t.integer  "catchtaken"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "clientkey"
  end

  create_table "formats", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lengths", :force => true do |t|
    t.string   "length"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lines", :force => true do |t|
    t.string   "line"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "managers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "clientkey"
  end

  create_table "match_types", :force => true do |t|
    t.string   "matchtype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "matches", :force => true do |t|
    t.integer  "matchtypekey"
    t.integer  "teamidone"
    t.integer  "teamidtwo"
    t.integer  "tournamentkey"
    t.integer  "venuekey"
    t.integer  "matchwon"
    t.integer  "matchtied"
    t.boolean  "matchwonortied"
    t.integer  "winnerkey"
    t.string   "details"
    t.integer  "formatkey"
    t.integer  "tosswon"
    t.integer  "clientkey"
    t.float    "matchovers",     :limit => 24
    t.date     "matchdate"
    t.integer  "dayandnite"
    t.string   "electedto"
    t.string   "pitchcondition"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "matches", ["id", "clientkey", "matchdate", "matchtypekey", "pitchcondition", "electedto"], :name => "UIX_Matches_idNmatchtype", :unique => true
  add_index "matches", ["id", "clientkey", "teamidone", "teamidtwo", "winnerkey"], :name => "UIX_Matches_idNteam", :unique => true

  create_table "player_stats", :force => true do |t|
    t.integer  "playerid"
    t.integer  "playerkey"
    t.integer  "battingstylekey"
    t.integer  "totalruns"
    t.float    "battingaverage",                 :limit => 24
    t.integer  "notouts"
    t.integer  "highestscore"
    t.integer  "ballsfaced"
    t.integer  "matchesplayed"
    t.integer  "totalinnings"
    t.integer  "maxdissmissedaskey"
    t.integer  "positionwbestbattingavg"
    t.float    "battingstrikerate",              :limit => 24
    t.integer  "positionwbestbattingstrikerate"
    t.integer  "bowlingstylekey"
    t.integer  "bowlingtypekey"
    t.integer  "totalballsdelivered"
    t.integer  "totalwickets"
    t.integer  "highestwickets"
    t.float    "bowlingaverage",                 :limit => 24
    t.integer  "totalcatches"
    t.integer  "stumpings"
    t.integer  "maxdismissedbatsmanaskey"
    t.string   "maidens"
    t.integer  "playertypekey"
    t.float    "bowlingstrikerate",              :limit => 24
    t.integer  "winloss"
    t.integer  "formatkey"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "clientkey"
  end

  create_table "player_types", :force => true do |t|
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.integer  "clientkey"
    t.integer  "age"
    t.string   "battingstyle"
    t.string   "bowlingstyle"
    t.string   "bowlingtype"
    t.date     "dob"
    t.string   "fname"
    t.string   "lname"
    t.string   "format"
    t.integer  "formatkey"
    t.string   "fullname"
    t.string   "playertype"
    t.integer  "wh_current"
    t.integer  "playerid"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "countrykey"
  end

  add_index "players", ["id", "clientkey", "battingstyle", "bowlingstyle", "bowlingtype", "playertype", "fullname"], :name => "UIX_Players_Evrything", :unique => true
  add_index "players", ["id", "clientkey"], :name => "index_players_on_id_and_clientkey", :unique => true

  create_table "right_lefts", :force => true do |t|
    t.string   "rightorleft"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "scorecards", :force => true do |t|
    t.integer  "clientkey"
    t.integer  "ballsdelivered"
    t.integer  "ballsfaced"
    t.integer  "batsmankey"
    t.integer  "battingendkey"
    t.integer  "battingposition"
    t.integer  "currentbowlerkey"
    t.integer  "bowlerkey"
    t.integer  "bowlingendkey"
    t.integer  "bowlingposition"
    t.integer  "byes"
    t.integer  "currentstrikerkey"
    t.integer  "currentnonstrikerkey"
    t.integer  "eights"
    t.integer  "fielderkey"
    t.integer  "fives"
    t.integer  "formatkey"
    t.integer  "fours"
    t.integer  "inning"
    t.integer  "legbyes"
    t.integer  "maiden"
    t.integer  "matchkey"
    t.integer  "noballs"
    t.integer  "ones"
    t.integer  "others"
    t.integer  "outtypekey"
    t.integer  "outbywk"
    t.integer  "runs"
    t.integer  "sevens"
    t.integer  "sixes"
    t.integer  "teamidone"
    t.integer  "teamtwoid"
    t.integer  "threes"
    t.integer  "tournamentkey"
    t.integer  "twos"
    t.integer  "venuekey"
    t.integer  "wicket"
    t.integer  "wides"
    t.integer  "zeros"
    t.integer  "dismissedbatsmankey"
    t.string   "cr"
    t.integer  "line"
    t.integer  "length"
    t.integer  "shottype"
    t.integer  "side"
    t.integer  "over"
    t.integer  "ballnum"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "batsmanid"
    t.integer  "currentbowlerid"
    t.string   "direction"
    t.integer  "spell"
  end

  add_index "scorecards", ["id", "clientkey", "ballnum", "formatkey", "tournamentkey", "venuekey", "inning", "matchkey", "outtypekey", "batsmankey", "currentnonstrikerkey", "currentbowlerkey", "battingposition", "bowlingposition", "cr", "dismissedbatsmankey"], :name => "UIX_Scorecards_Evrythng", :unique => true
  add_index "scorecards", ["id", "clientkey", "spell", "direction"], :name => "UIX_Scorecards_idspellndirection", :unique => true
  add_index "scorecards", ["id", "clientkey"], :name => "index_scorecards_on_id_and_clientkey", :unique => true
  add_index "scorecards", ["id", "line", "length", "shottype"], :name => "UIX_Scorecards_LineLenghtShottype", :unique => true

  create_table "shottypes", :force => true do |t|
    t.string   "shottype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "team_types", :force => true do |t|
    t.string   "teamtype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.integer  "clientkey"
    t.integer  "teamid"
    t.integer  "teamtypekey"
    t.integer  "playerkey"
    t.integer  "playertypekey"
    t.string   "teamname"
    t.integer  "coachkey"
    t.integer  "managerkey"
    t.integer  "winloss"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "formatkey"
    t.integer  "countrykey"
    t.integer  "playerid"
  end

  add_index "teams", ["id", "teamid", "clientkey", "playerkey", "coachkey", "managerkey"], :name => "UIX_Teams", :unique => true

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.datetime "datestart"
    t.datetime "dateend"
    t.integer  "formatkey"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "clientkey"
  end

  create_table "venues", :force => true do |t|
    t.string   "venuename"
    t.integer  "endonekey"
    t.integer  "endtwokey"
    t.string   "endone"
    t.string   "endtwo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "clientkey"
  end

end
