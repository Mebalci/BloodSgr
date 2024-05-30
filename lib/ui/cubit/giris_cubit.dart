import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GirisCubit extends Cubit<bool> {
  final KullaniciDeposu kullaniciDeposu;

  GirisCubit({required this.kullaniciDeposu}) : super(false);

  Future<void> girisYap(String kullaniciAdi, String kullaniciSifre) async {
    var kimlikDogrulandi = await kullaniciDeposu.kimlikDogrulama(
      Kullanici(kullaniciAdi: kullaniciAdi, kullaniciSifre: kullaniciSifre),
    );
    emit(kimlikDogrulandi);
  }
}
