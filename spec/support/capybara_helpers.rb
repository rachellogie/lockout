def login_user
  create(:user)
  visit root_path
  click_link 'Login'
  fill_in 'Email', with: 'bob@example.com'
  fill_in 'Password', with: 'password'
  click_button 'Login'
end