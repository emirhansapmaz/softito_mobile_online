
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO users (fullname, email) VALUES 
('Ahmet Yılmaz', 'ahmet.yilmaz@example.com'),
('Ayşe Kaya', 'ayse.kaya@example.com'),
('Mehmet Demir', 'mehmet.demir@example.com');

SELECT * FROM users;


UPDATE users 
SET email = 'ayse.yeni@example.com' 
WHERE id = 2;

SELECT * FROM users;

DELETE FROM users 
WHERE id = 3;

SELECT * FROM users;
