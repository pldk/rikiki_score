# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games::Players', type: :request do

  let!(:game) { Game.create!(style: 'short') }
  let!(:player) { Player.create!(name: 'Alice') }

  describe 'POST /games/:game_id/players' do
    it 'adds a player to the game and redirects' do
      post game_players_path(game), params: { player_id: player.id }
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include(player.name)
      expect(game.players.reload).to include(player)
    end
  end

  describe 'DELETE /games/:game_id/players/:id' do
    before { game.players << player }

    it 'removes a player from the game and redirects' do
      delete game_player_path(game, player)

      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).not_to include(player.name)
      expect(game.players.reload).not_to include(player)
    end
  end
end
