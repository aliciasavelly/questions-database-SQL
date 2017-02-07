CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL,
  lname VARCHAR(100) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Alicia', 'Savelly'),
  ('Akashpreet', 'Singh');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('How to make a table', 'Making tables is fun', (SELECT id FROM users WHERE fname = 'Akashpreet')),
  ('Making tables is cool', 'Being cool is great', (SELECT id FROM users WHERE fname = 'Alicia'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Alicia'), (SELECT id FROM questions WHERE title = 'How to make a table')),
  ((SELECT id FROM users WHERE fname = 'Akashpreet'), (SELECT id FROM questions WHERE title = 'Making tables is cool'));

INSERT INTO
  replies (question_id, user_id, reply_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'How to make a table'), (SELECT id FROM users WHERE fname = 'Alicia'), NULL, 'Can you explain better?'),
  ((SELECT id FROM questions WHERE title = 'How to make a table'), (SELECT id FROM users WHERE fname = 'Akashpreet'), 1, 'Yeah! I''ll send you a message on slack.');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Alicia'), (SELECT id FROM questions WHERE title = 'How to make a table')),
  ((SELECT id FROM users WHERE fname = 'Akashpreet'), (SELECT id FROM questions WHERE title = 'How to make a table'));
