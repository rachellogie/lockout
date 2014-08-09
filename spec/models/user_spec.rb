require 'rails_helper'

RSpec.describe User, :type => :model do

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
