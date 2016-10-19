class AddPriceToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :price, :integer
  end
end
