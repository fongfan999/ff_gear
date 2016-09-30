class RemoveLinkedAndClientIpFromAttachments < ActiveRecord::Migration[5.0]
  def change
    remove_column :attachments, :linked, :boolean
    remove_column :attachments, :client_ip, :string
  end
end
