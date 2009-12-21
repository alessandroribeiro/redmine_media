require "test/unit"
require 'ftools'
require 'vendor/plugins/redmine_media/lib/local_media_path_util'
require 'aws/s3'
require 'net/http'
require 'uri'
require 'vendor/plugins/redmine_media/test/utils/s3_test_utils' 
require 'vendor/plugins/redmine_media/test/utils/filesystem_test_utils' 
    
class LocalMediaPathUtilTest < Test::Unit::TestCase
  include S3Asserts
  include S3Initialization
  include FileSystemInitialization
  include FileSystemUtils
  
  def setup
    @util = LocalMediaPathUtil.new
  end
 
  
  def test_local_media_base_dir
    puts "LocalMediaPathUtilTest.test_local_media_base_dir"
    assert_equal(@util.local_media_base_dir,"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files")
  end 
 
  def test_local_media_complete_dir_mediafileid_0
    puts "LocalMediaPathUtilTest.test_local_media_complete_dir_mediafieldid_0"
    assert_equal(@util.local_media_complete_dir(0),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/0000")
  end

  def test_local_media_complete_dir_mediafileid_1
    puts "LocalMediaPathUtilTest.test_local_media_complete_dir_mediafileid_1"
    assert_equal(@util.local_media_complete_dir(1),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/0001")
  end

  def test_local_media_complete_dir_mediafileid_43
    puts "LocalMediaPathUtilTest.test_local_media_complete_dir_mediafileid_43"
    assert_equal(@util.local_media_complete_dir(43),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/0043")
  end

  def test_local_media_complete_dir_mediafileid_300
    puts "LocalMediaPathUtilTest.test_local_media_complete_dir_mediafileid_300"    
    assert_equal(@util.local_media_complete_dir(300),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/0300")
  end

  def test_local_media_complete_dir_mediafileid_9999
    puts "LocalMediaPathUtilTest.test_local_media_complete_dir_mediafileid_9999"    
    assert_equal(@util.local_media_complete_dir(9999),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/9999")
  end 

  def test_local_media_complete_dir_mediafileid_xpto
    puts "LocalMediaPathUtilTest.test_local_media_complete_dir_mediafileid_xpto"    
    assert_equal(@util.local_media_complete_dir("xpto"),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/xpto")
  end 
  
  def test_local_media_complete_path_id9999_filetxt
    puts "LocalMediaPathUtilTest.test_local_media_complete_path_id9999_filetxt"    
    assert_equal(@util.local_media_complete_path(9999,"file.txt"),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/9999/file.txt")
  end 

  def test_local_media_complete_path_idxpto_filetxt
    puts "LocalMediaPathUtilTest.test_local_media_complete_path_idxpto_filetxt"
    assert_equal(@util.local_media_complete_path("xpto","file.txt"),"/disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/xpto/file.txt")
  end 


end

