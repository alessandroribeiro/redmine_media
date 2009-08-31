class MediaFile < ActiveRecord::Base
  has_attachment :storage => :file_system, :max_size => 50.megabytes, :content_type => ["audio/mpeg","video/x-flv", "video/x-msvideo", "video/mpeg", "video/x-ms-wmv"]
  
  belongs_to :user
  belongs_to :project
  
  has_many :media_file_comments, :order => 'created_on DESC'
  
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
  
  def is_video_and_needs_conversion?
    return (is_avi? or is_mpeg? or is_wmv?)
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
    #self.convert!
    success = system(convert_command)
    if success && $?.exitstatus == 0
      #update_after_conversion
      update_attribute(:converted,true)
      puts "file converted"
    else
      puts "file not converted"
    end
  end

  def generate_thumb
    #self.convert!
    success = system(thumb_command)
    if success && $?.exitstatus == 0
      #update_after_conversion
      update_attribute(:thumb_created,true)
      puts "thumb created"
    else
      puts "thumb not created"
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
    diff_in_seconds = Time.now - created_on
    if (diff_in_seconds<60) 
      if diff_in_seconds==1
        return [diff_in_seconds,"second"]
      end
      return [diff_in_seconds,"seconds"]
    end
    
    diff_in_minutes = diff_in_seconds/60    
    if (diff_in_minutes<60)
      if diff_in_minutes==1
        return [diff_in_minutes,"minute"]
      end
      return [diff_in_minutes,"minutes"]
    end
    
    diff_in_hours = diff_in_minutes/60
    if (diff_in_hours<60)
      if diff_in_hours==1
        return [diff_in_hours,"hour"]
      end      
      return [diff_in_hours,"hours"]
    end
    
    diff_in_days = diff_in_hours/24
    if (diff_in_days<30)
      if diff_in_days==1
        return [diff_in_days,"day"]
      end      
      return [diff_in_days,"days"]
    end
    
    diff_in_months = diff_in_days/30
    if (diff_in_months<12)
      if diff_in_months==1
        return [diff_in_months,"month"]
      end      
      return [diff_in_months,"months"]
    end
    
    diff_in_years = diff_in_months/12
    if diff_in_years==1
      return [diff_in_years,"year"]
    end

    return [diff_in_years,"years"]
    
  end

  protected

  # This method creates the ffmpeg command that we'll be using
  def convert_command
    @original_video_filename = File.expand_path "public#{public_filename}"
    @flv_filename = "#{@original_video_filename}.flv"
    @flv_url = "#{public_filename}.flv"
    
    command = <<-end_command
      /opt/ffmpeg/ffmpeg -i #{@original_video_filename} #{@flv_filename}
    end_command
    command.gsub!(/\s+/, " ")
  end

  def thumb_command
    @original_video_filename = File.expand_path "public#{public_filename}"
    @thumb_filename = "#{@original_video_filename}.thumb.jpg"
    
    command = <<-end_command
      /opt/ffmpeg/ffmpeg -i #{@original_video_filename} -f mjpeg -s 320x240 -ss 1 -vframes 1 #{@thumb_filename}
    end_command
    command.gsub!(/\s+/, " ")
  end

  # This update the stored filename with the new flash video file
  def update_after_conversion
    #update_attribute(:filename, "#{filename}.flv")
    #update_attribute(:content_type,"video/x-flv")
  end
  
  
end
