class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :players, :role, :string
  end
end
