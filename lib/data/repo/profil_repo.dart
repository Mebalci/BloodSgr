import 'dart:typed_data';

import 'package:blood_sugar/data/entity/profil.dart';
import 'package:blood_sugar/sqlite/veritabani_yardimcisi.dart';
import 'package:sqflite/sqflite.dart';

class ProfilDeposu {
  Future<void> profilEkle(Profil profil) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    await db.insert("Profil", profil.haritayaDonustur());
  }


  Future<Profil?> profilGetir(int kullaniciId) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    var sonuc = await db.query(
      "Profil",
      where: "kullaniciId = ?",
      whereArgs: [kullaniciId],
    );
    return sonuc.isNotEmpty ? Profil.haritadan(sonuc.first) : null;
  }

  Future<void> profilGuncelle(Profil profil) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    // Veritabanında profil var mı kontrol edin
    Profil? mevcutProfil = await profilGetir(profil.kullaniciId);
    if (mevcutProfil != null) {
      await db.rawUpdate(
        'UPDATE Profil SET aclikKanMin = ?, aclikKanMax = ?, toklukKanMax = ?, kullanilanInsulin = ?, cinsiyet = ? WHERE kullaniciId = ?',
        [
          profil.aclikKanMin,
          profil.aclikKanMax,
          profil.toklukKanMax,
          profil.kullanilanInsulin,
          profil.cinsiyet,
          profil.kullaniciId
        ],
      );
    } else {
      await profilEkle(profil);
    }
  }

  Future<List<Profil>> kisileriYukle() async {
    var db = await VeritabaniYardimcisi.veritabaniErisimi();
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM Profil");
    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Profil(id: satir["id"], kullaniciId: satir["kullaniciId"], aclikKanMin: satir["aclikKanMin"],
        aclikKanMax: satir["aclikKanMax"],toklukKanMax: satir["toklukKanMax"],kullanilanInsulin: satir["kullanilanInsulin"],
        cinsiyet: satir["cinsiyet"]);
    });
  }

  Future<void> resimKaydet(int kullaniciId, Uint8List resim) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();

    await db.insert(
      'Resim',
      {
        'kullaniciId': kullaniciId,
        'resim': resim,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Uint8List?> resimGetir(int kullaniciId) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();

    List<Map<String, dynamic>> maps = await db.query(
      'Resim',
      where: 'kullaniciId = ?',
      whereArgs: [kullaniciId],
    );
    if (maps.isNotEmpty) {
      return maps[0]['resim'];
    }
    return null;
  }


  Future<void> printUserInfo() async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    List<Map<String, dynamic>> kullanicilar = await db.query('Profil');
    for (var user in kullanicilar) {
      print('Kullanıcı ID: ${user['id']}');
      print('AÇLIK MİN: ${user['aclikKanMin']}');
      print('cinsiyet: ${user['cinsiyet']}');
      print('kullanici ID: ${user['kullaniciId']}');
      print('---------------------------------');
    }
  }

}