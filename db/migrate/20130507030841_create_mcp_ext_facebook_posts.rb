class CreateMcpExtFacebookPosts < ActiveRecord::Migration
  def change
    create_table :mcp_ext_facebook_posts do |t|
      t.references :contentable, polymorphic: true
      t.references :postable, polymorphic: true
      t.references :authorizable, polymorphic: true
      t.timestamp :attempted_at
      t.string :response
      t.boolean :attach_post_id_to_content
      t.boolean :posted

      t.timestamps
    end
    add_index :mcp_ext_facebook_posts, :contentable_id
    add_index :mcp_ext_facebook_posts, :postable_id
    add_index :mcp_ext_facebook_posts, :authorizable_id
  end
end
