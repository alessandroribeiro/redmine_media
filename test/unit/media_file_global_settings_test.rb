require File.dirname(__FILE__) + '/../test_helper'

class MediaFileGlobalSettingsTest < Test::Unit::TestCase
  fixtures :media_file_global_settings

  def test_find_by_name_existing_name
    puts "MediaFileGlobalSettingsTest.test_find_by_name_existing_name"
    assert_equal(MediaFileGlobalSettings.find_by_name("key").value, "abc")  
  end     
      
  def test_find_by_name_nonexisting_name
    puts "MediaFileGlobalSettingsTest.test_find_by_name_nonexisting_name"    
    assert_equal(MediaFileGlobalSettings.find_by_name("key2"), nil)
  end 

   def test_find_by_name_existing_name_access_key_id
    puts "MediaFileGlobalSettingsTest.test_find_by_name_existing_name_access_key_id"     
    assert_not_nil(MediaFileGlobalSettings.find_by_name("access_key_id").value)  
  end 
 
  def test_access_key_id
    puts "MediaFileGlobalSettingsTest.test_access_key_id"    
    assert_not_nil(MediaFileGlobalSettings.access_key_id)    
  end 

  def test_secret_access_key
    puts "MediaFileGlobalSettingsTest.test_secret_access_key"    
    assert_not_nil(MediaFileGlobalSettings.secret_access_key)    
  end 

  def test_s3_bucket
    puts "MediaFileGlobalSettingsTest.test_s3_bucket"    
    assert_equal(MediaFileGlobalSettings.s3_bucket, "integritas_test")    
  end 

  def test_s3_subfolder
    puts "MediaFileGlobalSettingsTest.test_s3_subfolder"    
    assert_equal(MediaFileGlobalSettings.s3_subfolder, "redmine")    
  end 

  def test_s3_basepath
    puts "MediaFileGlobalSettingsTest.test_s3_basepath"    
    assert_equal(MediaFileGlobalSettings.s3_basepath, "integritas_test/redmine")    
  end 

  def test_redmine_media_files_dir
    puts "MediaFileGlobalSettingsTest.test_redmine_media_files_dir"    
    assert_equal(MediaFileGlobalSettings.redmine_media_files_dir, "/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files")    
  end 


end
