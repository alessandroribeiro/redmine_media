require File.dirname(__FILE__) + '/../test_helper'

class MediaFileGlobalSettingsTest < Test::Unit::TestCase
  fixtures :media_file_global_settings

  def test_find_by_name_existing_name
    assert_equal(MediaFileGlobalSettings.find_by_name("key").value, "abc")  
  end     
      
  def test_find_by_name_nonexisting_name
    assert_equal(MediaFileGlobalSettings.find_by_name("key2"), nil)
  end 

   def test_find_by_name_existing_name_access_key_id
    assert_not_nil(MediaFileGlobalSettings.find_by_name("access_key_id").value)  
  end 

#  def test_find_id_2
#    assert_equal(MediaFileGlobalSettings.find(2).value, "1234")  
#  end 
 
  def test_access_key_id
    assert_not_nil(MediaFileGlobalSettings.access_key_id)    
  end 

  def test_secret_access_key
    assert_not_nil(MediaFileGlobalSettings.secret_access_key)    
  end 

  def test_redmine_bucket
    assert_equal(MediaFileGlobalSettings.redmine_bucket, "integritas/redmine")    
  end 

  def test_redmine_dir
    assert_equal(MediaFileGlobalSettings.redmine_dir, "/disk2/redmine-0.8")    
  end 

#  def test_size
#    assert_equal(MediaFileGlobalSettings.all.size, 3)  
#  end    

end
