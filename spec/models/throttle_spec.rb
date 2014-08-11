require 'rails_helper'

RSpec.describe Throttle, :type => :model do

  describe 'model methods' do

    let(:throttle) {Throttle.new}

    it 'clear? detects whether the user is a real user' do
      user = nil
      expect(throttle.clear?(user)).to be_falsy
    end

    it 'clear? detects if the user is not locked out currently' do
      user = build(:user)
      expect(throttle.clear?(user)).to eq true
    end

    it 'update_failures_status will update the users failures' do
      user = create(:user)
      expect(user.failed_login_attempts.length).to eq 0
      throttle.update_failures_status(user)
      expect(user.failed_login_attempts.length).to eq 1
    end

    it 'update_failures_status will return the right message' do
      user = nil
      expect(throttle.update_failures_status(user)).to eq 'Incorrect email/password combo'
    end

    it 'update_failures_status creates lockout if appropriate and correct message' do
      user = create(:user)
      3.times do
        user.failed_login_attempts.create(time_failed: DateTime.now)
      end
      message = throttle.update_failures_status(user)
      expect(user.locked_out_at).to_not eq nil
      expect(message).to eq 'You are locked out. Please try again later.'
    end
  end


end