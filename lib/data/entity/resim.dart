
import 'dart:typed_data';

class Resim {
  int? id;
  int kullaniciId;
  Uint8List? resim;

  Resim({this.id, required this.kullaniciId, this.resim
  });

  Map<String, dynamic> haritayaDonustur() {
    return {
      'id': id,
      'kullaniciId': kullaniciId,
      'resim': resim,
    };
  }

  Resim.haritadan(Map<String, dynamic> harita)
      : id = harita['id'],
        kullaniciId = harita['kullaniciId'],
        resim = harita['resim'];
}