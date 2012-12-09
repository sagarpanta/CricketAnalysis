class CreatePlayerStats < ActiveRecord::Migration
  def change
    create_table :player_stats do |t|
      t.integer :playerid
      t.integer :playerkey
      t.integer :battingstylekey
      t.integer :totalruns
      t.float :battingaverage
      t.integer :notouts
      t.integer :highestscore
      t.integer :ballsfaced
      t.integer :matchesplayed
      t.integer :totalinnings
      t.integer :maxdissmissedaskey
      t.integer :positionwbestbattingavg
      t.float :battingstrikerate
      t.integer :positionwbestbattingstrikerate
      t.integer :bowlingstylekey
      t.integer :bowlingtypekey
      t.integer :totalballsdelivered
      t.integer :totalwickets
      t.integer :highestwickets
      t.float :bowlingaverage
      t.integer :totalcatches
      t.integer :stumpings
      t.integer :maxdismissedbatsmanaskey
      t.string :maidens
      t.integer :playertypekey
      t.float :bowlingstrikerate
      t.integer :winloss
      t.integer :formatkey

      t.timestamps
    end
  end
end
