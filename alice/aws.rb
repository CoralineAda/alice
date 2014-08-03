module Alice
  class AWS

    def connection
      @client ||= ::S3::Service.new(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end
    
    def bucket
      @bucket ||= connection.buckets.find(ENV['AWS_BUCKET_NAME'])
    end

    def upload(path_to_file)
      basefile = File.basename(path_to_file)
      obj = bucket.objects.build(basefile)
      obj.content = open(path_to_file)
      obj.save
    end

  end
end