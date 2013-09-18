
module CacheParty
  class FacebookUser < ActiveRecord::Base
    include CacheParty::Facebook::Helpers
    attr_accessor :cache_list

    # See initializer that sets up the other side of the association for McpAuth::User
    belongs_to :user, class_name: "McpAuth::User"

    # The object which holds this model as a cached object which will be automatically updated when cached data is received
    belongs_to :cacheable, polymorphic: true

    # The record is invlalid unless it is mapped to a user
    validates :user, presence: true #, uniqueness: true

    # The cache is only updated from Facebook when the record is created
    after_create :update_cache

    # Put the list of asset files into a var that will survive the destroy process
    after_destroy :list_cache

    # After the record destroy has well and truly been committed to the db, then delete the asset files
    after_commit :clear_cache

    # direct access to self.facebook_id
    delegate :facebook_id, to: :user
    
  end
end


