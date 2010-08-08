require 'rubygems'
require 'uri'
require 'net/http'

#require 'vendor/plugins/redmine_media/app/models/media_file_global_settings'

class RemoteFileDownloader
  
  def initialize
    @path_util = LocalMediaPathUtil.new
  end
  
  def init
  end
  
  def filename_from_url(url)
    path = URI.parse(url).path
    slash_position = path.rindex('/')
    filename_size = path.length - slash_position + 1
    filename = path[slash_position..filename_size]
  end
  
  def download(mediafile_id,url)
    http_response = Net::HTTP.get_response(URI.parse(url).host, URI.parse(url).path)
    @path_util.local_media_complete_path(mediafile_id)
    open("fun.jpg", "wb") { |file|
        file.write(resp.body)
     }
  
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
  
