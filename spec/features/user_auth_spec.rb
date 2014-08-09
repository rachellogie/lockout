require 'rails_helper'

feature 'user auth' do

  scenario 'user can register' do
    visit root_path
    click_link 'Register'
    fill_in 'Email', with: 'bob@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Register'
    expect(page).to have_content 'Successfully Registered!'
  end

  scenario 'user sees errors if registration unsuccessful' do
    visit root_path
    click_link 'Register'
    fill_in 'Email', with: 'bob@example.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'
    click_button 'Register'
    expect(page).to have_content 'Password is too short'
  end
end