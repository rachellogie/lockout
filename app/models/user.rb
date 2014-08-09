class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  validates :password, length: { minimum: 8 }
  validates :password, confirmation: true

  validates :email, uniqueness: true
end
