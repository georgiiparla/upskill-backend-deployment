# app/controllers/quests_controller.rb

require 'sinatra/json'
require_relative './application_controller'

class QuestsController < ApplicationController
  before do
    protected!
  end
  
  get '/' do
    # PG SYNTAX: Use DB.exec for queries without parameters.
    result = DB.exec("SELECT * FROM quests ORDER BY id ASC")
    
    quests = result.map do |row|
      row['completed'] = row['completed'] == 1
      row
    end
    
    json quests
  end
end
