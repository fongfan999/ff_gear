class AddLinkedToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :linked, :boolean, default: false
  end
end
