import 'package:blood_sugar/ui/component/textfield.dart';
import 'package:blood_sugar/ui/views/giris.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();



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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "Şifrenizi Unuttunuz?",
                style: TextStyle(
                  color: Color(0xff8201fe),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  "Mailinize Yeni Bir Şifre Gönderilecek",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 30),
              InputField(hint: "Mailinizi Giriniz", controller: emailController),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width *0.9,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    //////////////////////////////
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff8201fe),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Şifre Sıfırlama",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/22),
                  ),
                ),
              ),
              SizedBox(height: 290),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Şifrenizi Hatırladınız mı?"),
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
    );
  }
}

