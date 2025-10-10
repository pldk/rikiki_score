# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]
  before_action :set_game, only: %i[new create]
  def index
    @players = Player.all
  end

  def show; end

  def new
    @player = Player.new
  end

  def create
    if params[:player_id].present?
      # Ajout d'un joueur existant
      @player = Player.find(params[:player_id])
      @game.players << @player unless @game.players.include?(@player)
    else
      # Création d'un nouveau joueur
      @player = Player.create(player_params)
      @game.players << @player if @player.save
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @game }
    end
  end

  def edit; end

  def update; end

  def destroy
    @player = @game.players.find(params[:id])
    @game.players.destroy(@player)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @game }
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :description, :rank)
  end

  def set_player
    @player = Player.find(params[:id])
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
