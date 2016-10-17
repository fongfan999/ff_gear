class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :file
      t.references :post, foreign_key: true
    end
  end
end
