class CreateMcpExtFacebookPages < ActiveRecord::Migration
  def change
    create_table :mcp_ext_facebook_pages do |t|
      t.references :cacheable, polymorphic: true
      t.string :url
      t.string :facebook_id
      t.string :about
      t.string :category
      t.string :link
      t.string :name
      t.string :phone
      t.string :cover_source
      t.string :picture

      t.timestamps
    end
  end
end
