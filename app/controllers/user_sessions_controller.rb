class UserSessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email])
    throttle = Throttle.new

    if throttle.clear?(user) && (@user = login(params[:email], params[:password]))
      @user.reset_failed_attempts
      redirect_to(root_path, notice: 'Successfully logged in!')
    else
      flash[:notice] = throttle.update_failures_status(user)
      render :new
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: 'Successfully logged out!')
  end

end