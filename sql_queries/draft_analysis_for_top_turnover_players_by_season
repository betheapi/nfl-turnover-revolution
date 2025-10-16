WITH player_rankings AS (
    SELECT
        season,
        player_name,
        position,
        draft_round,
        (fumble_forced + interception) as total_turnovers,
        RANK() OVER (
            PARTITION BY season 
            ORDER BY (fumble_forced + interception) DESC
        ) as player_rank
    FROM NFL_Stats
    WHERE season BETWEEN 2012 AND 2024
          AND division IS NOT NULL
          AND (fumble_forced + interception) > 0  -- Only players with turnovers
)
SELECT 
    season,
    player_name,
    position,
    CASE 
        WHEN draft_round = 0 THEN 'Undrafted'
        ELSE CAST(draft_round AS VARCHAR)
    END as draft_status,
    total_turnovers
FROM player_rankings
WHERE player_rank <= 5
ORDER BY season DESC, player_rank;


