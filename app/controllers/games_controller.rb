# frozen_string_literal: true

class GamesController < ApplicationController
  def board
    @monid1 = params[:mon1]
    @monid2 = params[:mon2]
  end
end
