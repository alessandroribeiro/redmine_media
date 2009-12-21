class MediaFileGlobalSettings < ActiveRecord::Base

  def self.access_key_id
    result = self.find_by_name("access_key_id")
    result.value
  end

  def self.secret_access_key
    result = self.find_by_name("secret_access_key")
    result.value
  end
 
  def self.s3_bucket
    result = find_by_name("s3_bucket")
    result.value
  end

  def self.s3_subfolder
    result = find_by_name("s3_subfolder")
    result.value
  end

  def self.s3_basepath
    s3_bucket + "/" + s3_subfolder
  end

  def self.redmine_public_dir
    result = find_by_name("redmine_public_dir")
    result.value
  end

  def self.redmine_media_files_dir
    redmine_public_dir + "/media_files"
  end

   def self.default_storage_method
    result = find_by_name("default_storage_method") # either s3 or filesystem
    result.value         
   end
 
end
