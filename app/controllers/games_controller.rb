class GamesController < ApplicationController
  before_filter :authenticate_player!

  def attend
    @game = params[:game]
    @attending = current_player.attending? @game
    if @attending
      current_player.unattend @game
    else
      current_player.attend @game
    end

    @attending = !@attending

    respond_to do |format|
      format.html { redirect_to :root }
      format.js
    end
  end

  def attendance
    @game = Game.find params[:game]
    @team = current_player.team
    @coming = @game.attending_players.where(team_id: @team.id)
    
    respond_to do |format|
      format.all do
        render text: @coming.map(&:username).join(", ")
      end
    end
  end
end
