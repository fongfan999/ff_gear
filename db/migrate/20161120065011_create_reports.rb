class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.string :name
      t.boolean :public, default: false

      t.timestamps
    end
  end
end
