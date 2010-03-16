class InsertMediaFileGlobalSettings < ActiveRecord::Migration


  def self.up
    execute "delete from `media_file_global_settings`"
    execute "INSERT INTO `media_file_global_settings` VALUES (2,'access_key_id','')"
    execute "INSERT INTO `media_file_global_settings` VALUES (3,'secret_access_key','')"
    execute "INSERT INTO `media_file_global_settings` VALUES (4,'s3_bucket','integritas-redmine')"
    execute "INSERT INTO `media_file_global_settings` VALUES (5,'s3_subfolder','redmine')"
    execute "INSERT INTO `media_file_global_settings` VALUES (6,'redmine_media_files_dir','/disk2/redmine-0.8/public/media_files')"
    execute "INSERT INTO `media_file_global_settings` VALUES (7,'default_storage_method','filesystem')"
    execute "INSERT INTO `media_file_global_settings` VALUES (8,'redmine_public_dir','/disk2/redmine-0.8/public')"
  end

  def self.down
    execute "delete from `media_file_global_settings`"
  end

end
