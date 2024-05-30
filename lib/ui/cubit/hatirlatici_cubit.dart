import 'package:blood_sugar/data/repo/hatirlatici_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_sugar/data/entity/hatirlatici.dart';


class HatirlaticiCubit extends Cubit<Hatirlatici?> {
  final HatirlaticiDeposu hatirlaticiDeposu;

  HatirlaticiCubit({required this.hatirlaticiDeposu}) : super(null);


  Future<void> hatirlaticiGuncelle(Hatirlatici hatirlatici) async {
    await hatirlaticiDeposu.hatirlaticiGuncelle(hatirlatici);
    emit(hatirlatici);

  }


}
