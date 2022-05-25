-- • Найти решение только на вложенных запросах
SELECT
    id AS video_id,
    (SELECT first_name FROM users WHERE users.id=video.owner_id) AS first_name,
    (SELECT last_name FROM users WHERE users.id=video.owner_id) AS last_name,
    (SELECT
         (SELECT url FROM photo WHERE photo.id=users.main_photo_id)
     FROM users WHERE users.id=video.owner_id) AS main_photo_url,
    url AS video_url,
    size  AS video_size
FROM video
ORDER BY size DESC LIMIT 10;

-- • Найти решение с использованием временной таблицы
CREATE TEMPORARY TABLE big_video (
  id INT,
  url VARCHAR(250),
  size INT,
  owner_id INT
);
INSERT INTO big_video
    SELECT id, url, size, owner_id FROM video ORDER BY size DESC LIMIT 10;

SELECT
    big_video.id AS video_id,
    first_name AS owner_first_name,
    last_name AS owner_last_name,
    photo.url AS main_photo_url,
    big_video.url AS video_url,
    big_video.size AS video_size
FROM users
    JOIN big_video
        ON big_video.owner_id = users.id
    LEFT JOIN photo
        ON photo.id = users.main_photo_id;

-- • Найти решение с использованием общего табличного выражения
WITH big_video AS
  (SELECT id, url, size, owner_id FROM video ORDER BY size DESC LIMIT 10)
SELECT
    big_video.id AS video_id,
    first_name AS owner_first_name,
    last_name AS owner_last_name,
    photo.url AS main_photo_url,
    big_video.url AS video_url,
    big_video.size AS video_size
FROM users
    JOIN big_video
        ON big_video.owner_id = users.id
    LEFT JOIN photo
        ON photo.id = users.main_photo_id
ORDER BY big_video.size DESC;

-- • Найти решение с помощью объединения JOIN
SELECT
    video.id AS video_id,
    first_name AS owner_first_name,
    last_name AS owner_last_name,
    photo.url AS main_photo_url,
    video.url AS video_url,
    video.size AS video_size
FROM users
    JOIN video
        ON video.owner_id = users.id
    LEFT JOIN photo
        ON photo.id = users.main_photo_id
ORDER BY video.size DESC
LIMIT 10;

-- В качестве отчёта сдать код четырёх запросов в виде текста. Для проверки - результат работы всех вариантов должен совпасть.