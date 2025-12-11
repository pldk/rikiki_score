# frozen_string_literal: true

module Games
  class PlayersController < ApplicationController
    before_action :set_game

    def index
      @players = @game.players
      @last_player_score = @game.players.index_with do |player|
        Score.for_game(@game).for_player(player).last&.cumulative_value
      end

      @best_score = @last_player_score.values.max

      @current_round = @game.current_round
      @previous_round = Round.where("position < ?", @current_round.position).order(:position).last
      @best_score_last_round = @previous_round.scores.maximum(:cumulative_value)

    end

    def new
      @players = Player.all
      @player = Player.new
    end

    def create
      player = Player.find_or_create_by(name: player_params[:name])

      unless @game.players.include?(player)
        position = @game.game_players.count
        @game.game_players.create!(player: player, position: position)
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to new_game_player_path(@game) }
      end
    end

    def destroy
      player = @game.game_players.find_by(player_id: params[:id])
      @game.game_players.delete(player)

      @game.game_players.order(:position).each_with_index do |game_player, index|
        game_player.update_column(:position, index)
      end

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
