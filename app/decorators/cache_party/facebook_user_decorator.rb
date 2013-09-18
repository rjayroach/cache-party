
module CacheParty
  class FacebookUserDecorator < Draper::Decorator
    delegate_all
  
    # 
    # Return the picture value if 1) it is not nil and 2) it exists on disk
    # Otherwise, for a cache update and return an empty string
    # Used by views/cache_party/_facebook_user.html.erb
    #
    def picture
      if model.picture and File.file?(model.asset_path_for_image)
        model.picture
      else
        model.update_cache
        ''
      end
    end
  
  end
end


