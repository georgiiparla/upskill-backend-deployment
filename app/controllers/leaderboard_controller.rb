require 'sinatra/json'
require_relative './application_controller'

class LeaderboardController < ApplicationController
  before do
    protected!
  end
  
  get '/' do
    # PG SYNTAX: Use DB.exec for queries without parameters.
    # The query is simpler now because the 'name' is in the leaderboard table directly.
    result = DB.exec("SELECT * FROM leaderboard ORDER BY points DESC")
    
    leaderboard = result.map do |row|
      row['badges'] = row['badges'] ? row['badges'].split(',') : []
      row
    end
    
    json leaderboard
  end
end