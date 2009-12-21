require 'rubygems'
require 'aws/s3'
require 'vendor/plugins/redmine_media/app/models/media_file_global_settings'

class LocalMediaPathUtil
  
  def local_media_base_dir
    MediaFileGlobalSettings.redmine_media_files_dir
  end

  def local_media_public_dir(mediafile_id)
    id_dir = "#{mediafile_id}"
    number_of_zeros_to_add = 4 - id_dir.size
    zeros = "0" * number_of_zeros_to_add
    id_dir = "/media_files/0000/" + zeros + id_dir
    return id_dir
  end

  def local_media_public_filename(mediafile_id,filename)
    local_media_public_dir(mediafile_id) + "/" + filename
  end

  def local_media_complete_dir(mediafile_id)
    base_dir = MediaFileGlobalSettings.redmine_public_dir
    base_dir + local_media_public_dir(mediafile_id)
  end
  
  def local_media_complete_path(mediafile_id,filename)
    local_media_complete_dir(mediafile_id) + "/" + filename
  end
  
  
end
  
