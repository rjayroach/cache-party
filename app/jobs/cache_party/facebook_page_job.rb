module CacheParty
  class FacebookPageJob
    include SuckerPunch::Job
  
    def perform id
      begin
        ActiveRecord::Base.connection_pool.with_connection do
          fb_page = FacebookPage.find id
          json_data = fb_page.get_facebook_data
          fb_page.update_record_with json_data

          # Perform a callback on the object which holds a reference to this cacheable object
          if fb_page.cacheable and fb_page.cacheable.respond_to?(:update_from_cache)
            fb_page.cacheable.update_from_cache(fb_page)
          end
        end
      rescue Exception => msg
        Rails.logger.debug msg
      end
    end
  
  end
end 
 

