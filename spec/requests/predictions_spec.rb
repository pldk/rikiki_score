# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Predictions', type: :request do
  describe 'GET /edit' do
    it 'returns http success' do
      get '/predictions/edit'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/predictions/update'
      expect(response).to have_http_status(:success)
    end
  end
end
