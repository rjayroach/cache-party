# app/workers/facebook_wall_post_worker.rb

module CacheParty
  class FacebookPostJob
    include SuckerPunch::Job
  
    # 
    # Post a message to a FB wall
    # The wall_post object contains an authorizable field that has the token with which to post
    # It also has a time to update when the post is successful
    #
    def perform(id)
      f = nil
      ActiveRecord::Base.connection_pool.with_connection do
        # Allow time for record to be saved to db
        sleep 2
        f = FacebookPost.find(id)

        link = f.attach_post_id_to_content ? "#{f.contentable.link}?pid=#{f.id}" : f.contentable.link
        koala_client = Koala::Facebook::API.new(f.authorizable.oauth_token)
        Rails.logger.debug { "Post to Facebook with authorization #{f.authorizable.to_yaml}" }

        options = {
          link: link,
          picture: f.contentable.picture,
          message: f.contentable.message,
          description: f.contentable.description
        }
        Rails.logger.debug { "Post to Facebook with content #{options}" }

        #begin
          fb_response = koala_client.put_object(f.contentable.uid, 'feed', options)                                                                             
          Rails.logger.debug "Result is #{fb_response}"
          f.update_attributes(
            attempted_at: Time.now,
            posted: (not fb_response['id'].nil?),
            response: (fb_response['id'] ? fb_response['id'] : '')
          )

          # Perform a callback on the object which holds a reference to this cacheable object
          f.contentable.update_from_post(f) if f.contentable and f.contentable.respond_to?(:update_from_post)
        #rescue => e
        #  Rails.logger.warn "Failed wall post due to OAuthException" if(e.fb_error_type == "OAuthException")
        #end
      end # perform
    end

  end
end 

