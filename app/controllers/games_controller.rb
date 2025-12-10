# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy start]

  def index
    @games = Game.all
  end

  def show
    @game_players = @game.players
    @remaining_players = Player.all - @game.players
    @rounds = @game.rounds

    @player_totals = @game.players.index_with do |player|
      Score.for_game(@game).for_player(player).last&.cumulative_value || 0
    end
    @best_score = @player_totals.values.max
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to new_game_player_path(@game)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @game.update(game_params)
      redirect_to @game
    else
      render :edit
    end
  end

  def destroy
    @game.destroy
    redirect_to games_path
  end

  def start
    @game.start_game!
    redirect_to game_players_path(@game), notice: 'La partie commence 🃏'
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:status, :style, :stars, players_attributes: [:username])
  end
end
