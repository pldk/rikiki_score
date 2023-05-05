# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    @players = Player.all
  end

  def show; end

  def new
    @game = Game.new
  end

  def create 
    @game = Game.new(game_params)
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def game_params
    params.require(:game).permit(:status, :style, player_ids: [])
  end
end
