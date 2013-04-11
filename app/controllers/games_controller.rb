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
      format.json { render json: { attending: @attending } }
    end
  end

  def attendance
    @game = Game.find params[:game]
    @team = current_player.team
    @coming = @game.attending_players.where(team_id: @team.id)

    respond_to do |format|
      format.json {
        render json: {
          players: @coming.map { |player|
            player.as_json(only: [:id, :username])
          },
          tmpl: render_to_string(partial: "games/attendance",
                                 formats: [:html],
                                 locals: { players: @coming })
        }
      }
    end
  end
end
