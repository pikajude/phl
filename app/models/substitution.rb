class Substitution < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  belongs_to :team
  belongs_to :replaces, class_name: :Substitution

  def replacements
    all = []
    replacement = self
    until replacement.nil?
      all << replacement
      replacement = Substitution.find_by(replaces_id: replacement.id)
    end
    all
  end
end
