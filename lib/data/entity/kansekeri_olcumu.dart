class KanSekeriOlcumu {
  int? id;
  int kullaniciId;
  double kanSekeri;
  String olcumSaati;
  double? insulinDozu;
  String yemekBilgisi;
  int acTokDurumu;

  KanSekeriOlcumu({
    this.id,
    required this.kullaniciId,
    required this.kanSekeri,
    required this.olcumSaati,
    this.insulinDozu,
    required this.yemekBilgisi,
    required this.acTokDurumu,
  });

  factory KanSekeriOlcumu.fromMap(Map<String, dynamic> map) {
    return KanSekeriOlcumu(
      id: map['id'],
      kullaniciId: map['kullaniciId'],
      kanSekeri: map['kanSekeri'] is String ? double.parse(map['kanSekeri']) : map['kanSekeri'],
      olcumSaati: map['olcumSaati'],
      insulinDozu: map['insulinDozu'] is String ? double.parse(map['insulinDozu']) : map['insulinDozu'],
      yemekBilgisi: map['yemekBilgisi'],
      acTokDurumu: map['acTokDurumu'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kullaniciId': kullaniciId,
      'kanSekeri': kanSekeri,
      'olcumSaati': olcumSaati,
      'insulinDozu': insulinDozu,
      'yemekBilgisi': yemekBilgisi,
      'acTokDurumu': acTokDurumu,
    };
  }
}
