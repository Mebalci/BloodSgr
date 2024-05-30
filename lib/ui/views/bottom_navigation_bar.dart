import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/ui/views/create_profile.dart';
import 'package:blood_sugar/ui/views/data_page.dart';
import 'package:blood_sugar/ui/views/home_page.dart';
import 'package:blood_sugar/ui/views/profile.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped;
  final Kullanici? profil;

  const BottomNavigationBarWidget({super.key, required this.selectedIndex, this.onItemTapped,this.profil});


  @override
  Widget build(BuildContext context) {
    var sayfalar=[HomePage(profil: profil,),DataPage(profil: profil,),
      CreateProfile(profil: profil,), Profile(profil: profil,)];

    var _selectedindex=selectedIndex;

    void _onItemTapped(int index) {
      _selectedindex=index;
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
              child: sayfalar[_selectedindex],
            ),
            )
        );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color(0xff43dddc).withOpacity(0.8),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        buttonTheme: const ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all( 16.0 ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/home.png',
                width: 24,
                height: 24,
              ),
              label: 'Giriş',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/blood-1.png',
                width: 24,
                height: 24,
              ),
              label: 'Kan Şekeri',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/frame.png',
                width: 24,
                height: 24,
              ),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/ayarlar.png',
                width: 24,
                height: 24,
              ),
              label: 'Ayarlar',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped
        ),
      ),
    );
  }
}
