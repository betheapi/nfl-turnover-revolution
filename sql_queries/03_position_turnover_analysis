WITH position_turnovers AS (
    SELECT
        season,
        position,
        COUNT(DISTINCT player_id) AS num_players,
        SUM(fumble_forced) AS total_fumbles,
        SUM(interception) AS total_interceptions,
        SUM(fumble_forced + interception) AS total_turnovers
    FROM NFL_Stats
    WHERE 
        season BETWEEN 2019 AND 2024
        AND division IS NOT NULL
        AND position IS NOT NULL
        AND position != 'N/A'
    GROUP BY season, position
),
ranked_positions AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY season ORDER BY total_turnovers DESC) AS rank
    FROM position_turnovers
)
SELECT 
    season,
    position,
    num_players,
    total_fumbles,
    total_interceptions,
    total_turnovers,
    rank
FROM ranked_positions
WHERE rank <= 3
ORDER BY season DESC, rank;

