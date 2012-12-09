class AddFormatToTeams < ActiveRecord::Migration
  def change
	add_column :teams , :formatkey , :integer
  end
end
