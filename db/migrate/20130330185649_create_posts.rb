class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :player_id
      t.integer :reply_to
      t.integer :forum_thread_id

      t.timestamps
    end
  end
end
