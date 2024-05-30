import 'package:blood_sugar/data/repo/kan_sekeri_repo.dart';
import 'package:blood_sugar/data/repo/profil_repo.dart';
import 'package:blood_sugar/ui/cubit/detay_sayfa_cubit.dart';
import 'package:blood_sugar/ui/cubit/kan_sekeri_cubit.dart';
import 'package:blood_sugar/ui/cubit/profil_cubit.dart';
import 'package:blood_sugar/data/repo/hatirlatici_repo.dart';
import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:blood_sugar/ui/cubit/giris_cubit.dart';
import 'package:blood_sugar/ui/cubit/hatirlatici_cubit.dart';
import 'package:blood_sugar/ui/cubit/kayıt_cubit.dart';
import 'package:blood_sugar/ui/cubit/user_cubit.dart';
import 'package:blood_sugar/ui/cubit/veri_cubit.dart';
import 'package:blood_sugar/ui/views/login_scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;




void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the timezone package
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>GirisCubit(kullaniciDeposu: KullaniciDeposu())),
        BlocProvider(create: (context)=>KayitCubit(kullaniciDeposu: KullaniciDeposu())),
        BlocProvider(create: (context)=>UserCubit(kullaniciDeposu: KullaniciDeposu())),
        BlocProvider(create: (context)=>ProfilCubit(profilDeposu: ProfilDeposu())),
        BlocProvider(create: (context)=>VeriCubit()),
        BlocProvider(create: (context)=>DetaySayfaCubit()),
        BlocProvider(create: (context)=>KanSekeriCubit(kanSekeriRepository: KanSekeriRepository())),
        BlocProvider(create: (context)=>HatirlaticiCubit(hatirlaticiDeposu: HatirlaticiDeposu()),


        ),
      ],
      child: MaterialApp(
        title: 'BloodSugar',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0.0,
          ),
        ),
        home: LayoutBuilder(
          builder: (context, constraints) {
            // MediaQuery ile ekran boyutlarını al
            var screen = MediaQuery.of(context);
            double screenWidth = screen.size.width;
            // Ekran boyutuna göre LoginScene'i döndür
            if (screenWidth > 600) {
              // Büyük ekran için farklı tasarım
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff43dddc), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 600,
                    height: 800,
                    child: LoginScene(),
                  ),
                ),
              );
            } else {
              // Küçük ekran için standart tasarım
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff43dddc), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const LoginScene(),
              );
            }
          },
        ),
      ),
    );
  }
}

