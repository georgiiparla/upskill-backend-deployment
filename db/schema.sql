-- Drop tables if they exist to ensure a clean slate
DROP TABLE IF EXISTS users, quests, feedback_history, leaderboard, agenda_items, activity_stream, meetings CASCADE;

-- Create the users table for authentication
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_digest TEXT NOT NULL
);

-- Create the quests table
CREATE TABLE quests (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    points INTEGER,
    progress INTEGER,
    completed INTEGER DEFAULT 0 -- Using 0 for false, 1 for true
);

-- Create the feedback_history table
CREATE TABLE feedback_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER, -- Link to the user who submitted it
    subject TEXT,
    content TEXT,
    created_at TEXT, -- Storing date as text in YYYY-MM-DD format
    sentiment TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create the leaderboard table
CREATE TABLE leaderboard (
    id SERIAL PRIMARY KEY,
    name TEXT,
    points INTEGER,
    badges TEXT -- Storing badges as a comma-separated string
);

-- Create agenda_items table for the dashboard
CREATE TABLE agenda_items (
    id SERIAL PRIMARY KEY,
    type TEXT, -- 'article' or 'meeting'
    title TEXT,
    category TEXT,
    due_date TEXT
);

-- Create activity_stream table for the dashboard
CREATE TABLE activity_stream (
    id SERIAL PRIMARY KEY,
    user_name TEXT,
    action TEXT,
    created_at TEXT
);

-- Create meetings table for the dashboard
CREATE TABLE meetings (
    id SERIAL PRIMARY KEY,
    title TEXT,
    meeting_date TEXT,
    status TEXT -- 'Upcoming' or 'Complete'
);
