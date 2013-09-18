
Rails.logger.info "\nLoading extensions to the AuthProfile model from #{ __FILE__ }\n"

# 
# Add extensions to Authorization's User class
# See: http://stackoverflow.com/questions/2012383/extending-a-ruby-gem-in-rails
# Also, see: http://stackoverflow.com/questions/8895103/how-can-i-keep-my-initializer-configuration-from-being-lost-in-development-mode
#
Rails.application.config.to_prepare do
 

  # 
  # Add an association to the User model to FacebookUser
  #
  McpAuth::User.class_eval do
    # TODO: conditions on this association? would be when provider.eql? 'facebook'
    has_one :facebook_user, class_name: 'CacheParty::FacebookUser', dependent: :destroy
  end


  # 
  # Create a new CacheParty::FacebookUser when a new AuthProfile is created and the provider name is 'facebook'
  # NOTE: The method below has knowledge of the inner workings of McpAuth User and AuthUser classes
  #   Specifically, it assumes that the auth_profile will have a valid reference to a user (which is reasonable)
  #
  McpAuth::AuthProfile.class_eval do

    # After saving an AuthProfile, check for an existing record of FacebookUser and create one if it doesn't exist
    after_save :facebook_user_create, if: "self.provider.eql?('facebook') and self.user.facebook_user.nil?"

    #
    # Create a FacebookUser setting the username to the uid returned from facebook
    #
    def facebook_user_create
      Rails.logger.debug "Creating CacheParty::FacebookUser for McpAuth::User from #{ __FILE__ }\n"
      self.user.create_facebook_user
    end
  end


end

