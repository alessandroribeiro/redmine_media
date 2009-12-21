class AddMediaFilesStorageMethod < ActiveRecord::Migration


  def self.up
    add_column :media_files, :storage_method, :string
  end

  def self.down
    remove_column :media_files, :storage_method
  end

end
