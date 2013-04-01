class PlayersController < ApplicationController
  def index
    render :unauth unless player_signed_in?
  end
end
