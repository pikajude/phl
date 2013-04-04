class DashboardBox < ActiveRecord::Base
  belongs_to :player

  validates_inclusion_of :relative_size, in: [0.33, 0.5, 0.67, 0.75, 1, 1.5, 2]
end
