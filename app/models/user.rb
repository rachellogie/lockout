class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: {minimum: 8}, :on => :create
  validates :password, confirmation: true

  validates :email, uniqueness: true

  has_many :failed_login_attempts


  def failures_in_time?(minutes=5, times=3)
    time_difference = failed_login_attempts.last.time_failed - failed_login_attempts[-times].time_failed
    time_difference < minutes.minutes
  end

  def is_locked_out?(locked_out_time=10)
    return false if locked_out_at.nil?
    diff = TimeDifference.between(Time.now, locked_out_at).in_minutes
    diff <= locked_out_time ? true : reset_lock_out
  end

  def reset_lock_out
    locked_out_at = nil
    false
  end

  def has_more_tries?(times=3)
    (failed_login_attempts.length < times || !failures_in_time?) && !is_locked_out?
  end

  def reset_failed_attempts
    failed_login_attempts.destroy_all
  end

end
