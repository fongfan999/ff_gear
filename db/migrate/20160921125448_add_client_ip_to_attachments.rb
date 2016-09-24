class AddClientIpToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :client_ip, :string
  end
end
