Capybara.default_driver = :selenium

module AuthIntegrationHelper
  def self.included klass
    klass.instance_eval {
      teardown do
        click_link 'Logout' if page.has_content? 'Logout'
      end
    }
  end

  def login_as user
    visit new_player_session_path
    fill_in 'player_username', with: user.username
    fill_in 'player_password', with: 'password'
    click_button 'Sign in'
  end
end
