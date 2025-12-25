-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    role VARCHAR(20) DEFAULT 'user'
);

-- Listings Table (Skills/Tools/Jobs)
CREATE TABLE listings (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    description TEXT,
    category VARCHAR(50),
    price DECIMAL(10,2),
    is_approved BOOLEAN DEFAULT false,
    owner_id INTEGER REFERENCES users(id)
);
