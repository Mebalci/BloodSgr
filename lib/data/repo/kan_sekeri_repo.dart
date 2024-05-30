import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:blood_sugar/sqlite/veritabani_yardimcisi.dart';
import 'package:sqflite/sqflite.dart';

class KanSekeriRepository {

  Future<void> olcumEkle(KanSekeriOlcumu olcum) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    await db.insert('KanSekeriOlcumu', olcum.toMap());
  }

  Future<List<KanSekeriOlcumu>> tumOlcumleriGetir(int kullaniciId) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    final List<Map<String, dynamic>> maps = await db.query(
      'KanSekeriOlcumu',
      where: 'kullaniciId = ?',
      whereArgs: [kullaniciId],
    );
    return List.generate(maps.length, (i) {
      return KanSekeriOlcumu.fromMap(maps[i]);
    });
  }


  Future<void> olcumGuncelle(KanSekeriOlcumu profil) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
      await db.rawUpdate(
        'UPDATE KanSekeriOlcumu SET kanSekeri = ?, olcumSaati = ?, '
            'insulinDozu = ?, yemekBilgisi = ?, acTokDurumu = ? WHERE id = ?',
        [
          profil.kanSekeri,
          profil.olcumSaati,
          profil.insulinDozu,
          profil.yemekBilgisi,
          profil.acTokDurumu,
          profil.id,
        ],
      );
  }

  Future<void> olcumSil(int id) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    await db.delete("KanSekeriOlcumu",where: "id = ?",whereArgs: [id]);
  }

  Future<List<KanSekeriOlcumu>> sonBesGunAcOlcumleriGetir(int kullaniciId) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM KanSekeriOlcumu WHERE acTokDurumu = 0 AND kullaniciId = ? ORDER BY id DESC LIMIT 5',
    [kullaniciId],
    );

    return List.generate(maps.length, (i) {
      return KanSekeriOlcumu.fromMap(maps[i]);
    });
  }

  Future<List<KanSekeriOlcumu>> sonBesGunTokOlcumleriGetir(int kullaniciId) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM KanSekeriOlcumu WHERE acTokDurumu = 1 AND kullaniciId = ? ORDER BY olcumSaati DESC LIMIT 5',
        [kullaniciId],
    );

    return List.generate(maps.length, (i) {
      return KanSekeriOlcumu.fromMap(maps[i]);
    });
  }

}
