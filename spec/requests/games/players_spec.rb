# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games::Players', type: :request do
  let!(:game) { Game.create!(style: 'short') }
  let!(:player) { Player.create!(name: 'Alice') }

  describe 'POST /games/:game_id/players' do
    context 'HTML request' do
      it 'adds a player to the game and redirects' do
        post game_players_path(game),
             params: { player: { name: player.name } },
             headers: { 'ACCEPT' => 'text/html' }

        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include(player.name)
        expect(game.players.reload).to include(player)
      end
    end

    context 'Turbo Stream request' do
      it 'adds a player and responds with turbo stream' do
        post game_players_path(game),
             params: { player: { name: player.name } },
             headers: { 'ACCEPT' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        expect(game.players.reload).to include(player)
      end
    end
  end

  describe 'DELETE /games/:game_id/players/:id' do
    before { game.players << player }

    context 'HTML request' do
      it 'removes a player from the game and redirects' do
        delete game_player_path(game, player),
               headers: { 'ACCEPT' => 'text/html' }

        expect(response).to have_http_status(:redirect)
        expect(game.players.reload).not_to include(player)
      end
    end

    context 'Turbo Stream request' do
      it 'removes a player and responds with turbo stream' do
        delete game_player_path(game, player),
               headers: { 'ACCEPT' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        expect(game.players.reload).not_to include(player)
      end
    end
  end
end
