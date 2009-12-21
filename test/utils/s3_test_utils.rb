module S3Asserts    
 
 
  def assert_s3_exists(bucket,key)
    assert_not_nil(AWS::S3::S3Bucket.find(bucket)[key])
  end

  def assert_s3_doesnt_exist(bucket,key)
    assert_nil(AWS::S3::S3Bucket.find(bucket)[key])
  end

  def assert_s3_webpage(uri, content) 
    uri_obj = URI.parse(uri)
    response = Net::HTTP.get uri_obj
    assert_equal(response.index(content)!=nil,true)
  end

  def assert_s3_not_in_webpage(uri, content) 
    uri_obj = URI.parse(uri)
    response = Net::HTTP.get uri_obj
    assert_equal(response.index(content)!=nil,false)
  end

  def assert_s3_not_in_webpage_without_authentication(uri, content) 
    uri_obj = URI.parse(uri)
    nonauth_uri = URI.parse("http://" + uri_obj.host + uri_obj.path)  
    response = Net::HTTP.get nonauth_uri
    assert_equal(response.index(content)!=nil,false)
  end


end

module S3Initialization
  
  def remove_and_create_bucket(bucket_name)
    begin
      test_bucket = AWS::S3::Bucket.find(bucket_name)
    rescue AWS::S3::NoSuchBucket
      AWS::S3::Bucket.create(bucket_name)
      return
    end  
    AWS::S3::Bucket.delete(bucket_name,:force=>true)
    AWS::S3::Bucket.create(bucket_name)
  end

  def s3_init
    @s3_manager.init  
    remove_and_create_bucket("integritas_test")    
  end

end

