require "test/unit"
require 'ftools'
require 'vendor/plugins/redmine_media/lib/s3_media_path_util'
require 'aws/s3'
require 'net/http'
require 'uri'
require 'vendor/plugins/redmine_media/test/utils/s3_test_utils' 
require 'vendor/plugins/redmine_media/test/utils/filesystem_test_utils' 
    
class S3MediaPathUtilTest < Test::Unit::TestCase
  include S3Asserts
  include S3Initialization
  include FileSystemInitialization
  include FileSystemUtils
  
  def setup
    @util = S3MediaPathUtil.new
  end
  
  def test_s3_partial_key_for_mediafile_id_0
    puts "S3MediaPathUtilTest.test_s3_partial_key_for_mediafile_id_0"
    assert_equal(@util.s3_partial_key_for_mediafile_id(0),"integritas_test/redmine/0")    
  end

  def test_s3_partial_key_for_mediafile_id_12
    puts "S3MediaPathUtilTest.test_s3_partial_key_for_mediafile_id_12"    
    assert_equal(@util.s3_partial_key_for_mediafile_id(12),"integritas_test/redmine/12")    
  end

  def test_s3_partial_key_for_mediafile_id_345
    puts "S3MediaPathUtilTest.test_s3_partial_key_for_mediafile_id_345"    
    assert_equal(@util.s3_partial_key_for_mediafile_id(345),"integritas_test/redmine/345")    
  end

  def test_s3_partial_key_for_mediafile_id_9876
    puts "S3MediaPathUtilTest.test_s3_partial_key_for_mediafile_id_9876"    
    assert_equal(@util.s3_partial_key_for_mediafile_id(9876),"integritas_test/redmine/9876")    
  end

  def test_s3_partial_key_for_mediafile_id_xpto
    puts "S3MediaPathUtilTest.test_s3_partial_key_for_mediafile_id_xpto"    
    assert_equal(@util.s3_partial_key_for_mediafile_id("xpto"),"integritas_test/redmine/xpto")    
  end

  def test_s3_key_for_file
    puts "S3MediaPathUtilTest.test_s3_key_for_file"    
    assert_equal(@util.s3_key_for_file("xpto", "test.txt"), "redmine/xpto/test.txt")  
  end
  
end

