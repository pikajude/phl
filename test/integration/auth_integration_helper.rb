module AuthIntegrationHelper
  def login_as user
    visit new_player_session_path
    fill_in 'player_username', with: user.username
    fill_in 'player_password', with: 'password'
    click_button 'Sign in'
  end

  def logout
    click_link 'Logout' if page.has_content? 'Logout'
  end
end
