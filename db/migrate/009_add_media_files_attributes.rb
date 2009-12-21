class AddMediaFilesAttributes < ActiveRecord::Migration


  def self.up
    add_column :media_files, :converted_media_local_path, :string
    add_column :media_files, :thumb_local_path, :string
    add_column :media_files, :s3_bucket, :string
    add_column :media_files, :s3_media_path, :string
    add_column :media_files, :s3_thumb_path, :string    
    remove_column :media_files, :converted
    remove_column :media_files, :thumb_created       
  end

  def self.down
    remove_column :media_files, :converted_media_local_path
    remove_column :media_files, :thumb_local_path
    remove_column :media_files, :s3_bucket
    remove_column :media_files, :s3_media_path
    remove_column :media_files, :s3_thumb_path
    add_column :media_files, :converted, :boolean
    add_column :media_files, :thumb_created, :boolean    
  end

end
