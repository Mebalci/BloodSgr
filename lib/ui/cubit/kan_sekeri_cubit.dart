import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:blood_sugar/data/repo/kan_sekeri_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KanSekeriCubit extends Cubit<List<KanSekeriOlcumu>> {
  final KanSekeriRepository kanSekeriRepository;

  KanSekeriCubit({required this.kanSekeriRepository}) : super([]);

  Future<void> olcumEkle(KanSekeriOlcumu olcum) async {
    await kanSekeriRepository.olcumEkle(olcum);
    emit(await kanSekeriRepository.tumOlcumleriGetir(olcum.kullaniciId));
  }

  Future<void> olcumGuncelle(KanSekeriOlcumu olcum) async {
    await kanSekeriRepository.olcumGuncelle(olcum);
    emit(await kanSekeriRepository.tumOlcumleriGetir(olcum.kullaniciId));
  }

  Future<void> olcumSil(int id, int kullaniciId) async {
    await kanSekeriRepository.olcumSil(id);
    emit(await kanSekeriRepository.tumOlcumleriGetir(kullaniciId));
  }
}
