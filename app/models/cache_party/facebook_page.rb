
module CacheParty

  # The job of this model is to take a URL and populate its fields from FB using the URL
  # Its second job is to download assets from FB based on picture and cover_source fields
  # NOTE The assumption is that FB URLs are unique and that they map one to one to unique FB IDs
  # url is a place_holder field populated by the object holding a reference to this object
  # so object holding the reference has no need to know the Fan Page's facebook_id, link, or other identifying field
  class FacebookPage < ActiveRecord::Base
    include CacheParty::Facebook::Helpers

    attr_accessor :cache_list

    # TODO: Write a cron job that updates facebook page stats (number of likes) every 24 hours
    # TODO: Use fql to grab page info and picture info at the same time (not as separate queries
    belongs_to :cacheable, polymorphic: true

    # TODO: Write a cron to grab these stats
    has_many :stats, foreign_key: 'facebook_page_id', class_name: "CacheParty::FacebookPageStats"

    #attributes :id, :facebook_id, :name, :link, :category, :phone, :cover_source, :picture

    validates :url, presence: true, uniqueness: true

    # If the url has changed, then go to Facebook to update the data in this model
    after_save :update_cache, if: "self.url != self.url_was"

    # Put the list of asset files into a var that will survive the destroy process
    after_destroy :list_cache

    # After the record destroy has well and truly been committed to the db, then delete the asset files
    after_commit :clear_cache

    def get_current_likes
      return if self.facebook_id.nil?
      self.facebook_page_stats.create(likes: Koala::Facebook::API.new.get_object(self.facebook_id)['likes'])
    end
  end
end


