import 'package:blood_sugar/data/entity/profil.dart';
import 'package:blood_sugar/data/repo/profil_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_sugar/data/entity/hatirlatici.dart';


class ProfilCubit extends Cubit<Hatirlatici?> {
  final ProfilDeposu profilDeposu;

  ProfilCubit({required this.profilDeposu}) : super(null);


  Future<void> profilGuncelle(Profil profil) async {
    await profilDeposu.profilGuncelle(profil);

  }

  Future<Profil?> profilBilgileriniGetir(int kullaniciId) async {
    return await profilDeposu.profilGetir(kullaniciId);

  }


}
