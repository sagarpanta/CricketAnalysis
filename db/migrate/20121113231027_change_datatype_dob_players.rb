class ChangeDatatypeDobPlayers < ActiveRecord::Migration
  def self.up
    change_table :players do |p|
      p.change :dob, :date
    end
  end

  def self.down
    change_table :players do |p|
      p.change :dob, :datetime
    end
  end
end



