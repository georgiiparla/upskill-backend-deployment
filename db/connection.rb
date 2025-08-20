require 'pg'

db_url = ENV['DATABASE_URL'] || "postgres://user:password@localhost:5432/your_db_name"

DB = PG.connect(db_url)