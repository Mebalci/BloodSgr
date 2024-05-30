import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class KayitCubit extends Cubit<bool> {
  final KullaniciDeposu kullaniciDeposu;

  KayitCubit({required this.kullaniciDeposu}) : super(false);

  Future<void> kayitYap(String adSoyad, String eposta, String kullaniciAdi, String kullaniciSifre) async {
    bool kayitBasarili = await kullaniciDeposu.kayit(adSoyad, eposta, kullaniciAdi, kullaniciSifre);
    if (kayitBasarili) {
      // Kayıt başarılı ise
      emit(true);
    } else {
      // Kayıt başarısız ise
      emit(false);
      // Kullanıcıya uygun bir hata mesajı gösterilebilir
    }
  }
}
