# frozen_string_literal: true

class HomepageController < ApplicationController

  skip_before_action :protect_pages
  def index
  end
end