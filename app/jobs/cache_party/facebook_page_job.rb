module CacheParty
  class FacebookPageJob
    include SuckerPunch::Job
  
    # 
    # Set the facebook id and picture
    # and return the page data as a JSON array
    # todo Use fql to grab all the data and put all of this inside the worker code
    #
    def get_facebook_data(f)
      koala = Koala::Facebook::API.new
      f.facebook_id = koala.get_object(f.url)['id']
      f.picture = koala.get_picture(f.facebook_id)
      koala.get_object(f.facebook_id)
    end


    def update_record_with f, json_data
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
    end


    # 
    # Update attributes from FB and queue a request for the picture url
    #
    def perform(id)

      f = nil
      ActiveRecord::Base.connection_pool.with_connection do
        f = FacebookPage.find(id)
        json_data = get_facebook_data(f)
        update_record_with f, json_data

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
 

