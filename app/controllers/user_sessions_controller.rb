class UserSessionsController < ApplicationController

  def new

  end

  def create
    if @user = login(params[:email], params[:password])
      flash[:notice] = 'Successfully logged in!'
      redirect_to(root_path)
    else
      flash[:notice] = 'Incorrect email/password combo'
      render :new
    end
  end

  def destroy
    logout
    flash[:notice] = 'Successfully logged out!'
    redirect_to root_path
  end
end