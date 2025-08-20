require_relative './db/connection'

namespace :db do
  desc "Setup the database: load schema and seed"
  task :setup do
    puts "Loading schema for PostgreSQL..."
    Rake::Task['db:schema'].invoke

    puts "Seeding data..."
    Rake::Task['db:seed'].invoke
    
    puts "Database setup complete."
  end

  desc "Load the database schema"
  task :schema do
    sql = File.read('db/schema.sql')
    # Use DB.exec for the 'pg' gem instead of execute_batch
    DB.exec(sql)
    puts "Schema loaded."
  end

  desc "Seed the database with initial data"
  task :seed do
    sql = File.read('db/seeds.sql')
    # Use DB.exec for the 'pg' gem
    DB.exec(sql)
    puts "Data seeded."
  end
end