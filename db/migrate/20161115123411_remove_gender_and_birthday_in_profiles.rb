class RemoveGenderAndBirthdayInProfiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :gender, :boolean
    remove_column :profiles, :birthday, :date
  end
end
