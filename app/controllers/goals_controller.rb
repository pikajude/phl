class GoalsController < ApplicationController
  def destroy
    @goal = Goal.find params[:id]
    authorize! :destroy, @goal
    @game = @goal.game
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to new_report_path(@game) }
      format.json { render json: @goal }
    end
  end

  def update
    @goal = Goal.find params[:id]
    @game = @goal.game
    params[:goal].reject{|_,v|v.blank?}.each do |k,v|
      case k
      when "time"
        @goal.time = v
      when "scorer"
        @goal.scorer = Player.find v
      when "first_assist"
        @goal.first_assist = Player.find v
      end
    end

    respond_to do |format|
      if @goal.save
        format.html { redirect_to new_report_path(@game) }
        format.json {
          render json: {
            goals: @game.goals.order(:time).map { |g|
              g.attributes.merge({
                tmpl: render_to_string(partial: "reports/goal", formats: [:html], locals: { goal: g })
              })
            },
            updated: @goal.id
          }
        }
      else
        format.html { redirect_to new_report_path(@game), error: @goal.errors.full_messages }
        format.json {
          render json: {
            errors: @goal.errors.keys,
            messages: @goal.errors.full_messages,
            id: @goal.id
          }, status: 422
        }
      end
    end
  end
end
