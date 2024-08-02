class Authentication::UsersController < ApplicationController
  # frozen_string_literal: true
  def new
      @user = User.new
  end

  def create

  end
end

