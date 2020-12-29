SELECT
  c.city_name,
  -- Potentially interpolated 90th percentile
  percentile_cont(0.9) WITHIN GROUP (ORDER BY (t.actual_eta - t.predicted_eta)) AS p90_eta_error,
  -- The first value in the ordered set that meets or exceeds the 90th percentile
  percentile_disc(0.9) WITHIN GROUP (ORDER BY (t.actual_eta - t.predicted_eta)) AS p90_or_greater_eta_error_value
FROM trips AS t
NATURAL JOIN cities AS c
WHERE
  c.city_name IN ('Qarth', 'Meereen')
  AND t.status = 'completed'
  AND t.request_at BETWEEN (CURRENT_TIMESTAMP - INTERVAL '30 days') AND CURRENT_TIMESTAMP
GROUP BY c.city_name;