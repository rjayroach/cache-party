module CacheParty
  class FacebookPageStat < ActiveRecord::Base
    belongs_to :facebook_page
    attr_accessible :likes

  end
end
