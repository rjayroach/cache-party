class CreateMcpExtFacebookUsers < ActiveRecord::Migration
  def change
    create_table :mcp_ext_facebook_users do |t|
      #t.references :auth_profile
      t.references :user
      t.references :cacheable, polymorphic: true
      #t.string :facebook_id
      t.string :name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :gender
      t.string :locale
      t.string :link
      t.string :email
      t.string :username
      t.string :picture
      t.boolean :verified
      t.timestamp :updated_time

      t.timestamps
    end
    #add_index :mcp_ext_facebook_users, :auth_profile_id
    add_index :mcp_ext_facebook_users, :user_id
    add_index :mcp_ext_facebook_users, :cacheable_id
    add_index :mcp_ext_facebook_users, :cacheable_type
  end
end
