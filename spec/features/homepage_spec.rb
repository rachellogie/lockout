require 'rails_helper'

feature 'Homepage' do

  scenario 'User can see app name on the homepage' do
    visit root_path
    expect(page).to have_content 'Welcome to Fake App!'
  end
end