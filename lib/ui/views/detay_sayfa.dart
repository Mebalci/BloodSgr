import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/ui/component/textfield.dart';
import 'package:blood_sugar/ui/cubit/detay_sayfa_cubit.dart';
import 'package:blood_sugar/ui/views/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DetaySayfa extends StatefulWidget {
  Kullanici? profil;
  KanSekeriOlcumu? kisi;
  DetaySayfa({this.profil,this.kisi});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  var _kansekeri = TextEditingController();
  var _olcumSaati = TextEditingController();
  var _kullanilanInsulinDozu = TextEditingController();
  var _yemekBilgisi = TextEditingController();

  void showFeedbackDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FeedbackDialog(message: message);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _kansekeri.text = widget.kisi!.kanSekeri.toString();
    _olcumSaati.text = widget.kisi!.olcumSaati.toString();
    _kullanilanInsulinDozu.text = widget.kisi!.insulinDozu.toString();
    _yemekBilgisi.text = widget.kisi!.yemekBilgisi;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text("Detay",
              style: TextStyle(
                color: const Color(0xff8201fe),
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width/12,
              )
          ),
        ),
      ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context); // Geri butonu işlevselliği
              },
              icon: const Icon(Icons.chevron_left),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50,right: 50, top: 50),
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InputField(hint: "Kan Şekeri", controller: _kansekeri),
              InputField(hint: "Ölçüm Saati", controller: _olcumSaati),
              InputField(hint: "İnsülin Dozu", controller: _kullanilanInsulinDozu),
              InputField(hint: "Yemek Bilgisi", controller: _yemekBilgisi),
              const SizedBox(height: 35,),
              SizedBox(
                width: MediaQuery.of(context).size.width *.9,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      KanSekeriOlcumu yeniProfil = KanSekeriOlcumu(
                        id: widget.kisi!.id,
                        kullaniciId: widget.kisi!.kullaniciId,
                        kanSekeri: double.tryParse(_kansekeri.text)?? 0.0,
                        olcumSaati: _olcumSaati.text,
                        insulinDozu: double.tryParse(_kullanilanInsulinDozu.text)?? 0.0,
                        yemekBilgisi: _yemekBilgisi.text,
                        acTokDurumu:  widget.kisi!.acTokDurumu,
                      );
                      context.read<DetaySayfaCubit>().olcumGuncelle(yeniProfil);
                      showFeedbackDialog(context, "Güncelleme Yapıldı.");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff8201fe),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Güncelle",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width/23,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}