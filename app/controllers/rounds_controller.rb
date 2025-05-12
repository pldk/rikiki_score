# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :set_game
  def index
    @rounds = @game.rounds.order(:position)
  end

  def new
    @round = Round.new
  end

  def create
    @round = @game.rounds.build(round_params)
    @round.position = @game.rounds.count
    if @round.save
      @game.players.each do |player|
        Prediction.create(round: @round, player: player)
      end
      redirect_to game_round_path(@game, @round)
    else
      render :new
    end
  end

  def show
    @round = @game.rounds.find(params[:id])
    @predictions = @round.predictions.includes(:player)
  end

  private

  def round_params
    params.require(:round).permit(:length)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
