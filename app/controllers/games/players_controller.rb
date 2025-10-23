# frozen_string_literal: true

module Games
  class PlayersController < ApplicationController
    before_action :set_game

    def index
      @players = @game.players
    end

    def new
      @players = Player.all
      @player = Player.new
    end

    def create
      player = Player.find_or_create_by(name: player_params[:name])
      @game.players << player unless @game.players.include?(player)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to new_game_player_path(@game) }
      end
    end

    def destroy
      player = @game.players.find(params[:id])
      @game.players.delete(player)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to new_game_player_path(@game) }
      end
    end

    private

    def set_game
      @game = Game.find(params[:game_id])
    end

    def player_params
      params.require(:player).permit(:name, :description)
    end
  end
end
