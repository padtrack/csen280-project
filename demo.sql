INSERT INTO users (email, name, level) VALUES ('admin@demo.org', 'admin', 'admin');
INSERT INTO users (email, name) VALUES ('demo@example.com', 'demo');
-- won't work because of invalid characters
-- INSERT INTO users (email, name) VALUES ('bad@example.com', '');
-- INSERT INTO users (email, name) VALUES ('bad@example.com', 'user name');

SELECT * FROM users;

-- won't work because user isn't admin
-- INSERT INTO events (user_id, name, currency, hours) VALUES (2, 'comiket_103', 'JPY', '{[2023-12-30 10:00:00+09, 2023-12-30 17:00:00+09], [2023-12-31 10:00:00+09, 2023-12-31 16:00:00+09]}');
INSERT INTO events (user_id, name, currency, hours) VALUES (1, 'comiket_103', 'JPY', '{[2023-12-30 10:00:00+09, 2023-12-30 17:00:00+09], [2023-12-31 10:00:00+09, 2023-12-31 16:00:00+09]}');

SELECT * FROM events;

-- won't work because user isn't verified
-- INSERT INTO merchants (user_id, name, urls) VALUES (2, 'rimukoro', 'twitter=>https://x.com/rimukoro');
UPDATE users SET level = 'verified' WHERE users.id = 2;
SELECT * FROM users WHERE users.id = 2;
INSERT INTO merchants (user_id, name, urls) VALUES (2, 'rimukoro', 'twitter=>https://x.com/rimukoro');

INSERT INTO listings (user_id, event_id, merchant_id, price) VALUES (2, 1, 1, 1500);

SELECT l.id, l.price, e.currency FROM listings l
JOIN events e ON l.event_id = e.id;

INSERT INTO tags (user_id, type, name) VALUES (2, 'general', 'sticker');
-- won't work because name is UNIQUE
-- INSERT INTO tags (user_id, type, name) VALUES (2, 'general', 'sticker');
INSERT INTO tags (user_id, type, name) VALUES (1, 'general', 'chibi');

CALL insert_listing_tags(2, 1, '{sticker, chibi, halo}');
SELECT * FROM listing_tags;
SELECT * FROM tags;

INSERT INTO comments (user_id, listing_id, content) VALUES (2, 1, 'cool comment');
SELECT * FROM comment_scores;

INSERT INTO comment_votes (user_id, comment_id, value) VALUES (1, 1, -1);
SELECT * FROM comments c
JOIN comment_scores cs ON c.id = comment_id;
