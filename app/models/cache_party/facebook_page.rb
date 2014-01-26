
module CacheParty

  # The job of this model is to take a URL and populate its fields from FB using the URL
  # Its second job is to download assets from FB based on picture and cover_source fields
  # NOTE The assumption is that FB URLs are unique and that they map one to one to unique FB IDs
  # url is a place_holder field populated by the object holding a reference to this object
  # so object holding the reference has no need to know the Fan Page's facebook_id, link, or other identifying field
  class FacebookPage < ActiveRecord::Base
    include CacheParty::Facebook::Helpers

    # TODO: replace in FanClub and make sure no deadlock
    def update_cache; update_cache_on_create; end

    attr_accessor :cache_list

    # todo Write a cron job that updates facebook page stats (number of likes) every 24 hours
    # todo Use fql to grab page info and picture info at the same time (not as separate queries
    belongs_to :cacheable, polymorphic: true

    #has_many :stats, foreign_key: 'facebook_page_id', class_name: "CacheParty::FacebookPageStat"
    has_many :stats, foreign_key: 'facebook_page_id', class_name: "FacebookPageStat"

    validates :url, presence: true, uniqueness: true

    # Always update cache when a new record is created
    after_commit :update_cache_on_create, on: :create


    # If the url has changed, then go to Facebook to update the data in this model
    # After save, track whether the url was changed or not
    after_save :update_url
    def update_url; @url_up = (url_changed?); end


    # So that after the commit we can still know if the url was updated
    #   and update the cache if so
    #after_commit :update_cache_on_persisted, on: :persisted? #, if: :url_updated?
    #after_commit :update_cache_on_create, on: :update, if: :url_updated?
    def url_updated?; @url_up; end


    # Put the list of asset files into a var that will survive the destroy process
    after_destroy :list_cache

    # After the record destroy has well and truly been committed to the db, then delete the asset files
    after_commit :clear_cache, on: :destroy

    def get_current_likes
      return if self.facebook_id.nil?
      self.facebook_page_stats.create(likes: Koala::Facebook::API.new.get_object(self.facebook_id)['likes'])
    end
  end
end


