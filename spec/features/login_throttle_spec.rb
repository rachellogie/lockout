require 'rails_helper'

feature 'login throttle' do

  let(:user) { create(:user) }

  scenario 'if username has 3 incorrect password attempts within five minutes they will be locked out' do
    visit root_path
    expect(user.failed_login_attempts.length).to eq 0
    login_person(user.email, 'wrongpassword1')
    login_person(user.email, 'wrongpassword2')
    expect(page).to have_content 'Incorrect email/password combo'

    login_person(user.email, 'wrongpassword3')
    user.reload

    expect(user.failed_login_attempts.length).to eq 3
    expect(page).to have_content 'locked out'
  end

  scenario 'if user has 3 unsuccessful password attempts in over 5 minutes they will not be locked out' do

    #scaling by 600 will make sleep(.5) mean 5 minutes
    Timecop.scale(600)

    visit root_path
    expect(user.failed_login_attempts.length).to eq 0
    login_person(user.email, 'wrongpassword1')
    login_person(user.email, 'wrongpassword2')
    sleep(0.6)
    login_person(user.email, 'wrongpassword3')
    sleep(0.1)
    login_person(user.email, 'wrongpassword4')
    user.reload

    expect(user.failed_login_attempts.length).to eq 4
    expect(page).to have_content 'Incorrect email/password combo'
  end

  scenario 'after 3 failed attempts within 5 minutes they will be locked out for 10 minutes' do
    #scaling by 600 will make sleep(0.5) mean 5 minutes
    Timecop.scale(600)

    visit root_path
    login_person(user.email, 'wrongpassword1')
    login_person(user.email, 'wrongpassword2')
    login_person(user.email, 'wrongpassword3')
    user.reload
    expect(user.failed_login_attempts.length).to eq 3
    expect(user.locked_out_at).to be_truthy

    sleep(0.7)
    login_person(user.email, 'password')
    user.reload
    expect(user.locked_out_at).to be_truthy
    expect(page).to have_content 'You are locked out. Please try again later.'

    sleep(0.5)
    login_person(user.email, 'password')
    user.reload
    expect(page).to have_content 'Successfully logged in!'
  end

  scenario 'if someone tries to login with a user that isnt in the db it will just say incorrect combo' do
    visit root_path
    login_person('randomperson', 'wrongpassword1')
    expect(page).to have_content 'Incorrect email/password combo'
  end

end