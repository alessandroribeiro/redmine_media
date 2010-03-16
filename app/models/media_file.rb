class MediaFile < ActiveRecord::Base
  has_attachment :storage => :file_system, 
                 :max_size => 300.megabytes, 
                 :content_type => ["audio/mpeg","video/x-flv", "video/x-msvideo", "video/mpeg", "video/x-ms-wmv", "video/quicktime", "video/mp4"]
  
  belongs_to :user
  belongs_to :project
  
  has_many :media_file_comments, :order => 'created_on DESC'
  has_many :media_file_views
  
  validates_as_attachment
  
  def is_flv?
    if content_type == "video/x-flv"
      return true
    end
    return false
  end
   
  def is_avi?
    if content_type == "video/x-msvideo"
      return true
    end
    return false
  end

  def is_mpeg?
    if content_type == "video/mpeg"
      return true
    end
    return false
  end

  def is_wmv?
    if content_type == "video/x-ms-wmv"
      return true
    end
    return false
  end

  def is_mov?
    if content_type == "video/quicktime"
      return true
    end
    return false
  end

  def is_video_and_needs_conversion?
    return (is_avi? or is_mpeg? or is_wmv? or is_mov?)
  end
  
  def is_video?
    return (is_flv? or is_video_and_needs_conversion?)
  end
  
  def is_audio?
    if content_type == "audio/mpeg"
      return true
    end
    return false
  end
  
  
  
  # This method is called from the controller and takes care of the converting
  def convert
    success = system(convert_command + " > conversion.log")
    if success && $?.exitstatus == 0
      local_path_util = LocalMediaPathUtil.new      
      file_dir = local_path_util.local_media_complete_dir(id)
      t_local_path = file_dir + "/" + filename + ".flv"
      update_attribute(:converted_media_local_path,t_local_path)
    end
  end


  def convert_and_copy_to_destination
    if is_video_and_needs_conversion?
      convert
    else
      local_path_util = LocalMediaPathUtil.new      
      t_local_path = local_path_util.local_media_complete_path(id,filename)
      update_attribute(:converted_media_local_path,t_local_path)      
    end
    if MediaFileGlobalSettings.default_storage_method=="s3"
      s3_manager = S3MediaFileManager.new
      local_path_util = LocalMediaPathUtil.new
      s3_path_util = S3MediaPathUtil.new      
      origin_filename = local_path_util.local_media_complete_path(id,filename)
      t_s3_media_path = s3_path_util.s3_key_for_file(id,filename)      
      if is_video_and_needs_conversion?
        origin_filename =  "#{origin_filename}.flv"
        t_s3_media_path = "#{t_s3_media_path}.flv"
      end      
      s3_manager.init
      s3_manager.copy_to_s3(id,origin_filename)
      update_attribute(:s3_media_path,t_s3_media_path) 

      puts "after transfer to s3"
    end
  end


  def generate_thumb
    success = system(thumb_command + " > thumb_creation.log")
    if success && $?.exitstatus == 0
      local_path_util = LocalMediaPathUtil.new      
      thumb_file_dir = local_path_util.local_media_complete_dir(id)
      t_local_path = thumb_file_dir + "/" + filename + ".thumb.jpg"
      update_attribute(:thumb_local_path,t_local_path)
    end    
  end


  def generate_thumb_and_copy_to_destination
    if is_video_and_needs_conversion? or is_flv?
      generate_thumb
      if storage_method=="s3"
        s3_manager = S3MediaFileManager.new
        s3_path_util = S3MediaPathUtil.new
        s3_manager.init
        s3_manager.copy_to_s3(id,@thumb_filename)
        t_s3_thumb_path = s3_path_util.s3_key_for_file(id,@thumb_filename)
        update_attribute(:s3_thumb_path,t_s3_thumb_path) 
      else        
        thumb_local_path = compute_original_local_filename + ".thumb.jpg"
      end
    end
  end

  def converted?
    if (storage_method=="filesystem" and converted_media_local_path!=nil) or (storage_method=="s3" and s3_media_path!=nil)
      return true
    end    
    false
  end

  def thumb_created?
    if is_audio?
      return true
    end
    if (storage_method=="filesystem" and thumb_local_path!=nil) or (storage_method=="s3" and s3_thumb_path!=nil)
      return true
    end        
  end
  
  
  def public_filename_after_conversion
    if is_video_and_needs_conversion?
      return "#{public_filename}.flv"
    end
    return public_filename
  end

  def public_filename_for_thumb
    if is_video_and_needs_conversion? or is_flv?
      return "#{public_filename}.thumb.jpg"
    end
    return public_filename
  end

  def can_be_edited_by? other_user
    if user==other_user
      return true
    end
    role = other_user.role_for_project project 
    if role.name=="Manager" || role.name=="Admin"
      return true
    end
    false
  end

  def time_past
    diff_in_seconds = (Time.now - created_on).to_i
    if (diff_in_seconds<60) 
      if diff_in_seconds==1
        return [diff_in_seconds,"second"]
      end
      return [diff_in_seconds,"seconds"]
    end
    
    diff_in_minutes = (diff_in_seconds/60).to_i    
    if (diff_in_minutes<60)
      if diff_in_minutes==1
        return [diff_in_minutes,"minute"]
      end
      return [diff_in_minutes,"minutes"]
    end
    
    diff_in_hours = (diff_in_minutes/60).to_i
    if (diff_in_hours<60)
      if diff_in_hours==1
        return [diff_in_hours,"hour"]
      end      
      return [diff_in_hours,"hours"]
    end
    
    diff_in_days = (diff_in_hours/24).to_i
    if (diff_in_days<30)
      if diff_in_days==1
        return [diff_in_days,"day"]
      end      
      return [diff_in_days,"days"]
    end
    
    diff_in_months = (diff_in_days/30).to_i
    if (diff_in_months<12)
      if diff_in_months==1
        return [diff_in_months,"month"]
      end      
      return [diff_in_months,"months"]
    end
    
    diff_in_years = (diff_in_months/12).to_i
    if diff_in_years==1
      return [diff_in_years,"year"]
    end

    return [diff_in_years,"years"]
    
  end

  def unique_viewers_list
    users = []
    for view in media_file_views
      if !(users.include? view.user)
        users << view.user
      end
    end
    users
  end

  def compute_original_local_filename
    local_path_util = LocalMediaPathUtil.new      
    @local_filename = local_path_util.local_media_complete_path(id,filename)
  end

  # This method creates the ffmpeg command that we'll be using
  def convert_command
    @original_video_filename = compute_original_local_filename
    @flv_filename = "#{@original_video_filename}.flv"
    @flv_url = "#{public_filename}.flv"
    
    if is_mov?
      command = "/opt/ffmpeg/ffmpeg -y -i #{@original_video_filename} -target ntsc-dvd #{@flv_filename}"        
    else
      command = "/opt/ffmpeg/ffmpeg -y -i #{@original_video_filename} #{@flv_filename}"
    end
    command.gsub!(/\s+/, " ")
  end

  def thumb_command
    @original_video_filename = compute_original_local_filename
    @thumb_filename = "#{@original_video_filename}.thumb.jpg"
    
    if is_mov?
      command = "/opt/ffmpeg/ffmpeg -y -i #{@original_video_filename} -target ntsc-dvd -f mjpeg -s 320x240 -ss 1 -vframes 1 #{@thumb_filename}"      
    else
      command = "/opt/ffmpeg/ffmpeg -y -i #{@original_video_filename} -f mjpeg -s 320x240 -ss 1 -vframes 1 #{@thumb_filename}"
    end
    command.gsub!(/\s+/, " ")
  end

  def media_url
    if storage_method=="filesystem"
      return public_filename_after_conversion
    else  
      s3_manager = S3MediaFileManager.new
      s3_manager.init
      three_hours = 3*60*60
      url = s3_manager.url_for_s3(id,filename,three_hours)
      return url
    end
  end

  def thumb_url
    if storage_method=="filesystem"
      return public_filename_for_thumb
    else  
      s3_manager = S3MediaFileManager.new
      s3_manager.init
      three_hours = 3*60*60
      url = s3_manager.url_for_s3(id,filename + ".thumb.jpg",three_hours)
      return url
    end
  end

  protected
  
  # This update the stored filename with the new flash video file
  def update_after_conversion
    #update_attribute(:filename, "#{filename}.flv")
    #update_attribute(:content_type,"video/x-flv")
  end
  
  
end
