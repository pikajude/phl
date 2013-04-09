require 'test_helper'

class MatchReporterTest < ActionDispatch::IntegrationTest
  setup do
    @gm = Player.where(role: "gm").first
    @player = Player.where(role: "player").first
    @game = @gm.team.games.first
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
end
