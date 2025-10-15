class PredictionsController < ApplicationController
  before_action :set_round
  before_action :set_prediction, only: [:update]

  def create
    @prediction = @round.predictions.new(prediction_params)

    if @prediction.save
      render turbo_stream: turbo_stream.replace(
        "prediction_#{@round.id}_#{@prediction.player_id}",
        partial: "predictions/form_actual",
        locals: { prediction: @prediction, game: @round.game }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "prediction_#{@round.id}_#{@prediction.player_id}",
        partial: "predictions/form_predicted",
        locals: { round: @round, player: @prediction.player, game: @round.game }
      )
    end
  end

  def update
    if @prediction.update(prediction_params)
      render turbo_stream: turbo_stream.replace(
        "prediction_#{@prediction.round_id}_#{@prediction.player_id}",
        partial: "predictions/form_actual",
        locals: { prediction: @prediction, game: @prediction.round.game }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "prediction_#{@prediction.round_id}_#{@prediction.player_id}",
        partial: "predictions/form_actual",
        locals: { prediction: @prediction, game: @prediction.round.game }
      )
    end
  end

  private

  def set_round
    @round = Round.find(params[:round_id])
  end

  def set_prediction
    @prediction = Prediction.find(params[:id])
  end

  def prediction_params
    params.require(:prediction).permit(:player_id, :predicted_tricks, :actual_tricks, :is_star)
  end
end
