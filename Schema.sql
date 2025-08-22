-- 1. Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Subscriptions Table
CREATE TABLE Subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    resolution VARCHAR(50),   -- e.g., 720p, 1080p, 4K
    screens_allowed INT NOT NULL
);

-- 3. UserSubscriptions Table
CREATE TABLE UserSubscriptions (
    user_subscription_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    subscription_id INT REFERENCES Subscriptions(subscription_id),
    start_date DATE NOT NULL,
    end_date DATE
);

-- 4. Movies Table
CREATE TABLE Movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INT,
    duration_minutes INT,
    description TEXT,
    language VARCHAR(50)
);

-- 5. Actors Table
CREATE TABLE Actors (
    actor_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    birth_year INT,
    country VARCHAR(100)
);

-- 6. Genres Table
CREATE TABLE Genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) UNIQUE NOT NULL
);

-- 7. MovieActors (Many-to-Many between Movies and Actors)
CREATE TABLE MovieActors (
    movie_id INT REFERENCES Movies(movie_id),
    actor_id INT REFERENCES Actors(actor_id),
    PRIMARY KEY (movie_id, actor_id)
);

-- 8. MovieGenres (Many-to-Many between Movies and Genres)
CREATE TABLE MovieGenres (
    movie_id INT REFERENCES Movies(movie_id),
    genre_id INT REFERENCES Genres(genre_id),
    PRIMARY KEY (movie_id, genre_id)
);

-- 9. Ratings Table 
CREATE TABLE Ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    movie_id INT REFERENCES Movies(movie_id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
