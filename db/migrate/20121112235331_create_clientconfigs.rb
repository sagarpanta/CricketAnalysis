class CreateClientconfigs < ActiveRecord::Migration
  def change
    create_table :clientconfigs do |t|
      t.integer :clientkey
      t.integer :runs
      t.integer :avg
      t.integer :sr
	  t.integer :econ
	  t.integer :bavg
      t.integer :dsmsl
      t.integer :bbh
      t.integer :bbb
	  t.integer :dbx
      t.integer :mtchwon
      t.integer :mtchlost
      t.integer :inns
      t.integer :zero
      t.integer :one
      t.integer :two
      t.integer :three
      t.integer :four
      t.integer :five
      t.integer :six
      t.integer :wides
      t.integer :noballs
      t.integer :byes
      t.integer :legbyes
      t.integer :extras
      t.integer :covrsnratio
	  t.integer :fifties
	  t.integer :hundreds
	  t.integer :noofdels
	  t.integer :noofshots
	  t.integer :c_strike
	  t.integer :c_nonstrike
	  t.integer :consistency

      t.timestamps
    end
  end
end
