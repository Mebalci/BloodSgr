import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/ui/cubit/veri_cubit.dart';
import 'package:blood_sugar/ui/views/data_page.dart';
import 'package:blood_sugar/ui/views/detay_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VeriTok extends StatefulWidget {
  final Kullanici? profil;
  const VeriTok({super.key,this.profil});

  @override
  State<VeriTok> createState() => _VeriState();
}
class _VeriState extends State<VeriTok> {

  @override
  void initState() {
    super.initState();
    context.read<VeriCubit>().kisileriYukle(widget.profil!.kullaniciId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "Tok Değer",
              style: TextStyle(
                color: const Color(0xff8201fe),
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width / 12,
              ),
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
      body: BlocBuilder<VeriCubit, List<KanSekeriOlcumu>>(
        builder: (context, kisilerListesi) {
          List<KanSekeriOlcumu> acListesi = kisilerListesi.where((kisi) => kisi.acTokDurumu == 1).toList();
          if (acListesi.isNotEmpty) {
            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: acListesi.length,
              itemBuilder: (context, indeks) {
                var tersIndeks = acListesi.length - 1 - indeks;
                var kisi = acListesi[tersIndeks];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>  Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff43dddc), Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: DetaySayfa(profil: widget.profil,kisi: kisi,),
                        )
                        )
                    ).then((value) {
                      context.read<VeriCubit>().kisileriYukle(kisi.kullaniciId);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kisi.acTokDurumu == 0 ? "Aç" : "Tok",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text("Kan Şekeri ${kisi.kanSekeri} mg/dL", style: const TextStyle(fontWeight: FontWeight.bold, )),
                                  Text("Ölçüm Saati ${kisi.olcumSaati}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Kullanılan İnsülin Dozu ${kisi.insulinDozu} mg/dL", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 55,
                                    child: Text(
                                      "Yemek Bilgisi: ${kisi.yemekBilgisi}",
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${widget.profil?.adSoyad} silinsin mi?"),
                                    action: SnackBarAction(
                                      label: "Evet",
                                      onPressed: () {
                                        context.read<VeriCubit>().sil(kisi.id!, widget.profil!.kullaniciId!);
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.clear, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Tokluk verisi bulunmamaktadır."));
          }
        },
      ),
    );
  }
}
