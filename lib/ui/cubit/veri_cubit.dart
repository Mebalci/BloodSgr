import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:blood_sugar/data/repo/kan_sekeri_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VeriCubit extends Cubit<List<KanSekeriOlcumu>>{
  VeriCubit():super(<KanSekeriOlcumu>[]);

  var krepo= KanSekeriRepository();

  Future<void> kisileriYukle(int kullaniciId) async{
    var liste = await krepo.tumOlcumleriGetir(kullaniciId);
    emit(liste);
  }

  Future<void> sil(int Id, int kullaniciId) async {
    await krepo.olcumSil(Id);
    await kisileriYukle(kullaniciId);
  }

}