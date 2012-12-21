class AddPitchconditionToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :pitchcondition, :string
  end
end
