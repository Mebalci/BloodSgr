import 'package:blood_sugar/ui/views/kayit.dart';
import 'package:blood_sugar/ui/views/splash_screen.dart';
import 'package:flutter/material.dart';

class LoginScene extends StatefulWidget {
  const LoginScene({super.key});

  @override
  State<LoginScene> createState() => _LoginSceneState();
}

class _LoginSceneState extends State<LoginScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.width/2,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.width/2,
                          child: Image.asset("C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/blood_sugar_logo.png")),

                      Text("BloodSGR",
                        style: TextStyle(
                            color: Color(0xff8201fe),
                            decoration: TextDecoration.none,
                          fontSize: MediaQuery.of(context).size.width/8
                        ),
                      ),
                      const SizedBox(height: 60,),

                      LoginPageButtonComponent(
                        textColor: Colors.white,
                        buttonText: "Giriş" ,
                        buttonBackGroundColor: Color(0xff8201fe),
                        buttonBorderOpacity: 0,
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
                                child: const SplashScreen(),
                            ),
                          )
                          );
                        },
                      ),
                      const SizedBox(height: 30,),

                      LoginPageButtonComponent(
                        textColor: Colors.black,buttonText: "Kayıt Ol",
                        buttonBackGroundColor: Colors.white,
                        buttonBorderOpacity: 0.1,
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
                                child: const RegisterView(),
                              )
                              )
                          );
                        },
                      )
                    ]
                )
              ],
            ),
          ),

      ),
    );
  }
}

class LoginPageButtonComponent extends StatelessWidget {
  const LoginPageButtonComponent({
    super.key,
    required this.textColor,
    required this.buttonText,
    required this.buttonBackGroundColor,
    required this.buttonBorderOpacity,
    required this.onPressed,
  });
  final Color textColor;
  final String buttonText;
  final Color buttonBackGroundColor;
  final double buttonBorderOpacity;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width *.9,
        height: 55,
        child: ElevatedButton(onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            side: BorderSide(
                color: Colors.black.withOpacity(buttonBorderOpacity)
            ),
            backgroundColor: buttonBackGroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
          ),
          child: Text(buttonText.toString(),
            style: TextStyle(
                color: textColor,
              fontSize: MediaQuery.of(context).size.width/22,
            ),
          ),
        )
    );
  }
}

