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

    def get_facebook_data
      koala = Koala::Facebook::API.new
      facebook_id = koala.get_object(url)['id']
      koala.get_object(facebook_id)
    end


    def update_record_with json_data
      Rails.logger.debug "Updating local cache with Facebook data: #{json_data}"
      x_cover_source_was = cover_source
      x_cover_source_is = json_data['cover'] ? json_data['cover']['source'] : ''
      update_attributes(
        facebook_id: json_data['id'],
        about: json_data['about'],
        name: json_data['name'],
        phone: json_data['phone'],
        category: json_data['category'],
        link: json_data['link'],
        cover_source: x_cover_source_is
      )
    end


    def get_current_likes
      return if self.facebook_id.nil?
      self.facebook_page_stats.create(likes: Koala::Facebook::API.new.get_object(self.facebook_id)['likes'])
    end
  end
end
