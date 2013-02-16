class CreateExternals < ActiveRecord::Migration
  def change
    create_table :externals do |t|
      t.integer :OverNo
      t.integer :BallNo
	  t.integer :InningsNo
      t.string :StrikerName
	  t.string :StrikerBatType
      t.string :NonStrikerName
	  t.string :NonStrikerBatType
      t.string :BowlerName
	  t.string :BowlType
      t.string :FielderName
      t.integer :Runs
      t.integer :Extras
      t.string :BallType
      t.string :ShotName
      t.string :Line
      t.string :Length
      t.integer :IsUncomfortable
      t.integer :IsWickettakingBall
	  t.integer :IsWicket
      t.integer :IsBeaten
      t.integer :IsReleaseshot
	  t.integer :IsWide
	  t.integer :IsNoBall
	  t.integer :IsBye
	  t.integer :IsLegBye
	  t.integer :IsFour
	  t.integer :IsSix
      t.string :BowlingEnd
      t.string :BowlingDirection
	  t.integer :Day
	  t.integer :SpellNo
	  t.string :WicketType
	  t.integer :SessionNo
	  t.string :Region
	  t.integer :PlayingOrder
	  t.string :OutBatsmanName
	  
	  


      t.timestamps
    end
  end
end
