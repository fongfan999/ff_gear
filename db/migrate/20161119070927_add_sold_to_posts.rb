class AddSoldToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :sold, :boolean, default: false
  end
end
