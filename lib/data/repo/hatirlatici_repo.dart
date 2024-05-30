import 'package:sqflite/sqflite.dart';
import 'package:blood_sugar/data/entity/hatirlatici.dart';
import 'package:blood_sugar/sqlite/veritabani_yardimcisi.dart';

class HatirlaticiDeposu {
  Future<void> hatirlaticiEkle(Hatirlatici hatirlatici) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    await db.insert("Hatirlatici", hatirlatici.haritayaDonustur());
  }


  Future<Hatirlatici?> hatirlaticiGetir(int kullaniciId) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    var sonuc = await db.query(
      "Hatirlatici",
      where: "kullaniciId = ?",
      whereArgs: [kullaniciId],
    );
    return sonuc.isNotEmpty ? Hatirlatici.haritadan(sonuc.first) : null;
  }

  Future<void> hatirlaticiGuncelle(Hatirlatici hatirlatici) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();

    // Veritabanında kullanıcı var mı kontrol edin
    Hatirlatici? mevcutHatirlatici = await hatirlaticiGetir(hatirlatici.kullaniciId);

    if (mevcutHatirlatici != null) {
      // Eğer kullanıcı varsa, güncelleme işlemini gerçekleştirin
      await db.update(
        'Hatirlatici',
        {
          'kullaniciId': hatirlatici.kullaniciId,
          'sabahSaati': hatirlatici.sabahSaati,
          'ogleSaati': hatirlatici.ogleSaati,
          'aksamSaati': hatirlatici.aksamSaati,
        },
        where: 'kullaniciId = ?',
        whereArgs: [hatirlatici.kullaniciId],
      );
    } else {
      // Eğer kullanıcı yoksa, yeni bir kullanıcı ekleyin
      await hatirlaticiEkle(hatirlatici);
    }
  }

}
