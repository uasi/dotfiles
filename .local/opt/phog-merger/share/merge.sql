ATTACH 'remote_db.sqlite3' AS remote;
BEGIN;

INSERT INTO tweets
      (status_id, content, in_timeline, recorded_at, photos_downloaded_at)
SELECT status_id, content, in_timeline, recorded_at, photos_downloaded_at
FROM remote.tweets WHERE TRUE
ON CONFLICT (status_id) DO UPDATE SET photos_downloaded_at = excluded.photos_downloaded_at;

INSERT OR IGNORE INTO pruned_tweets
      (status_id, user_id, screen_name, media, in_timeline, recorded_at, photos_downloaded_at, pruned_at)
SELECT status_id, user_id, screen_name, media, in_timeline, recorded_at, photos_downloaded_at, pruned_at
FROM remote.pruned_tweets;

END;
