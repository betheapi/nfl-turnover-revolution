SELECT 
    season,
    team,
    SUM(fumble_forced) as total_fumbles,
    SUM(interception) as total_interceptions,
    SUM(fumble_forced + interception) as total_turnovers
FROM NFL_Stats
WHERE season BETWEEN 2019 AND 2024
      AND division IS NOT NULL
      AND division != '0'
GROUP BY season, team
ORDER BY season DESC, total_turnovers DESC
LIMIT 4;
---Wanted to not have to scroll through each year looking for the info that I needed so this prompted a crash course on "Window functions". Improved my query beloww
WITH turnover_leaders AS (
    SELECT 
        season,
        team,
        SUM(fumble_forced + interception) as total_turnovers,
        RANK() OVER (PARTITION BY season ORDER BY SUM(fumble_forced + interception) DESC) as rank
    FROM NFL_Stats
    WHERE division IS NOT NULL
    GROUP BY season, team
)
SELECT 
    season,
    team,
    total_turnovers,
    rank
FROM turnover_leaders
WHERE rank <= 2
ORDER BY season DESC, rank;
