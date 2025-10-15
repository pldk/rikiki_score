# frozen_string_literal: true

class PredictionsController < ApplicationController
  def edit
    @round = Round.find(params[:round_id])
    @game = Game.find(params[:game_id])
    @prediction = Prediction.find(params[:id])
    @player = @prediction.player
  end

  def update
    @prediction = Prediction.find(params[:id])
    if @prediction.update(prediction_params)
      # @prediction.update(score: @prediction.compute_score)
      redirect_to game_round_path(@prediction.round.game, @prediction.round)
    else
      render :edit
    end
  end

  private

  def prediction_params
    params.require(:prediction).permit(:predicted_tricks, :actual_tricks, :is_star)
  end
end
