class AddElectedtoToMatches < ActiveRecord::Migration
  def change
	add_column :matches, :electedto, :string
  end
end
