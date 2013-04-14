class GamesController < ApplicationController
  before_filter :authenticate_player!

  def show
    @game = Game.find_by(id: params[:id]) || not_found

    respond_to do |format|
      format.json { render json: @game.to_json(root: false) }
    end
  end

  def substitute
    @game = Game.find_by(id: params[:id]) || not_found
    s = @game.substitutions.new
    s.on_time = params[:substitution][:on_time].to_i
    s.off_time = params[:substitution][:off_time].to_i
    s.player_id = params[:substitution][:player_id].to_i
    s.team_id = params[:substitution][:team_id].to_i
    s.gk = params[:substitution][:gk] == "true"
    unless params[:substitution][:replaces_id].blank?
      s.replaces_id = params[:substitution][:replaces_id].to_i
      replaced = Substitution.find(params[:substitution][:replaces_id])
      replaced.off_time = params[:substitution][:on_time].to_i
      replaced.save
    end
    s.save
    unless params[:substitution][:replaced_by_id].blank?
      replacing = Substitution.find(params[:substitution][:replaced_by_id])
      replacing.replaces_id = s.id
    end

    respond_to do |format|
      format.json {
        render json: @game.partitioned_substitutions.to_json(root: false, include: :player)
      }
    end
  end

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
          players: @coming,
          tmpl: render_to_string(partial: "games/attendance",
                                 formats: [:html],
                                 locals: { players: @coming })
        }
      }
    end
  end

  def substitutions
    @game = Game.find params[:id]

    respond_to do |format|
      format.json {
        render json: @game.partitioned_substitutions.to_json(root: false, include: :player)
      }
    end
  end
end
