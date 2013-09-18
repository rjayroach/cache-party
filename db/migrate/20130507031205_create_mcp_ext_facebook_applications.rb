class CreateMcpExtFacebookApplications < ActiveRecord::Migration
  def change
    create_table :mcp_ext_facebook_applications do |t|
      t.string :app_id
      t.string :app_secret
      t.string :app_scope
      t.string :oauth_token
      t.string :wall_post_domain

      t.timestamps
    end
  end
end
