require 'sinatra/json'
require_relative './application_controller'

class FeedbackController < ApplicationController
  before do
    protected!
  end
  
  get '/' do
    page = params.fetch('page', 1).to_i
    limit = params.fetch('limit', 5).to_i
    offset = (page - 1) * limit
    
    user_id = current_user['id']

    # PG SYNTAX: Use exec_params, .first, access by key, and convert to integer
    count_sql = "SELECT COUNT(*) FROM feedback_history WHERE user_id = $1"
    total_count = DB.exec_params(count_sql, [user_id]).first['count'].to_i
    
    # PG SYNTAX: Use exec_params with multiple placeholders
    items_sql = "SELECT * FROM feedback_history WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2 OFFSET $3"
    items_for_page = DB.exec_params(items_sql, [user_id, limit, offset])
    
    has_more = total_count > (offset + items_for_page.ntuples) # .ntuples is the PG equivalent of .length
    
    json({ items: items_for_page.to_a, hasMore: has_more }) # .to_a converts PG::Result to a plain array
  end
end