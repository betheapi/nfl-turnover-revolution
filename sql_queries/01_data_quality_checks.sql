--How many records do I have?--
SELECT COUNT(*) as total_records FROM NFL_Stats;
--How many records have missing divisions?--
SELECT
    COUNT(*) as total,
    COUNT(CASE WHEN division IS NULL OR division = '0' OR division = '' THEN 1 END) as missing_division,
    ROUND(100.0 * COUNT(CASE WHEN division IS NULL OR division = '0' OR division = '' THEN 1 END) / COUNT(*), 2) as pct_missing
FROM NFL_Stats;
-- Query 3: What seasons do you have data for?
SELECT season, COUNT(*) as records
FROM NFL_Stats
GROUP BY season
ORDER BY season;
--CHecked for nulls in the columns that I'm using for my defensive formula--
SELECT 
    COUNT(*) as total_records,
    
    -- Identity columns
    COUNT(*) - COUNT(player_id) as null_player_id,
    COUNT(*) - COUNT(player_name) as null_player_name,
    COUNT(*) - COUNT(team) as null_team,
    COUNT(*) - COUNT(position) as null_position,
    
    -- Organizational columns
    COUNT(*) - COUNT(division) as null_division,
    COUNT(*) - COUNT(conference) as null_conference,
    COUNT(*) - COUNT(season) as null_season,
    
    -- Key defensive stats
    COUNT(*) - COUNT(sack) as null_sack,
    COUNT(*) - COUNT(interception) as null_interception,
    COUNT(*) - COUNT(fumble_forced) as null_fumble_forced,
    COUNT(*) - COUNT(solo_tackle) as null_solo_tackle,
	COUNT(*) - COUNT(qb_hit) as null_qb_hit,
    
    -- Draft info
    COUNT(*) - COUNT(draft_year) as null_draft_year,
    COUNT(*) - COUNT(draft_round) as null_draft_round,
	COUNT(*) - COUNT(draft_pick) as null_draft_pick,
    COUNT(*) - COUNT(college) as null_college

FROM NFL_Stats;

--Since the above query returned 0 for everything. Running more queries to look for other ways null values display--
SELECT 
    COUNT(*) as total_records,
    
    -- Check for empty strings in division
    COUNT(CASE WHEN division = '' THEN 1 END) as empty_string_division,
    
    -- Check for '0' as missing marker
    COUNT(CASE WHEN division = '0' THEN 1 END) as zero_division,
    
    -- Check for actual NULL
    COUNT(CASE WHEN division IS NULL THEN 1 END) as null_division,
    
    -- Check for whitespace only
    COUNT(CASE WHEN TRIM(division) = '' THEN 1 END) as whitespace_division,
    
    -- Repeat for college
    COUNT(CASE WHEN college = '' THEN 1 END) as empty_string_college,
    COUNT(CASE WHEN college IS NULL THEN 1 END) as null_college,
	
	--Repeat for sack, qb_hit, interception, fumble_forced, solo_tackle, player_id, player_name, team, position, conference, season
	COUNT(CASE WHEN sack = '' THEN 1 END) as empty_sack,
    COUNT(CASE WHEN sack IS NULL THEN 1 END) as null_sack
	
FROM NFL_Stats;

--Query above yielded 4676 zero_division, so running a new query to see the percentage
SELECT 
    MIN(season) as earliest_season,
    MAX(season) as latest_season,
    COUNT(DISTINCT season) as num_seasons
FROM NFL_Stats
WHERE division != '0';

SELECT COUNT(*) as usable_records
FROM NFL_Stats
WHERE division != '0';
--DATA QUALITY ASSESSMENT - Day 1
================================
Date: September 30, 2025

DATASET OVERVIEW:
- Total Records: 117,993
- Data Source: NFL Defensive Player Statistics
- Time Period: 2012-2024 (13 complete seasons)

COMPLETENESS ANALYSIS:

Missing Value Encoding:
- Dataset uses '0' (string zero) to represent missing values, NOT NULL
- No traditional NULL values found across key columns
-288 players didn't have a position listed

Division Data Quality:
- Records with missing division (division = '0'): 4,676
- Percentage missing: 3.96%
- Usable records after filtering: 113,317 (96.04% of dataset)

Decision: Filter records using WHERE division != '0'
Rationale: Division is critical for team-level defensive analysis. 
Only 4% data loss is acceptable trade-off for complete team/division assignments.

Season Coverage:
- Earliest season: 2012
- Latest season: 2024
- Total seasons: 13
- Coverage appears complete with no gaps

Data Quality Summary:
- HIGH QUALITY dataset with minimal missing data
- Consistent encoding of missing values
- Complete temporal coverage for analysis period
- 113,317 records available for team/division-level defensive analysis

Next Steps:
- All future queries will include: WHERE division != '0'
- Proceed with team-level turnover analysis using filtered dataset
