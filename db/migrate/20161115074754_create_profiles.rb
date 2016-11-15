class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :phone
      t.string :address
      t.boolean :gender
      t.date :birthday
      t.string :fb_link
      t.string :gg_link

      t.timestamps
    end
  end
end
