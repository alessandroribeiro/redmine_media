class MediaFileGlobalSettings < ActiveRecord::Base

  def self.access_key_id
    result = self.find_by_name("access_key_id")
    result.value
  end

  def self.secret_access_key
    result = self.find_by_name("secret_access_key")
    result.value
  end
 
  def self.redmine_bucket
    result = find_by_name("redmine_bucket")
    result.value
  end

  def self.redmine_dir
    result = find_by_name("redmine_dir")
    result.value
  end

end
