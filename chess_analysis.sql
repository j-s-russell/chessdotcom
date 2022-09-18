DESCRIBE chess.chess_games;
SELECT * FROM chess.chess_games;

/* DATA CLEANING */

-- Usernames won't be needed for analysis
ALTER TABLE chess.chess_games
DROP w_user,
DROP b_user,
DROP MyUnknownColumn;


-- In some games, players decide to quit during the opening, so these games can be removed
-- Each move for white includes a period, e.g. "3. d4", and each move for black includes 3 periods,
-- so we can count the moves by counting the occurances of "." and "...":
SELECT 
	gameID,
	w_result, 
	b_result, 
    moves,
    LENGTH(moves) - LENGTH(REPLACE(moves, '...', '.')) AS move_count
FROM chess.chess_games
ORDER BY LENGTH(moves) ASC
LIMIT 100;

-- We'll set the cutoff at 6 moves since there are 6-move checkmates in the data
DELETE FROM chess.chess_games
WHERE LENGTH(moves) - LENGTH(REPLACE(moves, '...', '.')) < 6;


/* DATA EXPLORATION/ANALYSIS */

-- Summary statistics for numerical variables
SELECT 'max',
	ROUND(MAX(w_rating)) as w_rating,
    ROUND(MAX(w_rapid_rating)) as w_rapid_rating,
    ROUND(MAX(w_blitz_rating)) as w_blitz_rating,
    ROUND(MAX(w_bullet_rating)) as w_bullet_rating,
    ROUND(MAX(w_tactics_rating)) as w_tactics_rating,
    ROUND(MAX(w_rush_rating)) as w_rush_rating,
    ROUND(MAX(w_accuracy)) as w_accuracy,
    
	ROUND(MAX(b_rating)) as b_rating,
    ROUND(MAX(b_rapid_rating)) as b_rapid_rating,
    ROUND(MAX(b_blitz_rating)) as b_blitz_rating,
    ROUND(MAX(b_bullet_rating)) as b_bullet_rating,
    ROUND(MAX(b_tactics_rating)) as b_tactics_rating,
    ROUND(MAX(b_rush_rating)) as b_rush_rating,
    ROUND(MAX(b_accuracy)) as b_accuracy
FROM chess.chess_games
UNION
SELECT 'average',
	ROUND(AVG(w_rating)) as w_rating,
    ROUND(AVG(w_rapid_rating)) as w_rapid_rating,
    ROUND(AVG(w_blitz_rating)) as w_blitz_rating,
    ROUND(AVG(w_bullet_rating)) as w_bullet_rating,
    ROUND(AVG(w_tactics_rating)) as w_tactics_rating,
    ROUND(AVG(w_rush_rating)) as w_rush_rating,
    ROUND(AVG(w_accuracy)) as w_accuracy,
    
	ROUND(AVG(b_rating)) as b_rating,
    ROUND(AVG(b_rapid_rating)) as b_rapid_rating,
    ROUND(AVG(b_blitz_rating)) as b_blitz_rating,
    ROUND(AVG(b_bullet_rating)) as b_bullet_rating,
    ROUND(AVG(b_tactics_rating)) as b_tactics_rating,
    ROUND(AVG(b_rush_rating)) as b_rush_rating,
    ROUND(AVG(b_accuracy)) as b_accuracy
FROM chess.chess_games
UNION
SELECT 'min',
	ROUND(MIN(w_rating)) as w_rating,
    ROUND(MIN(w_rapid_rating)) as w_rapid_rating,
    ROUND(MIN(w_blitz_rating)) as w_blitz_rating,
    ROUND(MIN(w_bullet_rating)) as w_bullet_rating,
    ROUND(MIN(w_tactics_rating)) as w_tactics_rating,
    ROUND(MIN(w_rush_rating)) as w_rush_rating,
    ROUND(MIN(w_accuracy)) as w_accuracy,
    
	ROUND(MIN(b_rating)) as b_rating,
    ROUND(MIN(b_rapid_rating)) as b_rapid_rating,
    ROUND(MIN(b_blitz_rating)) as b_blitz_rating,
    ROUND(MIN(b_bullet_rating)) as b_bullet_rating,
    ROUND(MIN(b_tactics_rating)) as b_tactics_rating,
    ROUND(MIN(b_rush_rating)) as b_rush_rating,
    ROUND(MIN(b_accuracy)) as b_accuracy
FROM chess.chess_games
UNION
SELECT 'stdev',
	ROUND(STD(w_rating)) as w_rating,
    ROUND(STD(w_rapid_rating)) as w_rapid_rating,
    ROUND(STD(w_blitz_rating)) as w_blitz_rating,
    ROUND(STD(w_bullet_rating)) as w_bullet_rating,
    ROUND(STD(w_tactics_rating)) as w_tactics_rating,
    ROUND(STD(w_rush_rating)) as w_rush_rating,
    ROUND(STD(w_accuracy)) as w_accuracy,
    
	ROUND(STD(b_rating)) as b_rating,
    ROUND(STD(b_rapid_rating)) as b_rapid_rating,
    ROUND(STD(b_blitz_rating)) as b_blitz_rating,
    ROUND(STD(b_bullet_rating)) as b_bullet_rating,
    ROUND(STD(b_tactics_rating)) as b_tactics_rating,
    ROUND(STD(b_rush_rating)) as b_rush_rating,
    ROUND(STD(b_accuracy)) as b_accuracy
FROM chess.chess_games;


-- Value counts for categorical variables
SELECT tc, COUNT(*) AS count
FROM chess.chess_games
GROUP BY tc
ORDER BY count DESC;

SELECT timeclass, COUNT(*) AS count
FROM chess.chess_games
GROUP BY timeclass
ORDER BY count DESC;

SELECT w_result, COUNT(*) AS count
FROM chess.chess_games
GROUP BY w_result
ORDER BY count DESC;

SELECT b_result AS 'Black Results', COUNT(*) as count
FROM chess.chess_games
GROUP BY b_result
ORDER BY COUNT(*) DESC;


-- Null value counts
SELECT 'null_count',
	SUM(ISNULL(gameID)) as gameID,
    SUM(ISNULL(tc)) as tc,
    SUM(ISNULL(timeclass)) as timeclass,
    SUM(ISNULL(w_accuracy)) as w_accuracy,
    SUM(ISNULL(b_accuracy)) as b_accuracy,
    SUM(ISNULL(w_rating)) as w_rating,
    SUM(ISNULL(b_rating)) as b_rating,
    SUM(ISNULL(w_result)) as w_result,
    SUM(ISNULL(b_result)) as b_result,
    SUM(ISNULL(w_user)) as w_user,
    SUM(ISNULL(b_user)) as b_user,
    SUM(ISNULL(w_rapid_wins)) as w_rapid_wins,
    SUM(ISNULL(w_rapid_losses)) as w_rapid_losses,
    SUM(ISNULL(w_rapid_draws)) as w_rapid_draws,
    SUM(ISNULL(w_blitz_rating)) as w_blitz_rating,
    SUM(ISNULL(w_blitz_wins)) as w_blitz_wins,
    SUM(ISNULL(w_blitz_losses)) as w_blitz_losses,
    SUM(ISNULL(w_blitz_draws)) as w_blitz_draws,
    SUM(ISNULL(w_bullet_rating)) as w_bullet_rating,
    SUM(ISNULL(w_bullet_wins)) as w_bullet_wins,
    SUM(ISNULL(w_bullet_losses)) as w_bullet_losses,
    SUM(ISNULL(w_bullet_draws)) as w_bullet_draws,
    SUM(ISNULL(w_tactics_rating)) as w_tactics_rating,
    SUM(ISNULL(w_rush_rating)) as w_rush_rating,
    SUM(ISNULL(b_rapid_rating)) as b_rapid_rating,
    SUM(ISNULL(b_rapid_wins)) as b_rapid_wins,
    SUM(ISNULL(b_rapid_losses)) as b_rapid_losses,
    SUM(ISNULL(b_rapid_draws)) as brapid_draws,
    SUM(ISNULL(b_blitz_rating)) as bblitz_rating,
    SUM(ISNULL(b_blitz_wins)) as bblitz_wins,
    SUM(ISNULL(b_blitz_losses)) as b_blitz_losses,
    SUM(ISNULL(b_blitz_draws)) as b_blitz_draws,
    SUM(ISNULL(b_bullet_rating)) as bbullet_rating,
    SUM(ISNULL(b_bullet_wins)) as bbullet_wins,
    SUM(ISNULL(b_bullet_losses)) as bbullet_losses,
    SUM(ISNULL(b_bullet_draws)) as b_bullet_draws,
    SUM(ISNULL(b_tactics_rating)) as b_tactics_rating,
    SUM(ISNULL(b_rush_rating)) as b_rush_rating,
    SUM(ISNULL(w_rapid_rating)) as w_rapid_rating,
    SUM(ISNULL(moves)) as moves,
    SUM(ISNULL(opening)) as opening
FROM chess.chess_games;


-- First move
SELECT 
	TRIM(TRAILING ' ' 
	FROM SUBSTR(moves, 3, 5)) AS first_move,
    COUNT(*),
    ROUND(100 * SUM(w_result = 'win') / COUNT(w_result)) AS win_percent
FROM chess.chess_games
GROUP BY first_move
ORDER BY COUNT(*) DESC;
-- e4 is a consistent favorite, appearing as the first move in
-- over half of the table's games

-- First mover advantage?
SELECT 
	ROUND(100 * SUM(w_result = 'win') / COUNT(w_result)) AS w_win_percent,
	ROUND(100 * SUM(b_result = 'win') / COUNT(b_result)) AS b_win_percent
FROM chess.chess_games;
-- As commonly noted, white has a slight advantage of about 2%

-- How important is castling in order to win?
-- White castles:
SELECT
	(LENGTH(moves) - LENGTH(REPLACE(moves, '. O-O', ''))) > (LENGTH(moves) - LENGTH(REPLACE(moves, '... O-O', '')))  AS white_castle,
    COUNT(*) AS count,
    ROUND(100 * SUM(w_result = 'win') / COUNT(w_result)) AS win_percent
FROM chess.chess_games
GROUP BY white_castle
ORDER BY count DESC;

-- Black castles:
SELECT
	(LENGTH(moves) > LENGTH(REPLACE(moves, '... O-O', ''))) AS black_castle,
    COUNT(*) AS count,
    ROUND(100 * SUM(b_result = 'win') / COUNT(b_result)) AS win_percent
FROM chess.chess_games
GROUP BY black_castle
ORDER BY count DESC;

-- Evidently, castling significantly increases the likelihood of winning - in this
-- case by about 6-8%


-- Puzzle Ratings and Short Time Controls:

-- Puzzle ratings are based on being able to find the best line in any given position. Puzzle rush
-- specifically involves doing so under time pressure. How does this compare with ratings in games?

-- Bullet games and puzzle rush
SELECT
	ROUND(w_bullet_rating, -2) AS bullet_rating_bin,
    AVG(w_rush_rating) AS average_rush_rating,
    COUNT(*) AS count
FROM chess.chess_games
GROUP BY bullet_rating_bin
ORDER BY bullet_rating_bin ASC;

-- There seems to be a fairly strong correlation there. How about blitz and rapid?

SELECT
	ROUND(w_blitz_rating, -2) AS blitz_rating_bin,
    AVG(w_rush_rating) AS average_rush_rating,
    COUNT(*) AS count
FROM chess.chess_games
GROUP BY blitz_rating_bin
ORDER BY blitz_rating_bin ASC;

SELECT
	ROUND(w_rapid_rating, -2) AS rapid_rating_bin,
    AVG(w_rush_rating) AS average_rush_rating,
    COUNT(*) AS count
FROM chess.chess_games
GROUP BY rapid_rating_bin
ORDER BY rapid_rating_bin ASC;



-- Rapid games with large differentials in rating:
SELECT 
	ROUND(w_rapid_rating, -2) AS rapid_rating_bin, 
    ROUND(100 * SUM(w_result = 'win') / COUNT(w_result)) AS win_percent,
    COUNT(*) as count
FROM chess.chess_games
WHERE (w_rapid_rating - b_rapid_rating >= 100) AND (timeclass = 'rapid')
GROUP BY rapid_rating_bin
ORDER BY rapid_rating_bin ASC;
-- When ratings differ by 100 or more, the scales tip heavily in favor of the higher rated player

-- Accuracy by timeclass
SELECT 
	AVG(w_accuracy) AS avg_w_accuracy, 
    AVG(b_accuracy) AS avg_b_accuracy, 
    timeclass, 
    COUNT(*) as count
FROM chess.chess_games
WHERE (w_accuracy IS NOT NULL)
GROUP BY timeclass;
-- Not much of a difference...
-- Even though there's only 58 blitz games and 218 rapid games, the averages of white and black accuracies
-- are higher in blitz than in rapid, interestingly.

-- Accuracy by tactics rating
SELECT 
	AVG(w_accuracy) AS avg_w_accuracy, 
    ROUND(w_tactics_rating, -3) AS w_tactics_rating_bin, 
    COUNT(*) as count
FROM chess.chess_games
WHERE (w_accuracy IS NOT NULL)
GROUP BY w_tactics_rating_bin
ORDER BY w_tactics_rating_bin ASC;


-- Openings
SELECT opening, COUNT(*) as count
FROM chess.chess_games
GROUP BY opening
ORDER BY COUNT(*) DESC
LIMIT 20;

-- To simplify analysis, variations are removed
SELECT 
	SUBSTRING_INDEX(opening, "-", 2) AS main_opening, 
    COUNT(*) as count,
    ROUND(100 * SUM(w_result = 'win') / COUNT(w_result)) AS w_win_percent,
    ROUND(100 * SUM(b_result = 'win') / COUNT(b_result)) AS b_win_percent
FROM chess.chess_games
GROUP BY main_opening
ORDER BY COUNT(*) DESC
LIMIT 30;

-- Although it's difficult to tell the true winning percentages for openings with relatively few games,
-- there are certain openings, such as the Sicilian Defense, Scandanavian Defense, Philidor Defense,
-- Italian Game, Vienna Game, and Petrovs Defense, which seem to correlate with higher winning
-- probabilities for white or black.
