-- Reward Long-Time Users
-- Find the top 5 users who have been with us the longest
SELECT * 
FROM users
ORDER BY created_at
LIMIT 5;

-- Day of the Week with Most Registrations
-- Identify the day with the highest number of user registrations
SELECT date_format(created_at, '%W') AS 'day of the week', COUNT(*) AS 'total registration'
FROM users
GROUP BY 1
ORDER BY 2 DESC;

-- Version 2: Alternative query for most registration day
SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;

-- Target Inactive Users
-- Find users who have never posted a photo
SELECT username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

-- Contest: Most Likes on a Single Photo
-- Find the photo with the highest number of likes
SELECT users.username, photos.id, photos.image_url, COUNT(*) AS Total_Likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC
LIMIT 1;

-- Version 2: Alternative query for most liked photo
SELECT 
    username,
    photos.id,
    photos.image_url, 
    COUNT(*) AS total
FROM photos
INNER JOIN likes ON likes.photo_id = photos.id
INNER JOIN users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

-- Average Posts Per User
-- Calculate the average number of posts per user
SELECT ROUND((SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users), 2) AS average_posts;

-- User Ranking by Posts
-- Rank users based on the number of posts in descending order
SELECT users.username, COUNT(photos.image_url) AS post_count
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY post_count DESC;

-- Total Posts by All Users
-- Calculate the total number of posts by all users
SELECT SUM(user_posts.total_posts_per_user)
FROM (
    SELECT COUNT(photos.image_url) AS total_posts_per_user
    FROM users
    JOIN photos ON users.id = photos.user_id
    GROUP BY users.id
) AS user_posts;

-- Active Users
-- Find the total number of users who have posted at least once
SELECT COUNT(DISTINCT users.id) AS total_active_users
FROM users
JOIN photos ON users.id = photos.user_id;

-- Top 5 Most Common Hashtags
-- Find the most commonly used hashtags in posts
SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;

-- Identify Bots: Users Who Liked Every Photo
-- Find users who have liked every single photo on the platform
SELECT users.id, username, COUNT(users.id) AS total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);

-- Identify Celebrities: Users Who Have Never Commented
-- Find users who have never commented on a photo
SELECT username, comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL;

-- Count of Users Who Have Never Commented
SELECT COUNT(*) 
FROM (
    SELECT username, comment_text
    FROM users
    LEFT JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING comment_text IS NULL
) AS total_number_of_users_without_comments;

-- Identify Users Who Have Commented
-- Find users who have ever commented on a photo
SELECT username, comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NOT NULL;

-- Count of Users Who Have Commented
SELECT COUNT(*) 
FROM (
    SELECT username, comment_text
    FROM users
    LEFT JOIN comments ON users.id = comments.user_id
    GROUP BY users.id
    HAVING comment_text IS NOT NULL
) AS total_number_of_users_with_comments;

-- Bots and Celebrities Percentage
-- Find the percentage of users who have never commented or have commented
SELECT tableA.total_A AS 'Number Of Users who never commented',
       (tableA.total_A / (SELECT COUNT(*) FROM users)) * 100 AS 'Percentage Never Commented',
       tableB.total_B AS 'Number of Users who commented',
       (tableB.total_B / (SELECT COUNT(*) FROM users)) * 100 AS 'Percentage Commented'
FROM (
    SELECT COUNT(*) AS total_A 
    FROM (
        SELECT username, comment_text
        FROM users
        LEFT JOIN comments ON users.id = comments.user_id
        GROUP BY users.id
        HAVING comment_text IS NULL
    ) AS total_number_of_users_without_comments
) AS tableA
JOIN (
    SELECT COUNT(*) AS total_B 
    FROM (
        SELECT username, comment_text
        FROM users
        LEFT JOIN comments ON users.id = comments.user_id
        GROUP BY users.id
        HAVING comment_text IS NOT NULL
    ) AS total_number_of_users_with_comments
) AS tableB;
