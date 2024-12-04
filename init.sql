CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TYPE user_level AS ENUM ('banned', 'default', 'verified', 'contributor', 'moderator', 'admin');
CREATE TYPE tag_type AS ENUM ('character', 'copyright', 'general', 'meta');

CREATE TABLE users (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    email VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(32) NOT NULL UNIQUE,
    level user_level DEFAULT 'default'
);

CREATE TABLE events (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(100) NOT NULL UNIQUE,
    currency CHAR(3),  -- ISO 4217
    hours TSTZMULTIRANGE,
    PRIMARY KEY (id, version)
);

CREATE TABLE merchants (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(32) NOT NULL UNIQUE,
    urls HSTORE,
    PRIMARY KEY (id, version)
);

CREATE TABLE listings (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price NUMERIC(12, 2),
    PRIMARY KEY (id, version)
);

CREATE TABLE tags (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type tag_type,
    name VARCHAR(48) NOT NULL UNIQUE,
    PRIMARY KEY (id, version)
);

CREATE TABLE comments (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY,
    version INT GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    content TEXT NOT NULL,
    PRIMARY KEY (id, version)
);

CREATE TABLE schedules (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users (id),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(64) NOT NULL
);
