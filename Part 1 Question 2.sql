SELECT
  c.city_name,
  to_char(e._ts, 'Dy') AS sign_up_dow,
  (SUM(CASE WHEN EXISTS (
         SELECT 1
         FROM trips AS t
         WHERE
           t.client_id = e.rider_id
           AND t.status = 'completed'
           AND t.request_at BETWEEN e._ts AND (e._ts + INTERVAL '168 hours')
       ) THEN 1
       ELSE 0
       END) / COUNT(*)) AS conversion_percent
FROM events AS e
NATURAL JOIN cities AS c
WHERE
  c.city_name IN ('Qarth', 'Meereen')
  AND e.event_name = 'sign_up_success'
  AND e._ts BETWEEN DATE '2016-01-01' AND (DATE '2016-01-01' + INTERVAL '1 week')
GROUP BY
  c.city_name, sign_up_dow;