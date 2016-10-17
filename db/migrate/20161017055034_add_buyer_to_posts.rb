class AddBuyerToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :buyer, index: true
    add_foreign_key :posts, :users, column: :buyer_id
  end
end
