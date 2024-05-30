import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/data/entity/profil.dart';
import 'package:blood_sugar/data/repo/profil_repo.dart';
import 'package:blood_sugar/ui/cubit/data_cubit.dart';
import 'package:blood_sugar/ui/views/home_page.dart';
import 'package:blood_sugar/ui/views/veri_ac.dart';
import 'package:blood_sugar/ui/views/veri_tok.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'bottom_navigation_bar.dart';


class DataPage extends StatefulWidget {
  final Kullanici? profil;
  const DataPage({super.key,this.profil});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {

  final KanSekeriCubit _kanSekeriAcCubit = KanSekeriCubit();
  final KanSekeriCubit _kanSekeriTokCubit = KanSekeriCubit();
  int _selectedIndex = 1;
  double? ortalamaAc;
  double? ortalamaTok;

  double minAc = 70.0;
  double maxAc = 100.0;
  double maxTok = 180.0;
  double minTok= 130;

  @override
  void initState() {
    super.initState();
    _kanSekeriAcCubit.loadKanSekeriAcData(widget.profil!.kullaniciId!);
    _kanSekeriTokCubit.loadKanSekeriTokData(widget.profil!.kullaniciId!);
    loadData();
  }

  @override
  void dispose() {
    _kanSekeriAcCubit.close();
    _kanSekeriTokCubit.close();
    loadData();
    super.dispose();
  }

  void loadData() async {
    Profil? deger = await ProfilDeposu().profilGetir(widget.profil!.kullaniciId!);

    if (deger != null) {
      setState(() {
        minAc = deger.aclikKanMin?.toDouble() ?? 70.0;
        maxAc = deger.aclikKanMax?.toDouble() ?? 100.0;
        maxTok = deger.toklukKanMax?.toDouble() ?? 180.0;

      });
    }
  }

  double ortalamaHesaplama(List<ChartDataColumn> chartDataColumns) {
    if (chartDataColumns.isEmpty) {
      return 0.0;
    }
    int totalYValue = chartDataColumns.map((data) => data.y).reduce((a, b) => a + b);
    double average = totalYValue / chartDataColumns.length;
    return average;
  }

  double ortalamaAcTokHesaplama(List<ChartDataColumn> chartDataColumns,List<ChartDataColumn> chartDataColumns2) {
    if (chartDataColumns.isEmpty) {
      return 0.0;
    }
    if (chartDataColumns2.isEmpty) {
      return 0.0;
    }
    int totalYValue = chartDataColumns.map((data) => data.y).reduce((a, b) => a + b);
    int totalYValue2 = chartDataColumns2.map((data) => data.y).reduce((a, b) => a + b);
    double average = totalYValue / chartDataColumns.length;
    double average2 = totalYValue2 / chartDataColumns2.length;
    return (average+average2)/2;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.08;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight),
        child: AppBar( title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text("Datalar",
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
                        child: HomePage(profil: widget.profil,),
                      )
                      )
                  );
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
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<KanSekeriCubit, List<ChartDataColumn>>(
              bloc: _kanSekeriAcCubit,
              builder: (context, Acstate) {
                ortalamaAc = ortalamaHesaplama(Acstate);
                return BlocBuilder<KanSekeriCubit, List<ChartDataColumn>>(
                  bloc: _kanSekeriTokCubit,
                  builder: (context, Tokstate) {
                    ortalamaTok = ortalamaHesaplama(Tokstate);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                                _buildChartContainer('Açlık Kan Şekeri', Acstate,screenWidth,ortalamaHesaplama(Acstate), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xff43dddc), Colors.white],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: VeriAc(profil: widget.profil),
                                      ),
                                    ),
                                  );
                                }),
                                _buildChartContainer('Tokluk Kan Şekeri', Tokstate, screenWidth,ortalamaHesaplama(Tokstate), () {
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
                                        child: VeriTok(profil: widget.profil,),
                                      )
                                      )
                                  );
                                }),
                      ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircularChart('Ortalama Kan Şekeri',ortalamaAcTokHesaplama(Acstate, Tokstate),screenWidth),
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 2,
                             ),
                             borderRadius: BorderRadius.circular(10),
                          ),
                      width:  screenWidth/ 2.5,
                      height: screenWidth / 1.5,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *.9,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
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
                                            child: VeriAc(profil: widget.profil,),
                                          )
                                          )
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff8201fe),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Aç Değerler",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width/23,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *.9,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
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
                                            child: VeriTok(profil: widget.profil,),
                                          )
                                          )
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff8201fe),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Tok Değerler",
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
                      ],
                      ),

                        if((ortalamaTok! > 0))
                        if ((ortalamaTok! > maxTok || ortalamaTok! < maxTok))
                          _uyari('Tokluk kan şekeri değerleriniz sınırların dışında! Lütfen doktorunuza danışın.', screenWidth),
                        if((ortalamaAc! > 0 ))
                        if ((ortalamaAc! < minAc || ortalamaAc! > maxAc))
                          _uyari('Açlık kan şekeri değerleriniz sınırların dışında! Lütfen doktorunuza danışın.', screenWidth),
                      ],
                    );
                  },
                );
              },
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

Widget _uyari (String text, double screenWidth){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth / 25,
        ),
      ),
    ),
  );
}

Widget _buildChartContainer(String title, List<ChartDataColumn> chartData, double screenWidth,double ortalama,VoidCallback onTap) {

  return GestureDetector(
    onTap: (){
      onTap;
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.deepPurpleAccent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width:  screenWidth/ 2.5,
      height: screenWidth / 1.5,
      child: Stack(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff8201fe),
              fontWeight: FontWeight.bold,
              fontSize: screenWidth / 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 55, left: 10, right: 10),
            child: SfCartesianChart(
              borderWidth: 0,
              borderColor: Colors.transparent,
              primaryXAxis: NumericAxis(isVisible: false),
              primaryYAxis: NumericAxis(isVisible: false),
              series: <ChartSeries>[
                ColumnSeries<ChartDataColumn, int>(
                  borderColor: Colors.transparent,
                  borderWidth: 0.0,
                  dataSource: chartData,
                  xValueMapper: (ChartDataColumn data, _) => data.x,
                  yValueMapper: (ChartDataColumn data, _) => data.y,
                  borderRadius: BorderRadius.circular(15),
                  pointColorMapper: (ChartDataColumn data, _) => const Color(0xff8201fe),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 85),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/mask_group.png',
                      width: screenWidth / 2.5,
                      height: screenWidth / 2.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                        left: ((screenWidth/ 2.5)-90)/2,
                        bottom: 15,
                        child: Container(
                          width:  90,
                          height: 20,
                          child: Text(
                            "${ortalama.toInt()} mg/dL",
                            style: TextStyle(
                              color: Color(0xff8201fe),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 25,
                            ),
                          ),
                        ),
                      ),

                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCircularChart(String title,double charData, double screenWidth) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(
        color: Colors.deepPurpleAccent,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    width:  screenWidth/ 2.5,
    height: screenWidth / 1.5,
    child: Stack(

      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xff8201fe),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth / 25,
          ),
        ),

        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCircularChart(
                series: <CircularSeries>[
                  RadialBarSeries<ChartData, String>(
                    dataSource: <ChartData>[
                      ChartData('Blood Sugar', charData),
                    ],
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.value,
                    cornerStyle: CornerStyle.bothCurve,
                    trackColor: Colors.white,
                    maximumValue: 200,
                    radius: '100%',
                    innerRadius: '80%',
                    pointColorMapper: (ChartData data, _) => const Color(0xff8201fe),
                  ),
                ],
              ),
            ),
            Text(
              "${charData.toInt()} mg/dL",
              style: TextStyle(
                color: Color(0xff8201fe),
                fontWeight: FontWeight.bold,
                fontSize: screenWidth / 30,
              ),
            ),
          ],
        ),

      ],
    ),
  );
}


class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}

class ChartDataColumn {
  final int x;
  final int y;

  ChartDataColumn(this.x, this.y);
}
