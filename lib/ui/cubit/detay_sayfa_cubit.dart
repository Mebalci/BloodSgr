import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:blood_sugar/data/repo/kan_sekeri_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DetaySayfaCubit extends Cubit<List<KanSekeriOlcumu>> {
  DetaySayfaCubit():super(<KanSekeriOlcumu>[]);


  var krepo = KanSekeriRepository();

  Future<void> olcumGuncelle(KanSekeriOlcumu olcum) async {
    await krepo.olcumGuncelle(olcum);
    emit(await krepo.tumOlcumleriGetir(olcum.kullaniciId));
  }
}