# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    @players = Player.all
  end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end
end
