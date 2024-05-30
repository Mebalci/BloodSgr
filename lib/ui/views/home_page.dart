import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/ui/views/veri_ac.dart';
import 'package:blood_sugar/ui/views/blood_sugar_monitoring.dart';
import 'package:blood_sugar/ui/views/diabetes_info_screen.dart';
import 'package:blood_sugar/ui/views/profile.dart';
import 'package:blood_sugar/ui/views/user_profil_page.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';


class HomePage extends StatefulWidget {
  final Kullanici? profil;
  const HomePage({super.key,this.profil});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  double widthContainer = 0;
  int buildBoxIndex = 0;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar( title: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text("Anasayfa",
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
      body:SingleChildScrollView(
        child:
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: buildBox(
                context,
                'Kan Şekeri',
                Color(0xff548ad8),Color(0xff8a4bd3),
                    widthContainer+300,
                buildBoxIndex,widget.profil

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180),
              child: buildBox(
                context,
                'Diyabet Nedir?',
                Color(0xff893e9c),Color(0xfff82b73),
                widthContainer+270,
                buildBoxIndex+1, widget.profil
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 310),
              child: buildBox(
                context,
                'Hatırlatıcı',
                Color(0xfff33e62),Color(0xfff79334),
                widthContainer+240,
                  buildBoxIndex+2,widget.profil
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 440),
              child: buildBox(
                context,
                'Kullanıcı',
                Color(0xff46d3d3),Color(0xffcccccd),
                widthContainer+210,
                  buildBoxIndex+3,
                widget.profil,
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

Widget buildBox(BuildContext context, String title, Color colorStart,Color colorFinish,double widthContainer,int buildBoxIndex,Kullanici? profil) {
  return InkWell(
    onTap:(){
      switch(buildBoxIndex){
        case 0:
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context)=> Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff43dddc),Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: BloodSugarMonitoring(profil: profil),
              ),
              )
          );
        case 1:
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context)=> Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff43dddc),Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: DiabetesInfoScreen(profil: profil,),
              ),
              )
          );
        case 2:
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context)=> Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff43dddc),Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: UserProfilePage(profil: profil,),
              ),
              ),
          );
        case 3:
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context)=> Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff43dddc),Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Profile(profil: profil,),
              ),
              ),
          );
      };
    } ,
    child: Container(
      width: widthContainer,
      height: 150,
      //margin: EdgeInsets.all(0),
      //padding: EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 7.0,
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            offset: Offset(0,3)
          )
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        gradient: LinearGradient(
          colors: [colorStart,colorFinish],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}



