class AddPlayDateToGame < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.datetime :played_on, null: false, default: Time.now
    end
  end
end
