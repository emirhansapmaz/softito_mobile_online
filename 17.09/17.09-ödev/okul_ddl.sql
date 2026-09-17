-- Öğrenci, Bölüm ve Ders ilişkilerini 3NF (Third Normal Form) kurallarına uygun DDL sorguları

-- 1. Bolum Tablosu
-- Her bölümün benzersiz bir ID'si ve adı vardır.
CREATE TABLE Bolum (
    BolumID INT PRIMARY KEY AUTO_INCREMENT,
    BolumAdi VARCHAR(100) NOT NULL
);

-- 2. Ogrenci Tablosu
-- Öğrenci bilgileri tutulur. Her öğrenci bir bölüme aittir (1 to Many ilişkisi - Foreign Key ile bağlanır).
CREATE TABLE Ogrenci (
    OgrenciID INT PRIMARY KEY AUTO_INCREMENT,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    BolumID INT NOT NULL,
    FOREIGN KEY (BolumID) REFERENCES Bolum(BolumID)
);

-- 3. Ders Tablosu
-- Ders bilgileri tutulur. Derslerin benzersiz ID'si, adı ve kredisi vardır.
CREATE TABLE Ders (
    DersID INT PRIMARY KEY AUTO_INCREMENT,
    DersAdi VARCHAR(100) NOT NULL,
    Kredi INT NOT NULL
);

-- 4. Ogrenci_Ders Tablosu (Many-to-Many Çözümü)
-- Bir öğrenci birden fazla ders alabilir, bir dersi birden fazla öğrenci alabilir.
-- Bu çoktan çoğa (N:M) ilişkiyi 3NF'ye uygun olarak ara tablo (Junction Table) ile çözüyoruz.
CREATE TABLE Ogrenci_Ders (
    OgrenciID INT NOT NULL,
    DersID INT NOT NULL,
    Donem VARCHAR(20) NOT NULL,
    PRIMARY KEY (OgrenciID, DersID),
    FOREIGN KEY (OgrenciID) REFERENCES Ogrenci(OgrenciID),
    FOREIGN KEY (DersID) REFERENCES Ders(DersID)
);
