SELECT *
FROM {{ ref('dim_hosts_cleansed') }}
WHERE is_superhost NOT IN ('t', 'f')
LIMIT 10
