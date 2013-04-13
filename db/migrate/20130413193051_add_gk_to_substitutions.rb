class AddGkToSubstitutions < ActiveRecord::Migration
  def change
    change_table :substitutions do |t|
      t.boolean :gk, null: false, default: false
    end
  end
end
