# app/controllers/application_controller.rb

require 'sinatra/base'
require 'sinatra/json'

class ApplicationController < Sinatra::Base
  # --- Global 500 Error Handler ---
  error do
    puts "ERROR: #{env['sinatra.error'].message}"
    puts env['sinatra.error'].backtrace.join("\n")
    status 500
    json({ error: 'An internal server error occurred.' })
  end

  # --- Global 404 Not Found Handler ---
  not_found do
    status 404
    json({ error: 'Not Found' })
  end

  helpers do
    def current_user
      return @current_user if @current_user
      return nil unless session[:user_id]
      # PG SYNTAX: Use exec_params with $1 placeholder and .first to get a single row.
      sql = "SELECT id, username, email FROM users WHERE id = $1"
      @current_user = DB.exec_params(sql, [session[:user_id]]).first
    end

    def logged_in?
      !current_user.nil?
    end

    def protected!
      halt 401, json({ error: 'Unauthorized' }) unless logged_in?
    end
  end

  # --- JSON Body Parser ---
  before do
    @request_payload = {}
    
    body = request.body.read
    
    unless body.empty?
      begin
        @request_payload = JSON.parse(body)
      rescue JSON::ParserError
        halt 400, json({ error: 'Invalid JSON in request body' })
      end
    end
  end
end
