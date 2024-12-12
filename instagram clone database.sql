CREATE DATABASE ig_clone;

USE ig_clone;

/*Users*/
CREATE TABLE users(
	id INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

/*Photos*/
CREATE TABLE photos(
	id INT AUTO_INCREMENT PRIMARY KEY,
	image_url VARCHAR(355) NOT NULL,
	user_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id)
);

/*Comments*/
CREATE TABLE comments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	comment_text VARCHAR(255) NOT NULL,
	user_id INT NOT NULL,
	photo_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id),
	FOREIGN KEY(photo_id) REFERENCES photos(id)
);

/*Likes*/
CREATE TABLE likes(
	user_id INT NOT NULL,
	photo_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id),
	FOREIGN KEY(photo_id) REFERENCES photos(id),
	PRIMARY KEY(user_id, photo_id)
);

/*follows*/
CREATE TABLE follows(
	follower_id INT NOT NULL,
	followee_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY (follower_id) REFERENCES users(id),
	FOREIGN KEY (followee_id) REFERENCES users(id),
	PRIMARY KEY(follower_id, followee_id)
);

/*Tags*/
CREATE TABLE tags(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	tag_name VARCHAR(255) UNIQUE NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

/*junction table: Photos - Tags*/
CREATE TABLE photo_tags(
	photo_id INT NOT NULL,
	tag_id INT NOT NULL,
	FOREIGN KEY(photo_id) REFERENCES photos(id),
	FOREIGN KEY(tag_id) REFERENCES tags(id),
	PRIMARY KEY(photo_id, tag_id)
);

/*Insert Sample Data*/
INSERT INTO users (username, created_at)
VALUES ('Kenton_Kirlin', '2017-02-16 18:22:10.846'), 
       ('Andre_Purdy85', '2017-04-02 17:11:21.417'), 
       ('Harley_Lind18', '2017-02-21 11:12:32.574');
       
INSERT INTO photos(image_url, user_id) 
VALUES ('http://elijah.biz', 1), 
       ('https://shanon.org', 1), 
       ('http://vicky.biz', 1);
       
INSERT INTO follows(follower_id, followee_id) 
VALUES (2, 1), 
       (2, 3), 
       (2, 4);     
       
INSERT INTO comments(comment_text, user_id, photo_id)
 VALUES ('unde at dolorem', 2, 1), 
 ('quae ea ducimus', 3, 1), 
 ('alias a voluptatum', 5, 1);

INSERT INTO likes(user_id,photo_id) 
VALUES (2, 1), 
(5, 1), 
(9, 1);


INSERT INTO tags(tag_name) 
VALUES ('sunset'), 
('photography'), 
('sunrise');

INSERT INTO photo_tags(photo_id, tag_id) 
VALUES (1, 18), 
(1, 17), 
(1, 21);
