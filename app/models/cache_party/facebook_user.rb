module CacheParty
  class FacebookUser < ActiveRecord::Base
    include CacheParty::Facebook::Helpers
    attr_accessor :cache_list


    # TODO: replace in FanClub and make sure no deadlock
    def update_cache; update_cache_on_create; end


    # todo user need not be present; this is tight coupling to DryAuth
    # See initializer that sets up the other side of the association for DryAuth::User
    # NOTE this should be removed when full testing has been done as well as the initializer
    belongs_to :user, class_name: "DryAuth::User"

    # The object which holds this model as a cached object which will be automatically updated when cached data is received
    belongs_to :cacheable, polymorphic: true

    # todo user need not be present; this is tight coupling to DryAuth
    # NOTE this should be removed when full testing has been done
    # The record is invlalid unless it is mapped to a user
    validates :user, presence: true #, uniqueness: true

    # The cache is updated from Facebook only when the record is created
    #   otherwise, update_cache must be invoked manually (will not happen automatically on save)
    # See: http://apidock.com/rails/ActiveRecord/Transactions/ClassMethods/after_commit
    #after_commit :update_cache_on_persisted, if: :persisted? # persisted? is true on :create and :update
    after_commit :update_cache_on_create, on: :create

    validates :facebook_id, presence: true, uniqueness: true


    def get_facebook_data
      Rails.logger.debug { "Requesting data from Facebook for ID: #{facebook_id}" }
      koala = Koala::Facebook::API.new
      rval = koala.get_object(facebook_id)
      Rails.logger.debug { "Received data from Facebook: #{rval}" }
      rval
    end

    def update_record_with json_data
      json_data.delete 'id'
      json_data.delete 'facebook_id'
      Rails.logger.debug { "Updating local cache with Facebook data: #{json_data}" }
      update_attributes(json_data)
    end

  end
end


