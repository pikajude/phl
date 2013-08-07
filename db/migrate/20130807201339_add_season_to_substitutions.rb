class AddSeasonToSubstitutions < ActiveRecord::Migration
  def change
    add_column :substitutions, :season_id, :integer, null: false
  end
end
