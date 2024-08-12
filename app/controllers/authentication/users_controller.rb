class Authentication::UsersController < ApplicationController
  # frozen_string_lit
  # eral: true

  skip_before_action :protect_pages
  def new
      @user = User.new
  end


  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to homepage_path
      else
      render :new, status: :unprocessable_content
    end
  end

  private
  def user_params
    params.require(:user).permit(:email,:username, :password)
  end

end

