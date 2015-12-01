# 1. Explain Stucture of a test
# -> What is feature?
# -> What is scenario?
# -> Explain four phase test.
require 'spec_helper'
require 'capybara/rspec'

feature 'Visitor' do
  scenario 'sign up with valid email and password' do
    # TEST 1
  end

  scenario 'sign up with invalid email' do
    # TEST 2
  end

  end
end

# 2. Demostrate a simple test and introduce some simple syntax
#   -> How to navigate to a page? (visit)
#   -> How to find element on a page?
#   -> How to interact with a page? ( click, click_button, fill_in, hover etc)


require 'spec_helper'
require 'capybara/rspec'

feature 'Visitor' do
  scenario 'with valid email and password' do
    visit new_user_registration_path
    fill_in 'user[username]', with: username if username.present?
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'km_user_register'
  end
end

# 3. Explain what is expectation by showing 'how do we know a test succeed?'
# -> Explain different kind of matchers
# -> expect(page).to vs expect(page).not_to
# -> have_content
# -> eq
# -> be true / be false

require 'spec_helper'
require 'capybara/rspec'

feature 'Visitor' do
  scenario 'with valid email and password' do
    visit new_user_registration_path
    fill_in 'user[username]', with: username if username.present?
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'km_user_register'
    expect(page).to have_content('Select the infographic format you would like to use')
  end
end

# 4.  Run the test. Explain how to run a test.
  rspec spec/features/xxx_spec.rb

# 5. Easy Exercise: Write a Sign out and Sign in expectation by continueing the sign up test.

require 'spec_helper'
require 'capybara/rspec'

feature 'Visitor' do
  scenario 'with valid email and password' do
    visit new_user_registration_path
    fill_in 'user[username]', with: username if username.present?
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'km_user_register'
    expect(page).to have_content('Select the infographic format you would like to use')

    # sign out
    find('.pikto-username').hover
    find('#pikto-menu-logout-btn').click
    click_button('Ok')
    expect(current_path).to eq root_path

    # sign in
    visit new_user_session_path
    fill_in "user[login]", with: user.email
    fill_in "user[password]", with: user.password
    click_button 'km_user_login'
    expect(current_path).to eq '/template'
  end
end
# 6. Split the sign up, sign in, sign out test. Explain what happens between two scenario. ( database cleaner )
feature 'Visitor' do
  scenario 'with valid email and password' do
    visit new_user_registration_path
    fill_in 'user[username]', with: username if username.present?
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'km_user_register'
    expect(page).to have_content('Select the infographic format you would like to use')
  end

  # This will fail
  scenario 'sign in then sign out' do
    visit new_user_session_path
    fill_in "user[login]", with: user.email
    fill_in "user[password]", with: user.password
    click_button 'km_user_login'
    expect(current_path).to eq '/template'
    find('.pikto-username').hover
    find('#pikto-menu-logout-btn').click
    click_button('Ok')
    expect(current_path).to eq root_path
  end
end


# 5. The test failed. (because there's not user inside database)
# -> Use binding.pry and save_and_open_screenshot to debug the test
# -> Use focus

  # This will fail
  scenario 'sign in then sign out' do
    visit new_user_session_path
    fill_in "user[login]", with: user.email
    fill_in "user[password]", with: user.password
    click_button 'km_user_login'
    binding.pry
    expect(current_path).to eq '/template'
    find('.pikto-username').hover
    find('#pikto-menu-logout-btn').click
    click_button('Ok')
    expect(current_path).to eq root_path
  end
end

# 6. Explain what is factory and how we use it to insert data.

feature 'Visitor' do
  scenario 'with valid email and password' do
    visit new_user_registration_path
    fill_in 'user[username]', with: username if username.present?
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'km_user_register'
    expect(page).to have_content('Select the infographic format you would like to use')
  end

  scenario 'sign in then sign out' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in "user[login]", with: user.email
    fill_in "user[password]", with: user.password
    click_button 'km_user_login'
    expect(current_path).to eq '/template'
    find('.pikto-username').hover
    find('#pikto-menu-logout-btn').click
    click_button('Ok')
    expect(current_path).to eq root_path
  end
end

# The second test are really testing two stuff. Demostrate how to refactor the test.

feature 'Visitor' do
  scenario 'with valid email and password' do
    visit new_user_registration_path
    fill_in 'user[username]', with: username if username.present?
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'km_user_register'
    expect(page).to have_content('Select the infographic format you would like to use')
  end

  scenario 'sign in' do
    user = FactoryGirl.create(:user)
    sign_in user
    expect(current_path).to eq '/template'
  end

  scenario 'sign out' do
    user = FactoryGirl.create(:user)
    sign_in user
    sign_out user
    expect(current_path).to eq root_path
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in "user[login]", with: user.email
    fill_in "user[password]", with: user.password
    click_button 'km_user_login'
  end

  def sign_out(user)
    find('.pikto-username').hover
    find('#pikto-menu-logout-btn').click
    click_button('Ok')
  end
end

# Explain what is support file and put the sign_in and sign_out method into a module.

feature 'Visitor' do
  scenario 'with valid email and password' do
    visit new_user_registration_path
    fill_in 'user[username]', with: username if username.present?
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'km_user_register'
    expect(page).to have_content('Select the infographic format you would like to use')
  end

  scenario 'sign in' do
    user = FactoryGirl.create(:user)
    sign_in user
    expect(current_path).to eq '/template'
  end

  scenario 'sign out' do
    user = FactoryGirl.create(:user)
    sign_in user
    sign_out user
    expect(current_path).to eq root_path
  end
end

# support file
module Session
  def sign_in(user)
    visit new_user_session_path
    fill_in "user[login]", with: user.email
    fill_in "user[password]", with: user.password
    click_button 'km_user_login'
  end

  def sign_out(user)
    find('.pikto-username').hover
    find('#pikto-menu-logout-btn').click
    click_button('Ok')
  end
end

# 8. Sign up vs Sign in/Sign out are really two context. Organize the test using context.
# -> Explain what is context
# -> Explain the scope of context

feature 'Visitor' do
  context 'registration' do
    scenario 'with valid email and password' do
      visit new_user_registration_path
      fill_in 'user[username]', with: username if username.present?
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      click_button 'km_user_register'
      expect(page).to have_content('Select the infographic format you would like to use')
    end
  end

  context 'session' do
    scenario 'sign in' do
      user = FactoryGirl.create(:user)
      sign_in user
      expect(current_path).to eq '/template'
    end

    scenario 'sign out' do
      user = FactoryGirl.create(:user)
      sign_in user
      sign_out user
      expect(current_path).to eq root_path
    end
  end
end

# 9. Signout and Signin are using factory. Refactor it by using let.
# -> Explain what is let
# -> Explain the different of let and let!

feature 'Visitor' do
  context 'registration' do
    scenario 'with valid email and password' do
      visit new_user_registration_path
      fill_in 'user[username]', with: username if username.present?
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      click_button 'km_user_register'
      expect(page).to have_content('Select the infographic format you would like to use')
    end
  end

  context 'session' do
    let(:user) { FactoryGirl.create(:user) }
    scenario 'sign in' do
      sign_in user
      expect(current_path).to eq '/template'
    end

    scenario 'sign out' do
      sign_in user
      sign_out user
      expect(current_path).to eq root_path
    end
  end
end

#     sign in and sign out test are using sign_in method, refactor it by using before
#  -> Explain what is before block
#  -> Explain the different between before(:each) and before(:all)

feature 'Visitor' do
  context 'registration' do
    scenario 'with valid email and password' do
      visit new_user_registration_path
      fill_in 'user[username]', with: username if username.present?
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      click_button 'km_user_register'
      expect(page).to have_content('Select the infographic format you would like to use')
    end
  end

  context 'session' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in user }
    scenario 'sign in' do
      expect(current_path).to eq '/template'
    end

    scenario 'sign out' do
      sign_out user
      expect(current_path).to eq root_path
    end
  end
end

# Rewrite the example into steps

feature 'Visitor' do
  context 'registration' do
    scenario 'with valid email and password' do
      visit new_user_registration_path
      fill_in 'user[username]', with: username if username.present?
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      click_button 'km_user_register'
      expect(page).to have_content('Select the infographic format you would like to use')
    end
  end

  context 'session' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) { sign_in user }
    scenario 'sign in' do
      expect(current_path).to eq '/template'
    end

    scenario 'sign out' do
      sign_out user
      expect(current_path).to eq root_path
    end
  end
end
