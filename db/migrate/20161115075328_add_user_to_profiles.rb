class AddUserToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_reference :profiles, :user, foreign_key: true
  end
end
