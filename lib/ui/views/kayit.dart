import 'package:blood_sugar/ui/component/textfield.dart';
import 'package:blood_sugar/ui/cubit/kayıt_cubit.dart';
import 'package:blood_sugar/ui/views/giris.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isLoginTrue=false;
  final kullaniciAdi=TextEditingController();
  final email=TextEditingController();
  final sifre=TextEditingController();
  final sifreTekrari=TextEditingController();
  final adSoyad=TextEditingController();



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
      body: BlocListener<KayitCubit, bool>(
        listener: (context, state) {
          if (state==true) {
            Navigator.pushReplacement(
              context,
                MaterialPageRoute(builder: (context)=> Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff43dddc),Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Login(),
                ),
                ),
            );
          }
          else{
            setState(() {
              isLoginTrue=true;
            });

          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Merhaba! Haydi başlayalım",
                    style: TextStyle(
                      color: Color(0xff8201fe),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  InputField(hint: "Ad Soyad", controller: adSoyad ),
                  InputField(hint: "Email", controller: email,keyboardType: TextInputType.emailAddress, ),
                  InputField(hint: "Kullanıcı Adı", controller: kullaniciAdi ),
                  InputField(hint: "Şifre", controller: sifre, keyboardType: TextInputType.number, ),
                  InputField(hint: "Şifreyi Tekrar Giriniz", controller: sifreTekrari,keyboardType: TextInputType.number,),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *0.9,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (sifre.text==sifreTekrari.text) {
                          context.read<KayitCubit>().kayitYap(
                            adSoyad.text,
                            email.text,
                            kullaniciAdi.text,
                            sifre.text,
                          );
                          print("şifre doğru");
                        } else {
                          setState(() {
                            isLoginTrue=true;
                            print("şifre hatası");
                          });
                        }
                      },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8201fe),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Kayıt Ol",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoginTrue? Text("Bilgilerinizi Kontrol Edin",style: TextStyle(color: Colors.red,fontSize: 20),):SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Zaten Bir Hesabın Var Mı?"),
                      TextButton(
                        onPressed: () {
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
                                child: const Login(),
                              ),
                              )
                          );
                        },
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(color: Color(0xff8201fe)),
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
