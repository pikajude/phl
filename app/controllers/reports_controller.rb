class ReportsController < ApplicationController
  def new
    @game = Game.find_by(id: params[:id]) || not_found
    authorize! :report, @game
  end
end
