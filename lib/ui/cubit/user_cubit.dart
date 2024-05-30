import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_sugar/data/entity/kullanici.dart';



class UserCubit extends Cubit<Kullanici?> {
  final KullaniciDeposu kullaniciDeposu;


  UserCubit({required this.kullaniciDeposu, }) : super(null);

  Future<void> kullaniciGuncelle(Kullanici kullanici) async {
    await kullaniciDeposu.kullaniciGuncelle(kullanici);
    emit(kullanici);
  }




}
