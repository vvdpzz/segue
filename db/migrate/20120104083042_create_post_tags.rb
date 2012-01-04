class CreatePostTags < ActiveRecord::Migration
  def change
    create_table :post_tags, :id => false do |t|
      t.integer  :post_id
      t.string   :tag, :limit => 40
    end
    add_index :post_tags, [:post_id, :tag]
  end
end
