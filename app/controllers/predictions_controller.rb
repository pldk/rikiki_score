# frozen_string_literal: true

class PredictionsController < ApplicationController
  before_action :set_game, :set_round
  before_action :set_prediction, only: [:update]

  def create
    @prediction = @round.predictions.build(prediction_params)

    if @prediction.save
      format_saved
    else
      format_new
    end
  end

  def update
    if @prediction.update(prediction_params)
      format_saved
    else
      format_edit
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_round
    @round = Round.find(params[:round_id])
  end

  def set_prediction
    @prediction = Prediction.find(params[:id])
  end

  def format_saved
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "prediction_#{@round.id}_#{@prediction.player_id}",
            partial: 'rounds/round_row',
            locals: { prediction: @prediction, round: @round, game: @round.game, player: @prediction.player }
          ),
          turbo_stream.replace(
            "round_stats_#{@round.id}",
            partial: 'rounds/round_stats',
            locals: { round: @round }
          )
        ]
      end
      format.html { redirect_to game_players_path(@round.game), notice: 'Annonce enregistrée !' }
    end
  end

  def format_new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "prediction_#{@round.id}_#{@prediction.player_id}",
          partial: 'predictions/form_predicted',
          locals: { prediction: @prediction, round: @round, game: @round.game, player: @prediction.player }
        )
      end
      format.html { render 'games/players/index', status: :unprocessable_content, locals: { game: @round.game, players: @round.game.players } }
    end
  end

  def format_edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "prediction_#{@round.id}_#{@prediction.player_id}",
          partial: 'predictions/form_actual',
          locals: { prediction: @prediction, round: @round, game: @round.game, player: @prediction.player }
        )
      end
      format.html { render 'games/players/index', status: :unprocessable_content, locals: { game: @round.game, players: @round.game.players } }
    end
  end

  def prediction_params
    params.require(:prediction).permit(:player_id, :predicted_tricks, :actual_tricks, :is_star)
  end
end
