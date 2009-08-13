class MediaFileComment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :media_file
    
end
