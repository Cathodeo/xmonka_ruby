class Authentication::UsersController < ApplicationController
  # frozen_string_literal: true
  def new
      @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
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

