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
    @player = Player.new(player_params)
    if @player.save 
      game.players << @player unless game.players.include?(@player)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to edit_game_path(game), notice: "Joueur créé et ajouté à la partie." }
      end
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy; end

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
