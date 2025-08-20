require 'rack/cors'
require_relative './db/connection'

# Require all controllers
require_relative './app/controllers/application_controller'
require_relative './app/controllers/auth_controller'
require_relative './app/controllers/quests_controller'
require_relative './app/controllers/feedback_controller'
require_relative './app/controllers/leaderboard_controller'
require_relative './app/controllers/dashboard_controller'

frontend_origin = ENV['FRONTEND_URL'] || 'http://localhost:3000'

use Rack::Cors do
  allow do
    origins frontend_origin
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end

# Enable and configure cookie-based sessions for all controllers
use Rack::Session::Cookie, {
  key: 'rack.session',
  path: '/',
  expire_after: 2592000, # 30 days in seconds
  secret: ENV['SESSION_SECRET'] || 'a_very_long_and_secure_secret_for_development',
  # --- ADD THESE TWO LINES ---
  same_site: :none, # Allows the cookie to be sent cross-domain
  secure: true      # Requires the connection to be HTTPS (which it is on Render)
}

run Rack::Builder.new {
  map('/auth') { run AuthController }
  map('/quests') { run QuestsController }
  map('/feedback') { run FeedbackController }
  map('/leaderboard') { run LeaderboardController }
  map('/dashboard') { run DashboardController }
}
