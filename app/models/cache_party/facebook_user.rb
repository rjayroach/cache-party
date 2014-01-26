
module CacheParty
  class FacebookUser < ActiveRecord::Base
    include CacheParty::Facebook::Helpers
    attr_accessor :cache_list


    # TODO: replace in FanClub and make sure no deadlock
    def update_cache; update_cache_on_create; end


    # todo user need not be present; this is tight coupling to McpAuth
    # See initializer that sets up the other side of the association for McpAuth::User
    # NOTE this should be removed when full testing has been done as well as the initializer
    belongs_to :user, class_name: "McpAuth::User"

    # The object which holds this model as a cached object which will be automatically updated when cached data is received
    belongs_to :cacheable, polymorphic: true

    # todo user need not be present; this is tight coupling to McpAuth
    # NOTE this should be removed when full testing has been done
    # The record is invlalid unless it is mapped to a user
    validates :user, presence: true #, uniqueness: true

    # The cache is updated from Facebook only when the record is created
    #   otherwise, update_cache must be invoked manually (will not happen automatically on save)
    # See: http://apidock.com/rails/ActiveRecord/Transactions/ClassMethods/after_commit
    #after_commit :update_cache_on_persisted, if: :persisted? # persisted? is true on :create and :update
    after_commit :update_cache_on_create, on: :create


    # Put the list of asset files into a var that will survive the destroy process
    after_destroy :list_cache

    # After the record destroy has well and truly been committed to the db, then delete the asset files
    after_commit :clear_cache, on: :destroy

    # todo user need not be present; this is tight coupling to McpAuth
    # NOTE the following delegation should not be necessary b/c this record is now storing FB ID itself
    # direct access to self.facebook_id
    #delegate :facebook_id, to: :user
    
    validates :facebook_id, presence: true, uniqueness: true
  end
end


