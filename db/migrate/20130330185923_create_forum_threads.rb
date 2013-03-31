class CreateForumThreads < ActiveRecord::Migration
  def change
    create_table :forum_threads do |t|
      t.string :title
      t.boolean :sticky
      t.boolean :locked
      t.boolean :announce
      t.integer :user_id

      t.timestamps
    end
  end
end
