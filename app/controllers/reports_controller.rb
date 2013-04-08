class ReportsController < ApplicationController
  before_filter :load_game

  def new
  end

  def goal
    goal = @game.goals.new
    goal.team = case params[:side]
                when 'home'
                  @game.home_team
                when 'away'
                  @game.away_team
                else
                  not_found
                end
    @goals = @game.goals
    @game.save

    respond_to do |format|
      if goal.save
        format.html { redirect_to new_report_path(@game) }
        format.json {
          render json: {
            goals: @goals.by_time.map { |goal|
              goal.attributes.merge({
                tmpl: render_to_string(partial: "reports/goal",
                                       formats: [:html],
                                       locals: { goal: goal })
              })
            },
            updated: goal.id
          }
        }
      else
        format.html {
          redirect_to new_report_path(@game), error: goal.errors.full_messages
        }
        format.json { render json: { errors: goal.errors } }
      end
    end
  end

  private
  def load_game
    @game = Game.find_by(id: params[:id]) || not_found
    authorize! :report, @game
    @game.last_activity = @game.current_activity
    @game.last_activity_id = @game.current_activity_id
    @game.current_activity = Time.zone.now
    @game.current_activity_id = current_player.id
    @game.save
  end
end
