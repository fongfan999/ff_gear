class AddAccessTokenUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :access_token, :text, default: ""
  end
end
