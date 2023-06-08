-- Veri tabanı oluşturma
CREATE DATABASE MuzikKutuphanesi;

-- Veri tabanı seçimi
USE MuzikKutuphanesi;

-- Şarkılar tablosu
CREATE TABLE Sarkilar (
    sarki_id INT PRIMARY KEY,
    sarki_adi VARCHAR(100),
    sure TIME,
    yayin_tarihi DATE,
    albüm_id INT,
    sanatci_id INT,
    FOREIGN KEY (albüm_id) REFERENCES Albumler(album_id),
    FOREIGN KEY (sanatci_id) REFERENCES Sanatcilar(sanatci_id)
);

-- Albümler tablosu
CREATE TABLE Albumler (
    album_id INT PRIMARY KEY,
    album_adi VARCHAR(100),
    yayin_tarihi DATE,
    kapak_resmi VARCHAR(100)
);

-- Sanatçılar tablosu
CREATE TABLE Sanatcilar (
    sanatci_id INT PRIMARY KEY,
    sanatci_adi VARCHAR(100),
    dogum_tarihi DATE,
    ulke VARCHAR(50)
);

-- Türler tablosu
CREATE TABLE Turler (
    tur_id INT PRIMARY KEY,
    tur_adi VARCHAR(50)
);

-- Çalma Listeleri tablosu
CREATE TABLE CalmaListeleri (
    liste_id INT PRIMARY KEY,
    liste_adi VARCHAR(100),
    kullanici_id INT,
    FOREIGN KEY (kullanici_id) REFERENCES Kullanicilar(kullanici_id)
);

-- Kullanıcılar tablosu
CREATE TABLE Kullanicilar (
    kullanici_id INT PRIMARY KEY,
    kullanici_adi VARCHAR(50),
    sifre VARCHAR(50),
    eposta VARCHAR(100)
);

-- Üyelik tablosu
CREATE TABLE Uyelik (
    uyelik_id INT PRIMARY KEY,
    uyelik_adi VARCHAR(50),
    sinirsiz_sarki BIT,
    sinirsiz_calma_listesi BIT
);
