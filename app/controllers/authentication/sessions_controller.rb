# frozen_string_literal: true

class Authentication::SessionsController < ApplicationController

  skip_before_action :protect_pages
  def new
  end

  def create
    @user = User.find_by("email = :login OR username = :login", {login: params[:login]})

    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to homepage_path, notice: t('.created')
    else
      redirect_to new_session_path, alert: t('.wrong_credentials')
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :username)
  end

  end
