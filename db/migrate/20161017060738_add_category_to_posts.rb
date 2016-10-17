class AddCategoryToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :category, foreign_key: true
  end
end
