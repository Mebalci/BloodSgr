import 'package:blood_sugar/ui/views/data_page.dart';
import 'package:bloc/bloc.dart';
import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:blood_sugar/data/repo/kan_sekeri_repo.dart';

class KanSekeriCubit extends Cubit<List<ChartDataColumn>> {
  final KanSekeriRepository _repository = KanSekeriRepository();

  KanSekeriCubit() : super([]);

  void loadKanSekeriAcData(int kullaniciId) async {
    try {
      final List<KanSekeriOlcumu> olcumler = await _repository.sonBesGunAcOlcumleriGetir(kullaniciId);
      final List<ChartDataColumn> chartData = olcumler.map((olcum) {
        return ChartDataColumn(olcum.id!, olcum.kanSekeri.round());
      }).toList();
      emit(chartData);
    } catch (e) {
      emit([]);
    }
  }

  void loadKanSekeriTokData(int kullaniciId) async {
    try {
      final List<KanSekeriOlcumu> olcumler = await _repository.sonBesGunTokOlcumleriGetir(kullaniciId);
      final List<ChartDataColumn> chartData = olcumler.map((olcum) {
        return ChartDataColumn(olcum.id!, olcum.kanSekeri.round());
      }).toList();
      emit(chartData);
    } catch (e) {
      emit([]);
    }
  }


}