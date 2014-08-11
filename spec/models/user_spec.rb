require 'rails_helper'

RSpec.describe User, :type => :model do

  describe 'validations' do

    before do
      @user = build(:user)
      expect(@user).to be_valid
    end

    it 'password must be at least 8 characters long' do
      @user.password = '123'
      @user.password_confirmation = '123'
      expect(@user).to_not be_valid
    end

    it 'password and password confirmation must match' do
      @user.password = 'password1'
      @user.password_confirmation = 'password2'
      expect(@user).to_not be_valid
    end

    it 'user email must be unique' do
      create(:user)
      duplicate_user = build(:user)
      expect(duplicate_user).to_not be_valid
    end

  end

  describe 'user methods' do

    before do
      @keri = create(:user, :email => 'keri@example.com')
      @keri.failed_login_attempts.create!(time_failed: DateTime.now)
    end

    it 'reset failed attempts will clear all attempts' do
      expect(@keri.failed_login_attempts.length).to eq 1
      @keri.reset_failed_attempts
      expect(@keri.failed_login_attempts.length).to eq 0
    end

    it 'has more tries returns true if they have more tries left' do
      expect(@keri.has_more_tries?).to eq true
      @keri.failed_login_attempts.create!(time_failed: DateTime.now)
      @keri.failed_login_attempts.create!(time_failed: DateTime.now)
      expect(@keri.has_more_tries?).to eq false
    end

    it 'is locked out will determine if they are still locked out' do
      expect(@keri.is_locked_out?).to eq false
      @keri.locked_out_at = DateTime.now
      expect(@keri.is_locked_out?).to eq true
    end

    it 'will determine if their failed attempts are within the time constraint' do
      @keri.failed_login_attempts.create!(time_failed: DateTime.now)
      @keri.failed_login_attempts.create!(time_failed: DateTime.now)
      expect(@keri.failures_in_time?).to eq true
    end

  end

end
