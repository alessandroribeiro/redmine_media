class AddMediaFilesThumbCreated < ActiveRecord::Migration


  def self.up
    add_column :media_files, :thumb_created, :boolean
  end

  def self.down
    remove_column :media_files, :thumb_created
  end

end
