class Throttle

  def clear?(user)
    user && !user.is_locked_out?
  end

  def update_failures_status(user)
    user.failed_login_attempts.create!(time_failed: DateTime.now) if user
    if !user || user.has_more_tries?
      'Incorrect email/password combo'
    elsif user.is_locked_out? || user.failures_in_time?
      user.update_attributes(locked_out_at: DateTime.now) unless user.is_locked_out?
      'You are locked out. Please try again later.'
    end
  end
end