# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy start]
  def index
    @games = Game.all
    @players = Player.all
  end

  def show
    @game = Game.find(params[:id])
    @players = Player.all
    # @game_players = @game.players
    @rounds = @game.rounds.order(:position)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to edit_game_path(@game)
    else
      render :new
    end
  end

  def edit
    @players = Player.all
  end

  def update
    @players = Player.all
    if @game.update(game_params)
      redirect_to @game
    else
      render :edit
    end
  end

  def start
    if @game.players.count < 3
      redirect_to edit_game_path(@game), alert: "Il faut au moins 3 joueurs pour commencer une partie."
      return
    end

    @game.update!(status: :active)

    first_round = @game.rounds.create!(
      position: 1,
      phase: :ascending, # ou une méthode pour le déterminer
    )

    # Crée une participation vide pour chaque joueur
    @game.players.each do |player|
      first_round.predictions.create!(player: player)
    end

    redirect_to game_round_path(@game, first_round), notice: "La partie a commencé !"
  end

  def destroy; end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:status, :style, :stars, players_attributes: [:username])
  end
end
