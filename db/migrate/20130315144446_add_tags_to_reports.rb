class AddTagsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :tag1, :string
    add_column :reports, :tag2, :string
    add_column :reports, :tag3, :string
  end
end
