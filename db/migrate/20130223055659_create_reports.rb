class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
	  t.string :clnkey
      t.string :akey 
      t.string :ckey 
      t.string :fkey 
      t.string :tkey 
      t.string :inn 
      t.string :vkey 
      t.string :ttkey 
      t.string :tmkey 
      t.string :mtkey 
      t.string :chkey 
      t.string :mkey 
      t.string :ptname 
      t.string :ekey 
      t.string :btkey 
      t.string :bts 
      t.string :bp 
      t.string :st 
      t.string :sd 
      t.string :pckey 
      t.string :ckey1 
      t.string :fkey1 
      t.string :tkey1 
      t.string :inn1 
      t.string :vkey1 
      t.string :ttkey1 
      t.string :tmkey1 
      t.string :mtkey1 
      t.string :chkey1 
      t.string :mkey1 
      t.string :ptname1 
      t.string :ekey1 
      t.string :blkey1 
      t.string :bts1 
      t.string :bls1 
      t.string :btn1 
      t.string :blp1 
      t.string :lk1 
      t.string :lnk1 
      t.string :bskey1 
      t.string :spkey1 
      t.string :pckey1 
      t.string :ankey1 
      t.string :group1 
      t.string :group2
      t.string :metric
      t.integer :lxm
      t.integer :lxb
      t.integer :fxb
      t.integer :fq
      t.string :vid
      t.string :reportname
      t.string :bp1 
	  t.string :charttype

      t.timestamps
    end
  end
end
