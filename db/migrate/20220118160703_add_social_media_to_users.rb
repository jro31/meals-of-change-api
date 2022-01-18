class AddSocialMediaToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :twitter_handle, :string
    add_column :users, :instagram_username, :string
  end
end
