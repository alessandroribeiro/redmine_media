require 'rubygems'
require 'aws/s3'
require 'vendor/plugins/redmine_media/app/models/media_file_global_settings'

class S3MediaFileManager
  
  def initialize
    @local_path_util = LocalMediaPathUtil.new
    @s3_path_util = S3MediaPathUtil.new    
  end
  
  def init
    access_key_id = MediaFileGlobalSettings.access_key_id
    secret_access_key = MediaFileGlobalSettings.secret_access_key
    AWS::S3::Base.establish_connection!( :access_key_id => access_key_id, :secret_access_key => secret_access_key )    
  end
  
  
  def copy_to_s3(mediafile_id,filename)
    bucket = @s3_path_util.s3_bucketname
    file_basename = File.basename(filename)
    key = @s3_path_util.s3_key_for_file(mediafile_id, file_basename)
    AWS::S3::S3Object.store(key,open(filename),bucket)
  end
 
  def exists_in_s3(mediafile_id,filename)
    AWS::S3::S3Object.exists()
  end
  
  def delete_from_s3(mediafile_id,filename)
    bucket_name = @s3_path_util.s3_bucketname
    key = @s3_path_util.s3_key_for_file(mediafile_id, filename)
    AWS::S3::S3Object.delete(key, bucket_name)    
  end
  
  def url_for_s3(mediafile_id,filename,seconds_valid)
    key = @s3_path_util.s3_key_for_file(mediafile_id, filename)
    AWS::S3::S3Object.url_for(key,@s3_path_util.s3_bucketname, :expires_in=>seconds_valid)
  end
  
end
  
