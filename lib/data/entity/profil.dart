class Profil {
  int? id;
  int kullaniciId;
  int? aclikKanMin;
  int? aclikKanMax;
  int? toklukKanMax;
  String? kullanilanInsulin;
  String? cinsiyet;

  Profil({this.id, required this.kullaniciId, this.aclikKanMin,this.aclikKanMax,
  this.toklukKanMax,this.kullanilanInsulin,this.cinsiyet
  });

  Map<String, dynamic> haritayaDonustur() {
    return {
      'id': id,
      'kullaniciId': kullaniciId,
      'aclikKanMin': aclikKanMin,
      'aclikKanMax': aclikKanMax,
      'toklukKanMax': toklukKanMax,
      'kullanilanInsulin': kullanilanInsulin,
      'cinsiyet': cinsiyet,
    };
  }

  Profil.haritadan(Map<String, dynamic> harita)
      : id = harita['id'],
        kullaniciId = harita['kullaniciId'],
        aclikKanMin = harita['aclikKanMin'],
        aclikKanMax = harita['aclikKanMax'],
        toklukKanMax = harita['toklukKanMax'],
        kullanilanInsulin = harita['kullanilanInsulin'],
        cinsiyet = harita['cinsiyet'];
}