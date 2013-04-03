class Trade < ActiveRecord::Base
  belongs_to :team

  def opposing_trade
    Trade.find(self.opposing_trade_id)
  end
end
