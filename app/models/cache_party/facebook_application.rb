module CacheParty
  class FacebookApplication < ActiveRecord::Base
    validates :app_id, :app_secret, :app_scope, :wall_post_domain, presence: true

    before_validation :check_oauth_token


    # 
    # Get the Application Token
    #
    def check_oauth_token
      if self.oauth_token.nil?
        url = "https://graph.facebook.com/oauth/access_token?client_id=#{self.app_id}&client_secret=#{self.app_secret}&grant_type=client_credentials"
        ab = open(url) {|f| f.read}
        self.oauth_token = ab.split('=')[1]
      end
      #url ="https://graph.facebook.com/oauth/access_token?client_id=#{p.authorizable.facebook_id}&client_secret=#{p.authorizable.key}&grant_type=#{p.authorizable.permissions.gsub(/\s+/, '')}" 
    end
  end
end
