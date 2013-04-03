class TeamsController < ApplicationController
  def show
    @team = Team.find_by(slug: params[:team]) || not_found
  end
end
