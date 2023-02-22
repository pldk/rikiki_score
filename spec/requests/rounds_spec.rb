# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rounds', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/games/:game_id/rounds/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/games/:game_id/rounds/show'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/games/:game_id/rounds/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/games/:game_id/rounds/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get '/games/:game_id/rounds/edit'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/games/:game_id/rounds/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/games/:game_id/rounds/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
