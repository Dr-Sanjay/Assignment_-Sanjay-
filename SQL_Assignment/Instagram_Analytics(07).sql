-- A) Marketing: The marketing team wants to launch some campaigns, and they need your help with the following

-- Rewarding Most Loyal Users: People who have been using the platform for the longest time.
-- 1) Your Task: Find the 5 oldest users of the Instagram from the database provided

SELECT * FROM ig_clone.users order by created_at limit 5;

-- Remind Inactive Users to Start Posting: By sending them promotional emails to post their 1st photo.
-- 2) Your Task: Find the users who have never posted a single photo on Instagram

SELECT id,username FROM ig_clone.users where id not in (select Distinct user_id from ig_clone.photos);

-- Declaring Contest Winner: The team started a contest and the user who gets the most likes on a single photo will win the contest now they wish to declare the winner.
-- 03) Your Task: Identify the winner of the contest and provide their details to the team.

SELECT 
    users.id AS user_id,
    username AS Winner,
    photos.image_url AS Most_Liked_Photo,
    COUNT(*) AS Total_Likes_Count
FROM
    photos
        JOIN
    likes ON photos.id = likes.photo_id
        JOIN
    users ON users.id = photos.user_id
GROUP BY photos.id
ORDER BY Total_Likes_Count DESC
LIMIT 1;

-- Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.
-- 04) Your Task: Identify and suggest the top 5 most commonly used hashtags on the platform

SELECT 
    id tag_id,tags.tag_name, COUNT(*) AS Used_Number_Of_Times
FROM
    tags
        JOIN
    photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY Used_Number_Of_Times DESC
LIMIT 5;

-- Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs.
-- 05) Your Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign

SELECT DAYNAME(created_at) AS Day_of_Week, COUNT(*) AS Total_Registrations
FROM users
GROUP BY DAYNAME(created_at)
HAVING COUNT(*) = (
    SELECT MAX(reg_count)
    FROM (
        SELECT DAYNAME(created_at) AS Day_of_Week, COUNT(*) AS reg_count
        FROM users
        GROUP BY DAYNAME(created_at)
    ) AS subquery
);

-- B) Investor Metrics: Our investors want to know if Instagram is performing well and is not becoming redundant like Facebook, they want to assess the app on the following grounds

-- User Engagement: Are users still as active and post on Instagram or they are making fewer posts
-- 01) Your Task: Provide how many times does average user posts on Instagram. Also, provide the total number of photos on Instagram/total number of users.

SELECT ROUND(AVG(post_count), 2) AS AVERAGE_POSTS_PER_USER,
       (SELECT COUNT(*) FROM photos) AS TOTAL_PHOTOS,
       (SELECT COUNT(*) FROM Users) AS TOTAL_USERS
FROM (SELECT user_id, COUNT(*) AS post_count
      FROM photos
      GROUP BY user_id) AS user_posts;


-- Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts
-- 02) Your Task: Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).

SELECT id as ID
FROM Users
WHERE id IN (SELECT user_id FROM Likes GROUP BY user_id HAVING COUNT(DISTINCT photo_id) = (SELECT COUNT(*) FROM Photos));
