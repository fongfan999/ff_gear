class AddAddressToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :address, :string
  end
end
