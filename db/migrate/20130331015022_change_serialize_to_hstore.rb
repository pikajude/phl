class ChangeSerializeToHstore < ActiveRecord::Migration
  def change
    change_table :trade_proposals do |t|
      t.remove :giving
      t.remove :receiving

      t.hstore :giving
      t.hstore :receiving
    end
  end
end
