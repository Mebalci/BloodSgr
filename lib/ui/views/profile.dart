import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:blood_sugar/ui/views/giris.dart';
import 'package:blood_sugar/ui/views/login_scene.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final Kullanici? profil;

  const Profile({Key? key, this.profil}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String? _adSoyad;
  String? _email;
  String? _kullaniciAdi;
  int? _yas;

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  Future<void> _saveLoginState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    await prefs.setString('usrName', widget.profil!.kullaniciAdi);
  }

  void _initValues() async {
    Kullanici? kullanici = await KullaniciDeposu().kullaniciGetir(widget.profil!.kullaniciAdi);
    if (kullanici != null) {
      setState(() {
        _adSoyad = kullanici.adSoyad;
        _email = kullanici.eposta;
        _kullaniciAdi= kullanici.kullaniciAdi;
        _yas=kullanici.yas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "Profil",
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
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xff8201fe),
                    radius: 77,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/usr.png"),
                      radius: 67,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    _adSoyad ?? "",
                    style: TextStyle(fontSize: 28, color: Color(0xff8201fe)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        _saveLoginState(false);
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
                              child: const Login(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8201fe),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Çıkış Yap",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 30),
                    subtitle: Text("Ad Soyad"),
                    title: Text(_adSoyad ?? "", style: TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, size: 30),
                    subtitle: Text("Email"),
                    title: Text(_email ?? "", style: TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 30),
                    subtitle: Text("Kullanıcı Adı"),
                    title: Text(_kullaniciAdi ?? "", style: TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 30),
                    subtitle: Text("Kullanıcı Yas"),
                    title: Text(_yas==null ? "Boş" : _yas.toString(), style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            KullaniciDeposu().kullaniciyiSil(widget.profil!.kullaniciId!);
                            _saveLoginState(false);
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
                                  child: const LoginScene(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff8201fe),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Kullacıyı Sil",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
