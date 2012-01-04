class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.string :text, :limit => 560
      t.integer :in_reply_to_post_id
      t.integer :in_reply_to_user_id
      
      t.datetime :created_at
    end
    add_index :posts, :user_id
  end
end
