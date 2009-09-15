class AddMediaFilesConverted < ActiveRecord::Migration


  def self.up
    add_column :media_files, :converted, :boolean
  end

  def self.down
    remove_column :media_files, :converted
  end

end
