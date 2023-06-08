-- Belirli bir albümdeki tüm şarkıları alfabetik olarak listeleyiniz
SELECT Sarkilar.sarki_adi, Albumler.album_adi
FROM Sarkilar
JOIN Albumler ON Sarkilar.albüm_id = Albumler.album_id
WHERE Albumler.album_adi = 'Belirli Albüm Adı'
ORDER BY Sarkilar.sarki_adi ASC;

-- Belirli bir sanatçının tüm şarkılarını albümlerine göre gruplandırarak listeleyiniz
SELECT Sarkilar.sarki_adi, Albumler.album_adi
FROM Sarkilar
JOIN Albumler ON Sarkilar.albüm_id = Albumler.album_id
JOIN Sanatcilar ON Sarkilar.sanatci_id = Sanatcilar.sanatci_id
WHERE Sanatcilar.sanatci_adi = 'Belirli Sanatçı Adı'
ORDER BY Albumler.album_adi ASC;

-- Kullanıcının yeni çalma listesi oluşturarak çalma listesine şarkı eklemesini sağlayan SQL kodu
INSERT INTO CalmaListeleri (liste_adi, kullanici_id)
VALUES ('Yeni Çalma Listesi', kullanici_id);

-- Verilen kullanıcı koduna göre o kullanıcıya ait çalma listelerini sıralayarak listeleyen SQL kodu
SELECT liste_adi
FROM CalmaListeleri
WHERE kullanici_id = verilen_kullanici_id;

-- En çok beğeni alan sanatçı ve o sanatçının en fazla yorum yapılan şarkısını gösteren SQL kodu
SELECT TOP 1 Sanatcilar.sanatci_adi, Sarkilar.sarki_adi
FROM Sanatcilar
JOIN Sarkilar ON Sanatcilar.sanatci_id = Sarkilar.sanatci_id
ORDER BY Sarkilar.begeni_sayisi DESC, Sarkilar.yorum_sayisi DESC;

-- Beğeni sayısı 10'un üzerinde en az 5 şarkısı olan sanatçıyı popüler sanatçı olarak gösteren SQL kodu
SELECT Sanatcilar.sanatci_adi
FROM Sanatcilar
JOIN Sarkilar ON Sanatcilar.sanatci_id = Sarkilar.sanatci_id
WHERE Sarkilar.begeni_sayisi > 10
GROUP BY Sanatcilar.sanatci_adi
HAVING COUNT(*) >= 5;

-- En çok yorum ve beğenisi olan ilk 5 şarkının bilgilerini ve beğeni ve yorum sayılarını listeleyen SQL kodu
SELECT TOP 5 Sarkilar.sarki_adi, Sarkilar.begeni_sayisi, Sarkilar.yorum_sayisi
FROM Sarkilar
ORDER BY Sarkilar.begeni_sayisi DESC, Sarkilar.yorum_sayisi DESC;

-- En çok paylaşım yapılan çalma listesinde aynı sanatçıya ait şarkıları gruplandırarak listeleyen SQL kodu
SELECT Sarkilar.sarki_adi, Sanatcilar.sanatci_adi, COUNT(*) AS paylasim_sayisi
FROM Sarkilar
JOIN Sanatcilar ON Sarkilar.sanatci_id = Sanatcilar.sanatci_id
JOIN CalmaListeleri_Sarkilar ON Sarkilar.sarki_id = CalmaListeleri_Sarkilar.sarki_id
GROUP BY Sarkilar.sarki_adi, Sanatcilar.sanatci_adi
HAVING COUNT(*) > 1
ORDER BY paylasim_sayisi DESC;

-- Yeni şarkı ekleme işlemini gerçekleştiren bir stored procedure oluşturunuz
CREATE PROCEDURE YeniSarkiEkle
    @sarki_adi VARCHAR(100),
    @sure TIME,
    @yayin_tarihi DATE,
    @albüm_id INT,
    @sanatci_id INT
AS
BEGIN
    INSERT INTO Sarkilar (sarki_adi, sure, yayin_tarihi, albüm_id, sanatci_id)
    VALUES (@sarki_adi, @sure, @yayin_tarihi, @albüm_id, @sanatci_id)
END;

-- Kullanıcının çalma listesine şarkı eklemesini sağlayan bir stored procedure oluşturunuz
CREATE PROCEDURE SarkiEkleCalmaListesi
    @liste_id INT,
    @sarki_id INT,
    @kullanici_id INT
AS
BEGIN
    -- Kullanıcının üyelik bilgilerinin kontrolü yapılabilir
    
    INSERT INTO CalmaListeleri_Sarkilar (liste_id, sarki_id)
    VALUES (@liste_id, @sarki_id)
END;

-- Yeni bir şarkı albümü veya sanatçısı eklenirken, ilgili tablolarda otomatik güncellemeler yapacak bir trigger oluşturunuz
CREATE TRIGGER YeniSarkiAlbümSanatciGuncelleme
ON Sarkilar
AFTER INSERT
AS
BEGIN
    -- Yeni şarkının albüm ve sanatçı bilgileri alınabilir ve ilgili tablolarda güncelleme yapılabilir
END;

-- Bir kullanıcının çalma listesinden şarkı silindiğinde, ilgili tablolarda otomatik güncellemeler yapacak bir trigger oluşturunuz
CREATE TRIGGER SarkiSilCalmaListesiGuncelleme
ON CalmaListeleri_Sarkilar
AFTER DELETE
AS
BEGIN
    -- Şarkı silindiğinde ilgili tablolarda güncelleme yapılabilir
END;

-- Kullanıcıların şarkıları beğenmesini ve favorilere eklemesini sağlayan SQL kodu
UPDATE Sarkilar
SET begeni_sayisi = begeni_sayisi + 1
WHERE sarki_id = verilen_sarki_id;

-- Şarkıları favorilere ekleyen kullanıcılar için SQL kodu
INSERT INTO FavoriSarkilar (kullanici_id, sarki_id)
VALUES (verilen_kullanici_id, verilen_sarki_id);

-- Şarkılara en çok yorum yazan ve beğeni yapan kullanıcıya 1 ay süre ile Premium üyelik hakkı tanımlayan SQL kodu
DECLARE @en_cok_yorum_yapan_kullanici INT;
DECLARE @en_cok_begeni_yapan_kullanici INT;

SELECT TOP 1 @en_cok_yorum_yapan_kullanici = kullanici_id
FROM Kullanicilar
ORDER BY yorum_sayisi DESC;

SELECT TOP 1 @en_cok_begeni_yapan_kullanici = kullanici_id
FROM Kullanicilar
ORDER BY begeni_sayisi DESC;

UPDATE Kullanicilar
SET premium_uyelik_bitis_tarihi = DATEADD(month, 1, GETDATE())
WHERE kullanici_id IN (@en_cok_yorum_yapan_kullanici, @en_cok_begeni_yapan_kullanici);

-- Kullanıcı bilgilerinin silinmesi işlemi denendiğinde bu işlemin ne zaman denendiğini gösteren trigger kodunu yazınız
CREATE TRIGGER KullaniciSilmeLog
ON Kullanicilar
INSTEAD OF DELETE
AS
BEGIN
    -- Silme işlemi denendiğinde log kaydı tutulabilir
END;
