class AddBuyerToProducts < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :buyer, index: true
    add_foreign_key :products, :users, column: :buyer_id
  end
end
