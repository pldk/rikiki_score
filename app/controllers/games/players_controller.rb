# frozen_string_literal: true

module Games
  class PlayersController < ApplicationController
    def index
      @game = Game.find(params[:game_id])
      @players = @game.players
    end

    def create
      @game = Game.find(params[:game_id])
      player = Player.find(params[:player_id])
      @game.players << player unless @game.players.include?(player)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to new_game_path(@game) }
      end
    end

    def destroy
      @game = Game.find(params[:game_id])
      player = Player.find(params[:id])
      @game.players.delete(player)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to edit_game_path(@game) }
      end
    end
  end
end
