require_relative "../test_helper"

class MatchReportTest < MiniTest::Unit::TestCase
  context "stats" do
    should "calculate ppg properly" do
      @sub = FactoryGirl.create(:substitution, :off_time => 600)
      @player = @sub.player
      3.times do
        @goal = FactoryGirl.create(:goal, :game_id => @sub.game_id, :scorer_id => @player.id, :team_id => @sub.team_id, :time => 0, :half => 1)
      end
      @goal.game.__send__ :update_stats

      assert_equal 3, @player.reload.ppg
    end

    should "calculate gaa properly" do
      @sub = FactoryGirl.create(:substitution, :off_time => 600)
      @player = @sub.player
      3.times do
        @goal = FactoryGirl.create(:goal, :game_id => @sub.game_id, :scorer_id => @sub.game.away_team.players.first.id, :scored_against => @player.id, :team_id => @sub.team_id, :time => 0, :half => 1)
      end
      @goal.game.__send__ :update_stats

      assert_equal 3, @player.reload.gaa
    end
  end
end
