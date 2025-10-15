# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]
  def index
    @players = Player.all
  end

  def show; end

  def new
    @player = Player.new
    @players = Player.all
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @player }
      end
    else
      @players = Player.all
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy
    @player.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @players }
    end
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:name, :description, :rank)
  end
end
