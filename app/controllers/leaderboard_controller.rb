# app/controllers/leaderboard_controller.rb

require 'sinatra/json'
require_relative './application_controller'

class LeaderboardController < ApplicationController
  before do
    protected!
  end
  
  get '/' do
    # PG SYNTAX: Use DB.exec for queries without parameters.
    result = DB.exec("SELECT * FROM leaderboard ORDER BY points DESC")
    
    leaderboard = result.map do |row|
      row['badges'] = row['badges'] ? row['badges'].split(',') : []
      row
    end
    
    json leaderboard
  end
end
