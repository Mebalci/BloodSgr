
import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:blood_sugar/sqlite/veritabani_yardimcisi.dart';
import 'package:blood_sugar/ui/component/textfield.dart';
import 'package:blood_sugar/ui/cubit/giris_cubit.dart';
import 'package:blood_sugar/ui/views/forgot_password_view.dart';
import 'package:blood_sugar/ui/views/home_page.dart';
import 'package:blood_sugar/ui/views/login_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final kullaniciAdi=TextEditingController();
  final sifre=TextEditingController();
  bool isChecked=false;
  bool isLoginTrue=false;
  final db= VeritabaniYardimcisi.veritabaniErisimi();

  Future<void> _saveLoginState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    await prefs.setString('usrName', kullaniciAdi.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width/20,
              height: MediaQuery.of(context).size.width/20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=> Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff43dddc),Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: const LoginScene(),
                        ),
                      )
                  );
                },
                icon: Icon(Icons.chevron_left),
              ),
            ),
          ),
        ),
        body: BlocListener<GirisCubit, bool>(
          listener: (context, state) async{
            if (state==true) {
              print("kullanıcı var");
              if(!mounted) return;
              Kullanici? usrDetay= await KullaniciDeposu().kullaniciGetir(kullaniciAdi.text);
              if (isChecked) {
                await _saveLoginState(true);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=> Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff43dddc),Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: HomePage(profil: usrDetay),
                  ),
                  )
              );

            }
            else {
              setState(() {
                print("hata mesajı");
                isLoginTrue= true;
              });

            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/26),
                    Text(
                      "Tekrardan BloodSGR'a Hoşgeldiniz.",
                      style: TextStyle(
                        color: Color(0xff8201fe),
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height/26,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/26),
                    InputField(hint: "Kullanıcı Adı Giriniz...", controller: kullaniciAdi,keyboardType: TextInputType.text,),
                    InputField(hint: "Sifre Giriniz...", controller: sifre,keyboardType: TextInputType.number,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Color(0xff8201fe),
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                            ),
                            const Text("Beni Hatırla",style: TextStyle(color:Color(0xff8201fe) ),),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
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
                                  child: const ForgotPasswordView(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Şifrenizi mi Unuttunuz?",
                            style: TextStyle(color: Color(0xff8201fe)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *.9,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            context.read<GirisCubit>().girisYap(
                              kullaniciAdi.text,
                              sifre.text,
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
                          "Giriş",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width/22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    isLoginTrue? Text("Kullanıcıadı Yada Şifre Hatalı",style: TextStyle(color: Colors.red,fontSize: 20),):SizedBox(
                      height: 20,
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
