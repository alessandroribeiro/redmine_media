require 'rubygems'
require 'aws/s3'
require 'vendor/plugins/redmine_media/app/models/media_file_global_settings'

class S3MediaPathUtil
  
  
  def s3_bucketname
    MediaFileGlobalSettings.s3_bucket
  end

  def s3_partial_key_for_mediafile_id(mediafile_id)
    basepath = MediaFileGlobalSettings.s3_basepath
    basepath + "/" + mediafile_id.to_s
  end
  
  def s3_key_for_file(mediafile_id, filename)
    subfolder = MediaFileGlobalSettings.s3_subfolder
    subfolder + "/" + mediafile_id.to_s + "/" + filename
  end  
  
  
end
  
