WITH team_sack_totals AS (
    SELECT
        season,
        team,
        SUM(sack) AS total_sacks
    FROM NFL_Stats
    WHERE 
        season BETWEEN 2019 AND 2024
        AND division IS NOT NULL
        AND team IS NOT NULL
    GROUP BY season, team
),
ranked_teams AS (
    SELECT
        season,
        team,
        total_sacks,
        RANK() OVER (
            PARTITION BY season 
            ORDER BY total_sacks DESC
        ) AS team_rank
    FROM team_sack_totals
)
SELECT *
FROM ranked_teams
WHERE team_rank <= 2
ORDER BY season DESC, team_rank;
