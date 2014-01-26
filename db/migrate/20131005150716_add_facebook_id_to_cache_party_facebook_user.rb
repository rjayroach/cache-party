class AddFacebookIdToCachePartyFacebookUser < ActiveRecord::Migration
  def change
    add_column :cache_party_facebook_users, :facebook_id, :string
  end
end
