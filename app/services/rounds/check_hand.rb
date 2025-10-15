# frozen_string_literal: true

module Rounds
  class CheckHand
    def initialize(params)
      @round = params[:round]
      @bid = params[:round][:bid]
    end
  end
end
