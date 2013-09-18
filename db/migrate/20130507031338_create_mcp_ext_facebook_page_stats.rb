class CreateMcpExtFacebookPageStats < ActiveRecord::Migration
  def change
    create_table :mcp_ext_facebook_page_stats do |t|
      t.references :facebook_page
      t.integer :likes

      t.timestamps
    end
    add_index :mcp_ext_facebook_page_stats, :facebook_page_id
    add_index :mcp_ext_facebook_page_stats, :created_at
  end
end
