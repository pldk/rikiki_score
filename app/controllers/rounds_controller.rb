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
    @players = @game.players.order(:id)
    @predictions = @round.predictions.includes(:player)
  end

  # def edit
  #   @round = @game.rounds.find(params[:id])
  #   @predictions = @round.predictions.includes(:player)
  #   @players = @game.players.order(:id)
  #   @predictions_by_player = @predictions.group_by(&:player_id)
  #   @predictions_by_player.each do |player_id, predictions|
  #     # Sort predictions by their position in the round
  #     @predictions_by_player[player_id] = predictions.sort_by(&:position)
  #   end
  #   @predictions_by_player = @predictions_by_player.sort_by { |_, predictions| predictions.first.position }
  #   @predictions_by_player = Hash[@predictions_by_player]
  # end

  # def update
  #   @round = Round.find(params[:id])
  #   params[:predictions]&.each do |id, attrs|
  #     prediction = Prediction.find(id)
  #     prediction.update(
  #       predicted_tricks: attrs[:predicted_tricks],
  #       actual_tricks: attrs[:actual_tricks],
  #       is_star: ActiveModel::Type::Boolean.new.cast(attrs[:is_star])
  #     )
  #   end
  #   redirect_to game_round_path(@round.game, @round), notice: "Prédictions mises à jour"
  # end

  private

  def round_params
    params.require(:round).permit(:length)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
