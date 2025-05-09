# frozen_string_literal: true

class PlaceBidService
  def initialize(params)
    @round = params[:round]
    @bid = params[:round][:bid]
  end
end
