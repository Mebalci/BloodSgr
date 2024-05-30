class Kullanici {
  int? kullaniciId;
  String? adSoyad;
  String? eposta;
  String kullaniciAdi;
  String kullaniciSifre;
  int? yas;
  int? boy;
  int? kilo;

  Kullanici({this.kullaniciId, this.adSoyad, this.eposta, required this.kullaniciAdi, required this.kullaniciSifre, this.yas, this.boy, this.kilo});

  Map<String, dynamic> haritayaDonustur() {
    return {
      'kullaniciId': kullaniciId,
      'adSoyad': adSoyad,
      'eposta': eposta,
      'kullaniciAdi': kullaniciAdi,
      'kullaniciSifre': kullaniciSifre,
      'yas': yas,
      'boy': boy,
      'kilo': kilo,
    };
  }

  Kullanici.haritadan(Map<String, dynamic> harita)
      : kullaniciId = harita['kullaniciId'],
        adSoyad = harita['adSoyad'],
        eposta = harita['eposta'],
        kullaniciAdi = harita['kullaniciAdi'],
        kullaniciSifre = harita['kullaniciSifre'],
        yas = harita['yas'],
        boy = harita['boy'],
        kilo = harita['kilo'];
}
