CREATE DATABASE PMTP;
GO

USE PMTP;
GO
CREATE TABLE tbl_Bolumler (
    Bolum_ID INT PRIMARY KEY IDENTITY(1,1),
    Bolum_Adi NVARCHAR(50),
    Bolum_Tel NVARCHAR(20)
);
GO
CREATE TABLE tbl_Unvanlar (
    Unvan_ID INT PRIMARY KEY IDENTITY(1,1),
    Unvan_Adi NVARCHAR(50)
);
GO
CREATE TABLE tbl_Cinsiyet (
    Cinsiyet_ID INT PRIMARY KEY IDENTITY(1,1),
    Cinsiyet_Adi NVARCHAR(10)
);
GO
CREATE TABLE tbl_Kategoriler (
    K_ID INT PRIMARY KEY IDENTITY(1,1),
    Yetki_Turu NVARCHAR(50)
);
GO
CREATE TABLE tbl_Kullanicilar (
    Kullanici_ID INT PRIMARY KEY IDENTITY(1,1),
    Kullanici_Adi NVARCHAR(50),
    Kullanici_Sifre NVARCHAR(50),
    Yetki_ID INT FOREIGN KEY REFERENCES tbl_Kategoriler(K_ID)
);
GO
CREATE TABLE tbl_Personeller (
    Pers_ID INT PRIMARY KEY IDENTITY(1,1),
    Pers_Adi NVARCHAR(50),
    Pers_Soyadi NVARCHAR(50),
    Pers_DTarihi DATE,
    Pers_Giris_Tarihi DATE,
    Pers_Cikis_Tarihi DATE,
    Pers_Adresi NVARCHAR(200),
    Pers_Ilcesi NVARCHAR(50),
    Pers_Ili NVARCHAR(50),
    Pers_Il_Kodu NVARCHAR(10),
    Pers_Tel NVARCHAR(20),
    Pers_Cep NVARCHAR(20),
    Pers_Email NVARCHAR(100),
    Cinsiyet_ID INT FOREIGN KEY REFERENCES tbl_Cinsiyet(Cinsiyet_ID),
    Unvan_ID INT FOREIGN KEY REFERENCES tbl_Unvanlar(Unvan_ID),
    Bolum_ID INT FOREIGN KEY REFERENCES tbl_Bolumler(Bolum_ID),
    Pers_Maas DECIMAL(10,2),
    Pers_Komisyon_Yuzdesi DECIMAL(5,2),
    Pers_Foto NVARCHAR(100),
    Pers_CV NVARCHAR(100),
    Pers_CV_File VARBINARY(MAX),
    Pers_CV_Web NVARCHAR(200),
    Pers_Aktif_Mi BIT,
    Kaydeden_ID INT FOREIGN KEY REFERENCES tbl_Kullanicilar(Kullanici_ID),
    Kayit_Tarihi DATETIME DEFAULT GETDATE()
);
GO
CREATE TABLE tbl_Maaslar (
    Maas_ID INT PRIMARY KEY IDENTITY(1,1),
    Pers_ID INT FOREIGN KEY REFERENCES tbl_Personeller(Pers_ID),
    Maas_Tarihi DATE,
    Maas_Tutari DECIMAL(10,2),
    Maas_Komisyonu DECIMAL(10,2),
    Ay_ID INT,
    Maas_Yili AS YEAR(Maas_Tarihi) PERSISTED,
    Maas_Toplam AS (Maas_Tutari + Maas_Komisyonu) PERSISTED
);
GO
CREATE TRIGGER trg_PersonelEklendigindeMaasEkle
ON tbl_Personeller
AFTER INSERT
AS
BEGIN
    INSERT INTO tbl_Maaslar (Pers_ID, Maas_Tarihi, Maas_Tutari, Maas_Komisyonu, Ay_ID)
    SELECT 
        i.Pers_ID,
        GETDATE(),
        i.Pers_Maas,
        (i.Pers_Maas * i.Pers_Komisyon_Yuzdesi / 100.0),
        MONTH(GETDATE())
    FROM inserted i;
END;
GO
INSERT INTO tbl_Bolumler (Bolum_Adi, Bolum_Tel) VALUES
('Muhasebe', '0312 123 45 67'),
('Pazarlama', '0312 234 56 78'),
('İnsan Kaynakları', '0312 345 67 89');
INSERT INTO tbl_Kategoriler (Yetki_Turu) VALUES
('Yönetici'),
('Kullanıcı');


INSERT INTO tbl_Kullanicilar (Kullanici_Adi, Kullanici_Sifre, Yetki_ID) VALUES
('admin', 'admin123', 1),
('kullanici1', 'pass123', 2);

INSERT INTO tbl_Unvanlar (Unvan_Adi)
VALUES 
('Pazarlamacı'),
('Yazılım Uzmanı'),
('Sekreter');
INSERT INTO tbl_Cinsiyet (Cinsiyet_Adi) VALUES
('Erkek'),
('Kadın');
INSERT INTO tbl_Personeller (
    Pers_Adi, Pers_Soyadi, Pers_DTarihi, Pers_Giris_Tarihi, Pers_Cikis_Tarihi,
    Pers_Adresi, Pers_Ilcesi, Pers_Ili, Pers_Il_Kodu, Pers_Tel, Pers_Cep, Pers_Email,
    Bolum_ID, Cinsiyet_ID, Unvan_ID, Pers_Maas, Pers_Komisyon_Yuzdesi,
    Pers_Foto, Pers_CV, Pers_CV_File, Pers_CV_Web, Pers_Aktif_Mi, Kaydeden_ID, Kayit_Tarihi
) VALUES
('Mehmet', 'Çoruh', '1990-05-10', '2022-01-10', NULL, 'Adres 1', 'Çankaya', 'Ankara', 6, '0312 111 22 33', '0555 111 22 33', 'mehmet@ornek.com', 1, 1, 1, 15000, 0.05, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Ayşe', 'Yıldız', '1992-07-15', '2023-03-12', NULL, 'Adres 2', 'Keçiören', 'Ankara', 6, '0312 222 33 44', '0555 222 33 44', 'ayse@ornek.com', 2, 2, 2, 13000, 0.04, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Ali', 'Kaya', '1985-09-20', '2021-06-01', NULL, 'Adres 3', 'Osmangazi', 'Bursa', 16, '0224 111 22 33', '0555 333 44 55', 'ali@ornek.com', 3, 1, 3, 14000, 0.06, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Zeynep', 'Demir', '1991-02-18', '2020-11-01', NULL, 'Adres 4', 'Selçuklu', 'Konya', 42, '0332 444 55 66', '0555 444 55 66', 'zeynep@ornek.com', 2, 2, 2, 12500, 0.03, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Mustafa', 'Öztürk', '1988-12-05', '2024-01-05', NULL, 'Adres 5', 'Çankaya', 'Ankara', 6, '0312 555 66 77', '0555 555 66 77', 'mustafa@ornek.com', 1, 1, 1, 15500, 0.05, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Emine', 'Arslan', '1993-03-30', '2023-07-01', NULL, 'Adres 6', 'Osmangazi', 'Bursa', 16, '0224 222 33 44', '0555 666 77 88', 'emine@ornek.com', 3, 2, 3, 13500, 0.04, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Burak', 'Yılmaz', '1995-08-20', '2022-04-15', NULL, 'Adres 7', 'Keçiören', 'Ankara', 6, '0312 666 77 88', '0555 777 88 99', 'burak@ornek.com', 2, 1, 2, 14500, 0.06, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Elif', 'Çelik', '1990-11-11', '2021-08-20', NULL, 'Adres 8', 'Selçuklu', 'Konya', 42, '0332 777 88 99', '0555 888 99 00', 'elif@ornek.com', 1, 2, 1, 12000, 0.03, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Ahmet', 'Koç', '1987-04-25', '2020-09-10', NULL, 'Adres 9', 'Osmangazi', 'Bursa', 16, '0224 333 44 55', '0555 999 00 11', 'ahmet@ornek.com', 3, 1, 3, 16000, 0.05, NULL, NULL, NULL, NULL, 1, 1, GETDATE()),
('Fatma', 'Kurt', '1994-06-14', '2022-12-01', NULL, 'Adres 10', 'Keçiören', 'Ankara', 6, '0312 888 99 00', '0555 000 11 22', 'fatma@ornek.com', 2, 2, 2, 11000, 0.02, NULL, NULL, NULL, NULL, 1, 1, GETDATE());

SELECT * FROM tbl_Personeller
WHERE Pers_Ili = 'Ankara';

SELECT Pers_Ili, COUNT(*) AS Personel_Sayisi
FROM tbl_Personeller
GROUP BY Pers_Ili
HAVING COUNT(*) > 2;

SELECT b.Bolum_Adi, AVG(p.Pers_Maas) AS Ortalama_Maas
FROM tbl_Personeller p
JOIN tbl_Bolumler b ON p.Bolum_ID = b.Bolum_ID
GROUP BY b.Bolum_Adi;

SELECT * FROM tbl_Personeller
WHERE Pers_Adi LIKE '%M%';

SELECT p.Pers_Adi, p.Pers_Soyadi, b.Bolum_Adi, b.Bolum_Tel
FROM tbl_Personeller p
JOIN tbl_Bolumler b ON p.Bolum_ID = b.Bolum_ID;

SELECT p.Pers_Adi, p.Pers_Soyadi, YEAR(m.Maas_Tarihi) AS Yil, SUM(m.Maas_Toplam) AS Toplam_Yillik_Maas
FROM tbl_Maaslar m
JOIN tbl_Personeller p ON m.Pers_ID = p.Pers_ID
GROUP BY p.Pers_Adi, p.Pers_Soyadi, YEAR(m.Maas_Tarihi);

SELECT LOWER(LEFT(Pers_Adi,1) + Pers_Soyadi) AS KullaniciKodu
FROM tbl_Personeller;

SELECT Pers_Adi, Pers_Soyadi, 
       DATEDIFF(YEAR, Pers_DTarihi, GETDATE()) AS Yas
FROM tbl_Personeller;

UPDATE tbl_Kullanicilar
SET Kullanici_Sifre = 'yeniSifre123'
WHERE Kullanici_ID = 2;
DELETE FROM tbl_Personeller

WHERE Unvan_ID = (
    SELECT Unvan_ID FROM tbl_Unvanlar WHERE Unvan = 'Pazarlamacı'
);