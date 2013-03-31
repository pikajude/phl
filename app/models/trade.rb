class Trade < ActiveRecord::Base
  has_one :giving_team, class_name: :Team
  has_one :receiving_team, class_name: :Team
end
