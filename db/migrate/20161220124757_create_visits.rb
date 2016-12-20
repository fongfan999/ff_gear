class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.references :user, foreign_key: true
      t.date :visited_at
    end
  end
end
