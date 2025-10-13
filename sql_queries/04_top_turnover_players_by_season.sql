WITH RankedPlayers AS (
    SELECT
        player_name,
        position,
        team,
        season,
        fumble_forced,
        interception,
        (fumble_forced + interception) as total_turnovers,
        ROW_NUMBER() OVER (PARTITION BY season ORDER BY (fumble_forced + interception) DESC) as rank
    FROM NFL_Stats
    WHERE season BETWEEN 2020 AND 2024
          AND division IS NOT NULL
          AND position IS NOT NULL
          AND position != 'N/A'
)
SELECT
    player_name,
    position,
    team,
    season,
    fumble_forced,
    interception,
    total_turnovers
FROM RankedPlayers
WHERE rank <= 5
ORDER BY season DESC, total_turnovers DESC;

--First query wasn't right. It wasn't giving the information that I needed which prompted learning about window functions again. Used them throughout this project


