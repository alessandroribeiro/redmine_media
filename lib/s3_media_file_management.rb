require 'rubygems'
require 'aws/s3'
require 'vendor/plugins/redmine_media/app/models/media_file_global_settings'

class S3MediaFileManagement
  
  def init
    access_key_id = MediaFileGlobalSettings.access_key_id
    secret_access_key = MediaFileGlobalSettings.secret_access_key
    AWS::S3::Base.establish_connection!( :access_key_id => access_key_id, :secret_access_key => secret_access_key )    
  end
  
  def local_media_complete_dir(mediafile_id)
    id_dir = "#{mediafile_id}"
    number_of_zeros_to_add = 4 - id_dir.size
    zeros = "0" * number_of_zeros_to_add
    base_dir = MediaFileGlobalSettings.redmine_dir
    id_dir = base_dir + "/public/media_files/0000/" + zeros + id_dir
  end
  
  def local_file_complete_path(mediafile_id,filename)
    local_media_complete_dir(mediafile_id) + "/" + filename
  end
  
  def bucket_for_mediafile_id(mediafile_id)
    redmine_bucket_name = MediaFileGlobalSettings.redmine_bucket
    redmine_bucket_name + "/" + mediafile_id.to_s
  end
  
  def copy(mediafile_id,filename)
    init
    redmine_bucket_name = bucket_for_mediafile_id(mediafile_id)
    puts "copying file to s3 (#{redmine_bucket_name})"
    AWS::S3::S3Object.store(filename,open(filename),redmine_bucket_name)
  end
  
end
  
