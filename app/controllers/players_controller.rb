# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
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
      redirect_to players_path
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
end
