class MediaFileView < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :media_file
    
  def self.add_view user,media_file
    mfv = MediaFileView.new
    mfv.user = user
    mfv.media_file = media_file
    mfv.save!
    media_file.media_file_views << mfv
    media_file.save!
  end
    
    
end
