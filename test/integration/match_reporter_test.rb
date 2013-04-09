require 'test_helper'

class MatchReporterTest < ActionDispatch::IntegrationTest
  include AuthIntegrationHelper

  setup do
    @gm = Player.where(role: "gm").first
    @player = Player.where(role: "player").first
    @game = @gm.team.games.first
    @other_gm = Player.where("role = 'gm' AND team_id NOT IN (?)", [@game.home_team.id, @game.away_team.id]).first
  end
  
  teardown do
    logout
  end
  
  test "rejects unauthorized users" do
    get new_report_path(@game)
    assert_redirected_to '/'
  end

  test "rejects players" do
    login_as @player
    get new_report_path(@game)
    assert_redirected_to '/'
  end

  test "rejects GMs not on the team" do
    login_as @other_gm
    get new_report_path(@game)
    assert_redirected_to '/'
  end
end
