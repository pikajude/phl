class MakeUsernamesLonger < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.remove :username
      t.string :username, length: 32, null: false
    end
  end
end
