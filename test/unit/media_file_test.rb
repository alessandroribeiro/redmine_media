require File.dirname(__FILE__) + '/../test_helper'

require 'vendor/plugins/redmine_media/test/utils/s3_test_utils' 
require 'vendor/plugins/redmine_media/test/utils/filesystem_test_utils' 
require 'mocha'

class MediaFileTest < Test::Unit::TestCase
  fixtures :media_files, :media_file_global_settings
  
  include S3Asserts
  include S3Initialization
  include FileSystemInitialization
  include FileSystemUtils

  def setup
    @s3_manager = S3MediaFileManager.new
    @s3_path_util = S3MediaPathUtil.new    
    @local_path_util = LocalMediaPathUtil.new    
  end

  def assert_thumbfile_created(media_file,original_filename,storage_method)
    thumb_file_dir = @local_path_util.local_media_complete_dir(media_file.id)
    thumb_file = thumb_file_dir + "/" + original_filename + ".thumb.jpg"
    assert_equal(File.exists?(thumb_file), true)
    assert_equal(media_file.thumb_local_path,thumb_file)
    assert_equal(media_file.storage_method,storage_method)
    if storage_method=="s3"
          s3_key = @s3_path_util.s3_key_for_file(media_file.id, media_file.filename)
          assert_s3_exists("integritas_test", "#{s3_key}.thumb.jpg")
    end
  end


  def copy_original_media_file(filename, media_file_id)
    target_media_file_dir = @local_path_util.local_media_complete_dir(media_file_id)
    original_media_file_dir = target_media_file_dir + "/../../../original_media_files"
    original_media_file = original_media_file_dir + "/" + filename
    FileUtils.mkdir_p(target_media_file_dir)
    target_media_file = target_media_file_dir + "/" + filename
    FileUtils.copy_file(original_media_file,target_media_file)
    target_media_file
  end

  def test_thumb_command
    puts "MediaFileTest.test_thumb_command"
    mf = MediaFile.find 1
    public_media_file = @local_path_util.local_media_public_filename(mf.id,mf.filename)
    mf.expects(:public_filename).returns(public_media_file).times(0..50)
    command = mf.thumb_command
    assert_equal(command,"/opt/ffmpeg/ffmpeg -y -i /disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/0001/test.flv -f mjpeg -s 320x240 -ss 1 -vframes 1 /disk2/redmine-0.8/vendor/plugins/redmine_media/test/media_files/0000/0001/test.flv.thumb.jpg")

  end

  def test_generate_thumb(media_file_id,storage_method)
    filesystem_init
    s3_init
    mf = MediaFile.find media_file_id
    target_media_file = copy_original_media_file(mf.filename, mf.id)
    public_media_file = @local_path_util.local_media_public_filename(mf.id,mf.filename)
    mf.expects(:public_filename).returns(public_media_file).times(0..50)
    MediaFileGlobalSettings.stubs(:default_storage_method).returns(storage_method)
    mf.generate_thumb_and_copy_to_destination
    assert_thumbfile_created(mf,mf.filename,storage_method)
    sleep 2
  end

  def test_generate_thumb_when_flv_and_storage_filesystem
    puts "MediaFileTest.test_generate_thumb_when_flv_and_storage_filesystem"
    test_generate_thumb(1, "filesystem")
  end
  
  def test_generate_thumb_when_flv_and_file_storage_s3
    puts "MediaFileTest.test_generate_thumb_when_flv_and_file_storage_s3"
    test_generate_thumb(2, "s3")
  end

  def assert_converted_file_created(media_file,original_filename,storage_method)
    file_dir = @local_path_util.local_media_complete_dir(media_file.id)
    file = file_dir + "/" + original_filename 
    if not media_file.is_flv?
      file = file + ".flv"
    end
    assert_equal(File.exists?(file), true)
    if storage_method=="s3"
          s3_key = @s3_path_util.s3_key_for_file(media_file.id, media_file.filename)
          if not media_file.is_flv?
            s3_key = s3_key = ".flv"
          end
          assert_s3_exists("integritas_test", "#{s3_key}")
    end
  end

  def test_convert(media_file_id,storage_method)
    filesystem_init
    s3_init
    mf = MediaFile.find media_file_id
    target_media_file = copy_original_media_file(mf.filename, mf.id)
    public_media_file = @local_path_util.local_media_public_filename(mf.id,mf.filename)
    mf.expects(:public_filename).returns(public_media_file).times(0..50)
    MediaFileGlobalSettings.stubs(:default_storage_method).returns(storage_method)
    mf.convert_and_copy_to_destination
    assert_converted_file_created(mf,mf.filename,storage_method)
    sleep 2

  end

  def test_convert_when_flv_and_storage_filesystem    
    puts "MediaFileTest.test_convert_when_flv_and_storage_filesystem"
    test_convert(1,"filesystem")
  end

  def test_convert_when_flv_and_storage_s3
    puts "MediaFileTest.test_convert_when_flv_and_storage_s3"
    test_convert(2,"s3")
  end

end



