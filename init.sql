CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TYPE user_level AS ENUM ('banned', 'default', 'verified', 'contributor', 'moderator', 'admin');
CREATE TYPE tag_type AS ENUM ('character', 'copyright', 'general', 'meta');

CREATE TABLE users (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(32) NOT NULL UNIQUE,
    level user_level DEFAULT 'default'
);

CREATE TABLE events (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    -- version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name VARCHAR(100) NOT NULL UNIQUE,
    currency CHAR(3),  -- ISO 4217
    hours TSTZMULTIRANGE
);

CREATE TABLE merchants (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    -- version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name VARCHAR(32) NOT NULL UNIQUE,
    urls HSTORE
);

CREATE TABLE listings (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    -- version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    event_id INTEGER REFERENCES events (id),
    merchant_id INTEGER REFERENCES merchants (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    price NUMERIC(12, 2)
);

CREATE TABLE tags (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    -- version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type tag_type,
    name VARCHAR(48) NOT NULL UNIQUE
);

CREATE TABLE listing_tags (
    listing_id INTEGER REFERENCES listings (id),
    tag_id INTEGER REFERENCES tags (id),
    PRIMARY KEY (listing_id, tag_id)
);

CREATE TABLE comments (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    -- version INT GENERATED BY DEFAULT AS IDENTITY,
    replying_to INTEGER REFERENCES comments (id),
    user_id INTEGER REFERENCES users (id),
    listing_id INTEGER REFERENCES listings (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL NOT NULL,
    content TEXT NOT NULL
);

CREATE TABLE comment_votes (
    user_id INTEGER REFERENCES users (id),
    comment_id INTEGER REFERENCES comments (id),
    value INTEGER,
    PRIMARY KEY (user_id, comment_id)
);

CREATE TABLE schedules (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name VARCHAR(64) NOT NULL
);

CREATE TABLE schedule_listings (
    schedule_id INTEGER REFERENCES schedules (id),
    listing_id INTEGER REFERENCES listings (id),
    target TIMESTAMP,  -- NULL is OK, means user hasn't decided
    PRIMARY KEY (schedule_id, listing_id)
);
