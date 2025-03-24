
-- Veri tabanı oluşturma 
CREATE DATABASE SirketDB;

GO

USE SirketDB;
GO

-- birimler tablosu
CREATE TABLE birimler (
    birim_id INT PRIMARY KEY,
    birim_adi CHAR(25) NOT NULL
);
 
 -- çalışanlar tablosu
CREATE TABLE calisanlar (
    calisan_id INT PRIMARY KEY,
    ad CHAR(25) NOT NULL,
    soyad CHAR(25) NOT NULL,
    maas INT,
    katilma_tarihi DATETIME,
    calisan_birim_id INT,
    FOREIGN KEY (calisan_birim_id) REFERENCES birimler(birim_id)
);

-- ikramiye tablosu
CREATE TABLE ikramiye (
    ikramiye_calisan_id INT,
    ikramiye_ucret INT,
    ikramiye_tarihi DATETIME,
    FOREIGN KEY (ikramiye_calisan_id) REFERENCES calisanlar(calisan_id)
);

-- unvan tablosu 
CREATE TABLE unvan (
    unvan_calisan_id INT,
    unvan_calisan CHAR(25),
    unvan_tarihi DATETIME,
    FOREIGN KEY (unvan_calisan_id) REFERENCES calisanlar(calisan_id)
);


--birimler tablosuna veri ekleme 
INSERT INTO birimler (birim_id, birim_adi) 
VALUES 
(1, 'Yazılım'),
(2, 'Donanım'),
(3, 'Güvenlik');

SELECT*FROM birimler

-- çalışanlar tablosuna veriler ekleme

 INSERT INTO calisanlar (calisan_id, ad, soyad, maas, katilma_tarihi, calisan_birim_id) VALUES
(1, 'İsmail', 'İşeri', 100000, '2014-02-20 00:00:00.000', 1),
(2, 'Hami', 'Satılmış', 80000, '2014-06-11 00:00:00.000', 1),
(3, 'Durmuş', 'Şahin', 300000, '2014-02-20 00:00:00.000', 2),
(4, 'Kağan', 'Yazar', 500000, '2014-02-20 00:00:00.000', 3),
(5, 'Meryem', 'Soysaldı', 500000, '2014-06-11 00:00:00.000', 3),
(6, 'Duygu', 'Akşehir', 200000, '2014-06-11 00:00:00.000', 2),
(7, 'Kübra', 'Seyhan', 75000, '2014-01-20 00:00:00.000', 1),
(8, 'Gülcan', 'Yıldız', 90000, '2014-04-11 00:00:00.000', 3);

SELECT*FROM calisanlar


-- İkramiye ablosuna kayıtları ekleme 
INSERT INTO ikramiye (ikramiye_calisan_id, ikramiye_ucret, ikramiye_tarihi)
VALUES
(1, 5000, '2016-02-20 00:00:00.000'),
(2, 3000, '2016-06-11 00:00:00.000'),
(3, 4000, '2016-02-20 00:00:00.000'),
(1, 4500, '2016-02-20 00:00:00.000'),
(2, 3500, '2016-06-11 00:00:00.000');

SELECT* FROM ikramiye


 -- Unvan tablosunna veri girişi yapma 
INSERT INTO unvan (unvan_calisan_id, unvan_calisan, unvan_tarihi)
VALUES
(1, 'Yönetici', '2016-02-20 00:00:00.000'),
(2, 'Personel', '2016-06-11 00:00:00.000'),
(8, 'Personel', '2016-06-11 00:00:00.000'),
(5, 'Müdür', '2016-06-11 00:00:00.000'),
(4, 'Yönetici Yardımcısı', '2016-06-11 00:00:00.000'),
(7, 'Personel', '2016-06-11 00:00:00.000'),
(6, 'Takım Lideri', '2016-06-11 00:00:00.000'),
(3, 'Takım Lideri', '2016-06-11 00:00:00.000');

SELECT* FROM unvan




-- Yazılım veya Donanım birimlerinde çalışanlaın ad,soyad ve maaş bilgilerini listeleyen sorgu
SELECT calisanlar.ad, calisanlar.soyad, calisanlar.maas
FROM calisanlar
JOIN birimler ON calisanlar.calisan_birim_id = birimler.birim_id
WHERE birimler.birim_adi IN ('Yazilim', 'Donanim');




-- Maaşı en yüksek olan çalışanların ad, soyad ve maaş bilgilerini listeleyen sorgu
SELECT ad, soyad, maas
FROM calisanlar
WHERE maas = (SELECT MAX(maas) FROM calisanlar);



-- )  Birimlerin her birinde kaç adet çalışan olduğunu ve birimlerin isimlerini listeleyen sorgu
SELECT birimler.birim_adi, COUNT(calisanlar.calisan_id) AS calisan_sayisi
FROM birimler
LEFT JOIN calisanlar ON birimler.birim_id = calisanlar.calisan_birim_id
GROUP BY birimler.birim_adi;



-- Birden fazla çalışana ait olan unvanların isimlerini ve o unvan altında çalışanların sayısını listeleyen sorgu
SELECT unvan_calisan, COUNT(unvan_calisan_id) AS calisan_sayisi
FROM unvan
GROUP BY unvan_calisan
HAVING COUNT(unvan_calisan_id) > 1;


--Maaşları “50000” ve “100000” arasında değişen çalışanların ad, soyad ve maaş bilgilerini listeleyen sorgu
SELECT ad, soyad, maas
FROM calisanlar
WHERE maas BETWEEN 50000 AND 100000;





--İkramiye hakkına sahip çalışanlara ait ad, soyad, birim, unvan ve ikramiye ücreti bilgilerini listeleyen sorgu
SELECT calisanlar.ad, calisanlar.soyad, birimler.birim_adi, unvan.unvan_calisan, ikramiye.ikramiye_ucret
FROM calisanlar
JOIN birimler ON calisanlar.calisan_birim_id = birimler.birim_id
JOIN unvan ON calisanlar.calisan_id = unvan.unvan_calisan_id
JOIN ikramiye ON calisanlar.calisan_id = ikramiye.ikramiye_calisan_id;





--) Ünvanı “Yönetici” ve “Müdür” olan çalışanların ad, soyad ve ünvanlarını listeleyen sorgu


SELECT calisanlar.ad, calisanlar.soyad, unvan.unvan_calisan
FROM calisanlar
JOIN unvan ON calisanlar.calisan_id = unvan.unvan_calisan_id
WHERE unvan.unvan_calisan IN ('Yönetici', 'Müdür');


-- Her bir birimde en yüksek maaş alan çalışanların ad, soyad ve maaş bilgilerini listeleyen sorgu
SELECT calisanlar.ad, calisanlar.soyad, calisanlar.maas
FROM calisanlar
WHERE calisanlar.maas = (
    SELECT MAX(c2.maas)
    FROM calisanlar AS c2
    WHERE c2.calisan_birim_id = calisanlar.calisan_birim_id
);
