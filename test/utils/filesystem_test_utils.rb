
module FileSystemInitialization

   def filesystem_init
    base_dir = @local_path_util.local_media_base_dir
    FileUtils.rm_rf(base_dir)
    FileUtils.mkdir(base_dir)
  end

end


module FileSystemUtils
  
  def create_local_file(local_dir_name,media_file_id,filename)
    FileUtils.mkdir_p(local_dir_name)
    local_file_name = local_dir_name + "/" + filename
    local_file = File.open(local_file_name, 'w') {|f| f.puts("this is just a test") }        
    return local_file_name
  end


end

