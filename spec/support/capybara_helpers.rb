def login_person(email='bob@example.com', password='password')
  visit root_path
  click_link 'Login'
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Login'
end
