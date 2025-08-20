# app/controllers/dashboard_controller.rb

require 'sinatra/json'
require_relative './application_controller'

class DashboardController < ApplicationController
  before do
    protected!
  end

  get '/' do
    # PG SYNTAX: Use DB.exec for queries without parameters.
    agenda_items = DB.exec("SELECT * FROM agenda_items ORDER BY due_date ASC")
    activity_stream = DB.exec("SELECT * FROM activity_stream ORDER BY id DESC LIMIT 5")
    meetings = DB.exec("SELECT * FROM meetings ORDER BY meeting_date DESC")

    mock_activity_data = {
      personal: {
        quests:   { allTime: 5, thisWeek: 1 },
        feedback: { allTime: 8, thisWeek: 3 },
        points:   { allTime: 1250, thisWeek: 75 },
        streak:   14
      },
      team: {
        quests:   { allTime: 256, thisWeek: 12 },
        feedback: { allTime: 891, thisWeek: 34 },
      }
    }

    json({
      agendaItems: agenda_items.to_a,
      activityStream: activity_stream.to_a,
      meetings: meetings.to_a,
      activityData: mock_activity_data
    })
  end
end
