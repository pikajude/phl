module ScopedBySeason
  extend ActiveSupport::Concern

  included do
    default_scope -> {
      cur = Season.current_id
      if cur
        where(:season_id => cur)
      else
        none
      end
    }
    def self.all_time
      unscoped
    end
  end
end
