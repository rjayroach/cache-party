module CacheParty
  class FacebookPost < ActiveRecord::Base
    belongs_to :contentable, polymorphic: true  # The content
    belongs_to :postable, polymorphic: true     # The Facebook Object to post to
    belongs_to :authorizable, polymorphic: true # The Facebook Object with valid OAuth token
    # attributes: postable_id:integer, postable_type, authorizable_id:integer, authoriziable_type
    # attributes: content, response, posted:boolean, attempted_at:datetime
    
    delegate :content, to: :contentable

#    validates_presence_of :contentable_id, :contentable_type
#    validates_presence_of :postable_id, :postable_type, :authorizable_id, :authorizable_type


    # FanClub::Place.first.wall_posts.successful.within(1.weeks.ago).count
    # See http://stackoverflow.com/questions/2158679/ruby-on-rails-query-by-datetime-range-last-24-48-etc-hours
    scope :within, lambda { | time_ago | { :conditions => ['cache_party_facebook_wall_posts.created_at > ? ', time_ago] } }

    scope :successful, where(posted: true)


    #
    # Takes references to content, oauth_token and an 'publisher' model and attempts to post to Facebook
    #   content: a record that responds to .content
    #   oauth_token: any model/record with an oauth_token field and a valid OAuthToken
    #   publisher: any model/record to record as the publisher of this post
    #
    def post; FacebookPostJob.new.async.perform(self.id); end


  end
end
