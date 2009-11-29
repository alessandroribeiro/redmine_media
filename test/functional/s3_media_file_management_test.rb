require "test/unit"
require 'ftools'
require 'vendor/plugins/redmine_media/lib/s3_media_file_management'

class S3MediaFileManagementTest < Test::Unit::TestCase

  def setup
    @s3 = S3MediaFileManagement.new
  end
  
  def test_init
    @s3.init          
  end
 
  def test_local_media_complete_dir_mediafileid_0
    assert_equal(@s3.local_media_complete_dir(0),"/disk2/redmine-0.8/public/media_files/0000/0000")
  end

  def test_local_media_complete_dir_mediafileid_1
    assert_equal(@s3.local_media_complete_dir(1),"/disk2/redmine-0.8/public/media_files/0000/0001")
  end

  def test_local_media_complete_dir_mediafileid_43
    assert_equal(@s3.local_media_complete_dir(43),"/disk2/redmine-0.8/public/media_files/0000/0043")
  end

  def test_local_media_complete_dir_mediafileid_300
    assert_equal(@s3.local_media_complete_dir(300),"/disk2/redmine-0.8/public/media_files/0000/0300")
  end

  def test_local_media_complete_dir_mediafileid_9999
    assert_equal(@s3.local_media_complete_dir(9999),"/disk2/redmine-0.8/public/media_files/0000/9999")
  end 

  def test_local_media_complete_dir_mediafileid_xpto
    assert_equal(@s3.local_media_complete_dir("xpto"),"/disk2/redmine-0.8/public/media_files/0000/xpto")
  end 
  
  def test_local_file_complete_path_id9999_filetxt
    assert_equal(@s3.local_file_complete_path(9999,"file.txt"),"/disk2/redmine-0.8/public/media_files/0000/9999/file.txt")
  end 

  def test_local_file_complete_path_idxpto_filetxt
    assert_equal(@s3.local_file_complete_path("xpto","file.txt"),"/disk2/redmine-0.8/public/media_files/0000/xpto/file.txt")
  end 

  def test_bucket_for_mediafile_id_0
    assert_equal(@s3.bucket_for_mediafile_id(0),"integritas/redmine/0")    
  end

  def test_bucket_for_mediafile_id_12
    assert_equal(@s3.bucket_for_mediafile_id(12),"integritas/redmine/12")    
  end

  def test_bucket_for_mediafile_id_345
    assert_equal(@s3.bucket_for_mediafile_id(345),"integritas/redmine/345")    
  end

  def test_bucket_for_mediafile_id_9876
    assert_equal(@s3.bucket_for_mediafile_id(9876),"integritas/redmine/9876")    
  end

  def test_bucket_for_mediafile_id_xpto
    assert_equal(@s3.bucket_for_mediafile_id("xpto"),"integritas/redmine/xpto")    
  end

  def test_copy
    #@s3.init  
    #create local file to copy
    local_dir_name = @s3.local_media_complete_dir("xpto")
    puts "creating new dir"
    Dir.mkdir(local_dir_name)
    puts "creating local file"
    local_file_name = local_dir_name + "/example.txt"
    local_file = File.open(local_file_name, 'w') {|f| f.puts("this is just a test") }    
    #copy local file to s3
    @s3.copy(12,local_file_name)
    #delete local file
    puts "deleting local dir recursively"
    FileUtils.remove_dir(local_dir_name,true)
  end

end