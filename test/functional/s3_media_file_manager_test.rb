require "test/unit"
require 'ftools'
require 'vendor/plugins/redmine_media/lib/s3_media_file_manager'
require 'aws/s3'
require 'net/http'
require 'uri'
require 'vendor/plugins/redmine_media/test/utils/s3_test_utils' 
require 'vendor/plugins/redmine_media/test/utils/filesystem_test_utils' 
    
class S3MediaFileManagerTest < Test::Unit::TestCase
  include S3Asserts
  include S3Initialization
  include FileSystemInitialization
  include FileSystemUtils
  
  def setup
    @s3_manager = S3MediaFileManager.new
    @local_path_util = LocalMediaPathUtil.new
  end
 
  
  def filesystem_init
    base_dir = @local_path_util.local_media_base_dir
    FileUtils.rm_rf(base_dir)
    FileUtils.mkdir(base_dir)
  end
 

  # TODO: move test util methods to s3 util mixin
  
  def create_local_file(local_dir_name,media_file_id,filename)
    FileUtils.mkdir_p(local_dir_name)
    local_file_name = local_dir_name + "/" + filename
    local_file = File.open(local_file_name, 'w') {|f| f.puts("this is just a test") }        
    return local_file_name
  end

  
  def test_copy
    puts "S3MediaFileManagerTest.test_copy"
    s3_init
    filesystem_init
    local_dir_name = @local_path_util.local_media_complete_dir("xpto")    
    local_file_name = create_local_file(local_dir_name,"xpto", "example.txt")
    @s3_manager.copy_to_s3("xpto",local_file_name)
    assert_s3_exists("integritas_test", "redmine/xpto/example.txt")
    FileUtils.remove_dir(local_dir_name,true)
  end

  def test_delete
    puts "S3MediaFileManagerTest.test_delete"
    s3_init
    filesystem_init
    local_dir_name = @local_path_util.local_media_complete_dir("xpto")    
    local_file_name = create_local_file(local_dir_name,"xpto", "example.txt")
    @s3_manager.copy_to_s3("xpto",local_file_name)
    FileUtils.remove_dir(local_dir_name,true)
    objects = AWS::S3::S3Bucket.find('integritas_test').objects    
    @s3_manager.delete_from_s3("xpto","example.txt")
    assert_s3_doesnt_exist("integritas_test", "redmine/xpto/example.txt")

  end

  def test_url_for_scenario_url_valid
    puts "S3MediaFileManagerTest.test_url_for_scenario_url_valid"
    s3_init
    filesystem_init
    local_dir_name = @local_path_util.local_media_complete_dir("xpto")    
    local_file_name = create_local_file(local_dir_name,"xpto", "example.txt")
    @s3_manager.copy_to_s3("xpto",local_file_name)
    FileUtils.remove_dir(local_dir_name,true)    
    url = @s3_manager.url_for_s3("xpto","example.txt",60*60)
    assert_s3_webpage(url, "just a test")
  end

  def test_url_for_url_scenario_expired
    puts "S3MediaFileManagerTest.test_url_for_url_scenario_expired"
    s3_init
    filesystem_init
    local_dir_name = @local_path_util.local_media_complete_dir("xpto")    
    local_file_name = create_local_file(local_dir_name,"xpto", "example.txt")
    @s3_manager.copy_to_s3("xpto",local_file_name)
    FileUtils.remove_dir(local_dir_name,true)    
    url = @s3_manager.url_for_s3("xpto","example.txt",1)
    sleep 30
    assert_s3_not_in_webpage(url, "just a test")
  end

  def test_url_for_scenario_nonauthenticated_url
    puts "S3MediaFileManagerTest.test_url_for_scenario_nonauthenticated_url"
    s3_init
    filesystem_init
    local_dir_name = @local_path_util.local_media_complete_dir("xpto")    
    local_file_name = create_local_file(local_dir_name,"xpto", "example.txt")
    @s3_manager.copy_to_s3("xpto",local_file_name)
    FileUtils.remove_dir(local_dir_name,true)    
    url = @s3_manager.url_for_s3("xpto","example.txt",1)
    assert_s3_not_in_webpage_without_authentication(url, "just a test")
  end


end

