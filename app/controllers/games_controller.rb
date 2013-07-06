class GamesController < ApplicationController
  before_filter :authenticate_player!

  respond_to :json

  def show
    @game = Game.find_by(id: params[:id]) || not_found

    respond_with @game
  end

  def substitute
    @game = Game.find_by(id: params[:id]) || not_found
    authorize! :report, @game
    s = @game.substitutions.new
    s.on_time = params[:substitution][:on_time].to_i
    s.off_time = params[:substitution][:off_time].to_i
    s.player_id = params[:substitution][:player_id].to_i
    s.team_id = params[:substitution][:team_id].to_i
    s.gk = params[:substitution][:gk] == "true"
    s.half = params[:substitution][:half].to_i
    unless params[:substitution][:replaces_id].blank?
      s.replaces_id = params[:substitution][:replaces_id].to_i
      replaced = Substitution.find(params[:substitution][:replaces_id])
      replaced.save
    end
    s.save
    unless params[:substitution][:replaced_by_id].blank?
      replacing = Substitution.find(params[:substitution][:replaced_by_id])
      replacing.replaces_id = s.id
      replacing.save
    end

    respond_with @game.partitioned_substitutions_by_half(params[:substitution][:half])
                      .to_json(root: false, include: :player), location: nil
  end

  def attend
    @game = Game.find(params[:game]) || not_found
    authorize! :attend, @game

    attending = current_player.attending? @game
    if attending
      current_player.unattend @game
    else
      current_player.attend @game
    end
    @attending = !attending

    respond_with({attending: @attending}) do |format|
      format.html { redirect_to :root }
    end
  end

  def attendance
    @game = Game.find params[:game]
    @team = current_player.team
    @coming = @game.attending_players.where(team_id: @team.id)

    respond_with({
      players: @coming,
      tmpl: render_to_string(partial: "games/attendance",
                             formats: [:html],
                             locals: { players: @coming })
    })
  end

  def substitutions_by_half
    @game = Game.find params[:id]

    respond_with @game.partitioned_substitutions_by_half(params[:half]).
                       to_json(root: false, include: :player), location: nil
  end

  def update_substitution
    @sub = Substitution.find_by id: params[:substitution][:id]
    @sub.on_time = params[:substitution][:on_time].to_i
    @sub.off_time = params[:substitution][:off_time].to_i
    @sub.save

    respond_with(@sub) do |format|
      format.html { redirect_to edit_report_path(params[:id]) }
    end
  end
end
