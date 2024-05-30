import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/sqlite/veritabani_yardimcisi.dart';
import 'package:sqflite/sqflite.dart';

class KullaniciDeposu {
  Future<bool> kimlikDogrulama(Kullanici kullanici) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    var sonuc = await db.rawQuery("SELECT * FROM Kullanici WHERE kullaniciAdi = '${kullanici.kullaniciAdi}' AND kullaniciSifre = '${kullanici.kullaniciSifre}'");
    return sonuc.isNotEmpty;
  }

  Future<List<Kullanici>> kullanicilariYukle() async {
    var db = await VeritabaniYardimcisi.veritabaniErisimi();
    List<Map<String, dynamic>> haritalar = await db.rawQuery("SELECT * FROM Kullanici");
    return List.generate(haritalar.length, (index) {
      var satir = haritalar[index];
      return Kullanici(
        kullaniciId: satir["kullaniciId"],
        adSoyad: satir["adSoyad"],
        eposta: satir["eposta"],
        kullaniciAdi: satir["kullaniciAdi"],
        kullaniciSifre: satir["kullaniciSifre"],
      );
    });
  }

  Future<int> kullaniciOlustur(Kullanici kullanici) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    return db.insert("Kullanici", kullanici.haritayaDonustur());
  }

  Future<bool> kayit(String adSoyad, String eposta, String kullaniciAdi, String kullaniciSifre) async {
    if (adSoyad.isEmpty || eposta.isEmpty || kullaniciAdi.isEmpty || kullaniciSifre.isEmpty) {
      return false; // Eksik bilgi varsa kayıt yapma işlemi başarısız olur
    }

    var mevcutKullanici = await kullaniciGetir(kullaniciAdi);
    if (mevcutKullanici != null) {
      return false;
    } else {

      var kullanici = Kullanici(adSoyad: adSoyad, eposta: eposta, kullaniciAdi: kullaniciAdi, kullaniciSifre: kullaniciSifre);
      await kullaniciOlustur(kullanici);
      return true;
    }
  }

  Future<Kullanici?> kullaniciGetir(String kullaniciAdi) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    var sonuc = await db.query(
      "Kullanici",
      where: "kullaniciAdi = ?",
      whereArgs: [kullaniciAdi],
    );
    return sonuc.isNotEmpty ? Kullanici.haritadan(sonuc.first) : null;
  }

  Future<void> kullaniciyiSil(int kullaniciId) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    await db.delete(
      "Kullanici",
      where: "kullaniciId = ?",
      whereArgs: [kullaniciId],
    );
    print("Kullanıcı silindi: $kullaniciId");
  }

  Future<void> kullaniciGuncelle(Kullanici kullanici) async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();

    // Veritabanında kullanıcı var mı kontrol edin
    Kullanici? mevcutKullanici = await kullaniciGetir(kullanici.kullaniciAdi);

    if (mevcutKullanici != null) {
      // Eğer kullanıcı varsa, güncelleme işlemini gerçekleştirin
      await db.update("Kullanici", kullanici.haritayaDonustur(), where: "kullaniciId = ?", whereArgs: [kullanici.kullaniciId]);
    } else {
      // Eğer kullanıcı yoksa, yeni bir kullanıcı ekleyin
      await kullaniciOlustur(kullanici);
    }
  }
  Future<void> printUserInfo() async {
    final Database db = await VeritabaniYardimcisi.veritabaniErisimi();
    List<Map<String, dynamic>> kullanicilar = await db.query('Kullanici');
    for (var user in kullanicilar) {
      print('Kullanıcı ID: ${user['usrId']}');
      print('Ad Soyad: ${user['fullName']}');
      print('Email: ${user['email']}');
      print('Kullanıcı Adı: ${user['usrName']}');
      print('Yaş: ${user['usrYas']}');
      print('Boy: ${user['usrBoy']}');
      print('Kilo: ${user['usrKilo']}');
      print('---------------------------------');
    }
  }
}
