# frozen_string_literal: true

class PlayersController < ApplicationController
  def index; end

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
end
