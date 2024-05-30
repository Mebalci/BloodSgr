import 'dart:io';

import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeritabaniYardimcisi {
  static final String veritabaniAdi = "blood.sqlite";

  static Future<Database> veritabaniErisimi() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);

    if (await databaseExists(veritabaniYolu)) {
      print("Veritabanı zaten var. Kopyalamaya gerek yok");
    } else {
      ByteData data = await rootBundle.load("C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/veritabani/blood.sqlite");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
      print("Veri Tabanı Kopyalandı.");
    }

    var db = await openDatabase(veritabaniYolu);
    await _tablolariOlustur(db); // Tabloları oluştur
    return db;
  }

  static Future<void> _tablolariOlustur(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Kullanici (
        kullaniciId INTEGER PRIMARY KEY AUTOINCREMENT,
        adSoyad TEXT,
        eposta TEXT,
        kullaniciAdi TEXT NOT NULL,
        kullaniciSifre TEXT NOT NULL,
        yas INTEGER,
        boy INTEGER,
        kilo INTEGER
      );
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Hatirlatici (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      kullaniciId INTEGER,
      sabahSaati TEXT,
      ogleSaati TEXT,
      aksamSaati TEXT,
      FOREIGN KEY (kullaniciId) REFERENCES Kullanici (kullaniciId)
    );
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Profil (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      kullaniciId INTEGER,
      aclikKanMin INTEGER,
      aclikKanMax INTEGER,
      toklukKanMax INTEGER,
      kullanilanInsulin TEXT,
      cinsiyet TEXT,
      FOREIGN KEY (kullaniciId) REFERENCES Kullanici (kullaniciId)
    );
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS KanSekeriOlcumu (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      kullaniciId INTEGER,
      kanSekeri REAL,
      olcumSaati TEXT,
      insulinDozu REAL,
      yemekBilgisi TEXT,
      acTokDurumu INTEGER,
      FOREIGN KEY (kullaniciId) REFERENCES Kullanici (kullaniciId)
    );
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Resim (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      kullaniciId INTEGER,
      resim BLOB,      
      FOREIGN KEY (kullaniciId) REFERENCES Resim (kullaniciId)
    );
  ''');
  }

  Future<List<Kullanici>> tumKullanicilariGetir() async {
    final Database db = await veritabaniErisimi();

    final List<Map<String, dynamic>> haritalar = await db.query('Kullanici');

    return List.generate(haritalar.length, (i) {
      return Kullanici(
        kullaniciId: haritalar[i]['kullaniciId'],
        adSoyad: haritalar[i]['adSoyad'],
        eposta: haritalar[i]['eposta'],
        kullaniciAdi: haritalar[i]['kullaniciAdi'],
        kullaniciSifre: haritalar[i]['kullaniciSifre'],
        yas: haritalar[i]['yas'],
        boy: haritalar[i]['boy'],
        kilo: haritalar[i]['kilo'],
      );
    });
  }
}
