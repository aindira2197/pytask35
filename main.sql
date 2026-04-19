CREATE TABLE cache (
    id SERIAL PRIMARY KEY,
    key VARCHAR(255) NOT NULL,
    value TEXT NOT NULL,
    expiration_time TIMESTAMP NOT NULL
);

CREATE INDEX idx_cache_key ON cache(key);
CREATE INDEX idx_cache_expiration_time ON cache(expiration_time);

CREATE OR REPLACE FUNCTION get_from_cache(key VARCHAR(255))
RETURNS TEXT AS $$
DECLARE
    result TEXT;
BEGIN
    SELECT value INTO result FROM cache WHERE key = $1 AND expiration_time > NOW();
    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_to_cache(key VARCHAR(255), value TEXT, expiration_time INTERVAL)
RETURNS VOID AS $$
BEGIN
    INSERT INTO cache (key, value, expiration_time) VALUES ($1, $2, NOW() + $3)
    ON CONFLICT (key) DO UPDATE SET value = $2, expiration_time = NOW() + $3;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_from_cache(key VARCHAR(255))
RETURNS VOID AS $$
BEGIN
    DELETE FROM cache WHERE key = $1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_cache_expiration_time(key VARCHAR(255), expiration_time INTERVAL)
RETURNS VOID AS $$
BEGIN
    UPDATE cache SET expiration_time = NOW() + $2 WHERE key = $1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION clean_cache()
RETURNS VOID AS $$
BEGIN
    DELETE FROM cache WHERE expiration_time < NOW();
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cache_size()
RETURNS INTEGER AS $$
DECLARE
    result INTEGER;
BEGIN
    SELECT COUNT(*) INTO result FROM cache;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cache_hit_rate()
RETURNS FLOAT AS $$
DECLARE
    hits INTEGER;
    misses INTEGER;
    total INTEGER;
BEGIN
    SELECT COUNT(*) INTO hits FROM cache WHERE expiration_time > NOW();
    SELECT COUNT(*) INTO misses FROM cache WHERE expiration_time < NOW();
    SELECT COUNT(*) INTO total FROM cache;
    RETURN hits::FLOAT / total;
END;
$$ LANGUAGE plpgsql;