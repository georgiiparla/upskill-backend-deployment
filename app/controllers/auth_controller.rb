require 'sinatra/json'
require 'bcrypt'
require_relative './application_controller'

class AuthController < ApplicationController
  # SIGN UP a new user
  post '/signup' do
    username = @request_payload['username']
    email = @request_payload['email']
    password = @request_payload['password']

    if username.nil? || email.nil? || password.nil?
      halt 400, json({ error: 'Username, email, and password are required' })
    end

    # PG SYNTAX: Use exec_params with $1 and .first
    existing_user = DB.exec_params("SELECT * FROM users WHERE email = $1", [email]).first
    if existing_user
      halt 409, json({ error: 'User with this email already exists' })
    end

    password_digest = BCrypt::Password.create(password)

    # PG SYNTAX: Use exec_params with $1, $2, $3 placeholders
    DB.exec_params(
      "INSERT INTO users (username, email, password_digest) VALUES ($1, $2, $3)",
      [username, email, password_digest]
    )

    status 201
    json({ message: 'User created successfully' })
  end

  # LOGIN an existing user
  post '/login' do
    email = @request_payload['email']
    password = @request_payload['password']

    if email.nil? || password.nil?
      halt 400, json({ error: 'Email and password are required' })
    end

    # PG SYNTAX: Use exec_params with $1 and .first
    user = DB.exec_params("SELECT * FROM users WHERE email = $1", [email]).first

    if user && BCrypt::Password.new(user['password_digest']) == password
      session[:user_id] = user['id']
      json({ message: 'Logged in successfully', user: { id: user['id'], username: user['username'], email: user['email'] } })
    else
      halt 401, json({ error: 'Invalid email or password' })
    end
  end

  # LOGOUT the current user
  post '/logout' do
    session.clear
    json({ message: 'Logged out successfully' })
  end

  # Check the current user's session status
  get '/profile' do
    if logged_in?
      json({ logged_in: true, user: current_user })
    else
      json({ logged_in: false })
    end
  end
end