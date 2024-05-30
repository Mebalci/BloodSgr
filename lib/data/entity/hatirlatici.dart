class Hatirlatici {
  int? id;
  int kullaniciId;
  String sabahSaati;
  String ogleSaati;
  String aksamSaati;

  Hatirlatici({this.id, required this.kullaniciId, required this.sabahSaati, required this.ogleSaati, required this.aksamSaati});

  Map<String, dynamic> haritayaDonustur() {
    return {
      'id': id,
      'kullaniciId': kullaniciId,
      'sabahSaati': sabahSaati,
      'ogleSaati': ogleSaati,
      'aksamSaati': aksamSaati,
    };
  }

  Hatirlatici.haritadan(Map<String, dynamic> harita)
      : id = harita['id'],
        kullaniciId = harita['kullaniciId'],
        sabahSaati = harita['sabahSaati'],
        ogleSaati = harita['ogleSaati'],
        aksamSaati = harita['aksamSaati'];
}