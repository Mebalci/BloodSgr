import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class DiabetesInfoScreen extends StatefulWidget {
  final Kullanici? profil;
  const DiabetesInfoScreen({super.key,this.profil});


  @override
  _DiabetesInfoScreenState createState() => _DiabetesInfoScreenState();
}

class _DiabetesInfoScreenState extends State<DiabetesInfoScreen> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              icon: Icon(Icons.chevron_left),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Diyabet Nedir",
                style: TextStyle(
                  color: Color(0xff8201fe),
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height/26
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child:
                  const Text(
                      "Açlık kan şekeri seviyesi, desilitre başına alt sınır 70 miligram (mg/dL) ile üst sınır 126 miligram (mg/dL) olarak kabul edilmektedir. Açlık kan şekeri seviyesi 70-100 mg/dL arasında bir değerde ise normal (sağlıklı) değerde olduğu bilinmektedir. Hamilelerde açlık kan şekeri değeri ise 95 mg/dL’ nin altında olmalıdır. Açlık kan şekeri testi yaptırdıktan sonra eğer değerler normalin dışında çıktıysa sizde hipoglisemi, prediyabet (gizli şeker) ve diyabet olabileceğini gösterir. "
                          "50-70 mg/dL’ ik açlık kan şekeri seviyesi, hipoglisemi oabileceğinizi göstermektedir. "
                          "100-125 mg/dL’ ik açlık kan şekeri seviyesi, prediyabet (gizli şeker) olduğunuzu göstermektedir."
                          "126 mg/dL ve daha yüksek bir açlık kan şekeri seviyesi ise diyabet olduğunuzu göstermektedir."
                          "2 adet ölçülen açlık kan şekeri test sonuçlarınız mutlaka doktorunuz tarafından genel bir değerlendirmeye alınmalıdır."
                          "                                                                                                                                                                                            "
                          "Tokluk kan şekeri, yemek sonrası kanda yükselen ya da azalan şeker varlığının ne kadar olduğunu gösteren bir ölçümdür. Tokluk kan şekeri testi de açlık kan şekeri testi gibi diyabet hastalığının teşhisinde oldukça önemlidir."
                          "                                                                        "
                          "Tokluk kan şekeri seviyesi alt sınır olarak 100 mg/dL ve üst sınır olarak 200 mg/dL kabul edilmektedir. Tokluk kan şekeri seviyesi 100-140 mg/dL ‘lik bir değerde ise kişinin normal (sağlıklı) değerlerde olduğunu göstermektedir.140-199 mg/dL’ lik tokluk kan şekeri seviyesi değeri prediyabet (gizli şeker) olduğunuzu göstermektedir. 200 mg/dL ve üzeri bir tokluk kan şekeri seviyesi değeri ise diyabet tanısı koymak için gereken değerdir. Tokluk kan şekeri değeriniz mutlaka bir uzman doktor tarafından detaylı olarak değerlendirilmelidir."
                         ,overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 16.0,),
                    ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        profil: widget.profil,
      ),

    );
  }
}
