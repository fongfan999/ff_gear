class CreateJoinTablePostsUsers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :posts, :users do |t|
      # t.index [:post_id, :user_id]
      t.index [:user_id, :post_id]
    end
  end
end
