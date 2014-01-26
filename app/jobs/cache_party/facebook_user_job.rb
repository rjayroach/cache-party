# app/workers/facebook_user_worker.rb


module CacheParty
  class FacebookUserJob
    include SuckerPunch::Job
  

    # 
    # Update attributes from FB and queue a request for the picture url
    #
    def perform(id)
      begin

      f = nil
      ActiveRecord::Base.connection_pool.with_connection do
        # Allow time for record to be saved to db
        #sleep 2
        f = FacebookUser.find(id)
        json_data = get_facebook_data(f)
        update_record_with f, json_data

        # Perform a callback on the object which holds a reference to this cacheable object
        f.cacheable.update_from_cache(f) if f.cacheable and f.cacheable.respond_to?(:update_from_cache)
      end


      %w(n s b q).each do |size|
        f.retrieve_asset(f.image(size)) 
      end

      rescue Exception => msg
        Rails.logger.debug msg
      end

    end


    private

    #
    # todo: Use fql
    #
    def get_facebook_data(f)
      koala = Koala::Facebook::API.new
      f.picture = koala.get_picture(f.facebook_id)
      koala.get_object(f.facebook_id)
      #binding.pry
    end


    def update_record_with f, json_data
      json_data.delete 'id'
      json_data.delete 'facebook_id'
      Rails.logger.debug "Updating local cache with Facebook data: #{json_data}"
      update = f.update_attributes(json_data)
    end


  end
end 
 

