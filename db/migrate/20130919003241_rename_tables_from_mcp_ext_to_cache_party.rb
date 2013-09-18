class RenameTablesFromMcpExtToCacheParty < ActiveRecord::Migration
  def change
    rename_table :mcp_ext_facebook_page_stats, :cache_party_facebook_page_stats
    rename_table :mcp_ext_facebook_users, :cache_party_facebook_users
    rename_table :mcp_ext_facebook_posts, :cache_party_facebook_posts
    rename_table :mcp_ext_facebook_pages, :cache_party_facebook_pages
    rename_table :mcp_ext_facebook_applications, :cache_party_facebook_applications
  end

end
