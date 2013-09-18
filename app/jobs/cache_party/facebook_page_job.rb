# app/workers/facebook_page_worker.rb


module CacheParty
  class FacebookPageJob
    include SuckerPunch::Job
  
    # 
    # Update attributes from FB and queue a request for the picture url
    # TODO Use fql to grab all the data and put all of this inside the worker code
    # TODO Use fixture data to return data in tests
    #
    def perform(id)

      f = nil
      ActiveRecord::Base.connection_pool.with_connection do
        # Allow time for record to be saved to db
        sleep 2
        f = FacebookPage.find(id)

        # TODO: Use fql
        f.facebook_id = Koala::Facebook::API.new.get_object(f.url)['id']
        f.picture = Koala::Facebook::API.new.get_picture(f.facebook_id)
        json_data = Koala::Facebook::API.new.get_object(f.facebook_id)

        Rails.logger.debug "Updating local cache with Facebook data: #{json_data}"
        cover_source_was = f.cover_source
        cover_source_is = json_data['cover'] ? json_data['cover']['source'] : ''
        update = f.update_attributes(
          about: json_data['about'],
          name: json_data['name'],
          phone: json_data['phone'],
          category: json_data['category'],
          link: json_data['link'],
          cover_source: cover_source_is
        )

        # Perform a callback on the object which holds a reference to this cacheable object
        f.cacheable.update_from_cache(f) if f.cacheable and f.cacheable.respond_to?(:update_from_cache)
      end

      # 
      # Retrieve a file from a URL and save it to local File System
      #
      f.retrieve_asset(f.cover_source)

      %w(n s b q).each do |size|
        f.retrieve_asset(f.image(size)) 
      end

    end

  
  end
end 
 

