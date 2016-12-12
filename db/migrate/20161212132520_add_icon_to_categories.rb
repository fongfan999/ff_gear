class AddIconToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :icon, :string
  end
end
