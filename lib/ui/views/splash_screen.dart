import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:blood_sugar/ui/views/home_page.dart';
import 'package:blood_sugar/ui/views/giris.dart';
import 'package:blood_sugar/ui/views/login_scene.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Kısa bir bekleme süresi ekliyoruz
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final usrName = prefs.getString('usrName');

    if (isLoggedIn && usrName != null) {
      try {
        Kullanici? usrDetay = await KullaniciDeposu().kullaniciGetir(usrName);
        if (!mounted) return;
        Navigator.pushReplacement(
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
              child: HomePage(profil: usrDetay),
            ),
          ),
        );
      } catch (e) {

        Navigator.pushReplacement(
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
              child: LoginScene(),
            ),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
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
            child: Login(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
