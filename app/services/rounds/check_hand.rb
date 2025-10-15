# frozen_string_literal: true

module Rounds
  class CheckHandService
    def initialize(params)
      @round = params[:round]
      @bid = params[:round][:bid]
    end
  end
end
