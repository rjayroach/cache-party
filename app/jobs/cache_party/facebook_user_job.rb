module CacheParty
  class FacebookUserJob
    include SuckerPunch::Job
  
    def perform id
      begin
        ActiveRecord::Base.connection_pool.with_connection do
          fb_user = FacebookUser.find id
          json_data = fb_user.get_facebook_data
          fb_user.update_record_with json_data

          # Perform a callback on the object which holds a reference to this cacheable object
          if fb_user.cacheable and fb_user.cacheable.respond_to?(:update_from_cache)
            fb_user.cacheable.update_from_cache(fb_user)
          end
        end
      rescue Exception => msg
        Rails.logger.debug msg
      end
    end

  end
end 
