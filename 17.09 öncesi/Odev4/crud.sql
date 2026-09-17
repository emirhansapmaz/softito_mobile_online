-- ==========================================================
-- 1. SQL CRUD İŞLEMLERİ (Ödev)
-- Tablo: users (id, fullname, email)
-- ==========================================================

-- Varsa eski tabloyu temizle
DROP TABLE IF EXISTS users;

-- 1. Tablo Oluşturma (CREATE TABLE)
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 2. 3 Adet Kullanıcı Ekleme (CREATE / INSERT)
INSERT INTO users (fullname, email) VALUES 
('Ahmet Yılmaz', 'ahmet.yilmaz@example.com'),
('Ayşe Kaya', 'ayse.kaya@example.com'),
('Mehmet Demir', 'mehmet.demir@example.com');

-- 3. Kullanıcıları Listeleme (READ / SELECT)
SELECT * FROM users;

-- 4. Kullanıcılardan Birinin Email Adresini Güncelleme (UPDATE)
-- (id = 2 olan kullanıcının email adresini güncelliyoruz)
UPDATE users 
SET email = 'ayse.yeni@example.com' 
WHERE id = 2;

-- Güncelleme Sonrası Kontrol (SELECT)
SELECT * FROM users;

-- 5. Kullanıcılardan Birini Silme (DELETE)
-- (id = 3 olan kullanıcıyı siliyoruz)
DELETE FROM users 
WHERE id = 3;

-- Silme Sonrası Son Durum (SELECT)
SELECT * FROM users;
