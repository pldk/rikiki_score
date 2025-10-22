# frozen_string_literal: true

class PredictionsController < ApplicationController
  before_action :set_round
  before_action :set_prediction, only: [:update]

  def create
    @prediction = @round.predictions.build(prediction_params)

    if @prediction.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to game_round_path(@round.game, @round), notice: 'Prédiction enregistrée !' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@prediction, :form),
            partial: 'predictions/form_predicted',
            locals: { prediction: @prediction, round: @round, game: @round.game }
          )
        end
        format.html do
          flash.now[:alert] = @prediction.errors.full_messages.to_sentence
          render 'rounds/show', status: :unprocessable_entity
        end
      end
    end
  end

  def update
    return unless @prediction.update(prediction_params)

    render turbo_stream: turbo_stream.replace(
      "prediction_#{@prediction.round_id}_#{@prediction.player_id}",
      partial: 'predictions/form_actual',
      locals: { prediction: @prediction, game: @prediction.round.game }
    )
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
