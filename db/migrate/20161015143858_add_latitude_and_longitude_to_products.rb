class AddLatitudeAndLongitudeToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :latitude, :float
    add_column :products, :longitude, :float
  end
end
