class RemoveConstraintFromColor < ActiveRecord::Migration
  def change
    change_column :teams, :color, :string, length: 16, null: false
  end
end
