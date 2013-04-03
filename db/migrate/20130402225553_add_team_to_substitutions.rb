class AddTeamToSubstitutions < ActiveRecord::Migration
  def change
    change_table :substitutions do |t|
      t.integer :team_id
    end
  end
end
