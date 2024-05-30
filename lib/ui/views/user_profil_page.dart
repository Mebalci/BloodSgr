import 'package:blood_sugar/data/repo/hatirlatici_repo.dart';
import 'package:blood_sugar/data/repo/profil_repo.dart';
import 'package:blood_sugar/ui/views/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:blood_sugar/data/entity/hatirlatici.dart';
import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/data/repo/user_repository.dart';
import 'package:blood_sugar/ui/cubit/hatirlatici_cubit.dart';
import 'package:blood_sugar/ui/cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_navigation_bar.dart';

class UserProfilePage extends StatefulWidget {
  final Kullanici? profil;
  const UserProfilePage({super.key, this.profil});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _selectedIndex = 0;
  int _age = 30;
  double _height = 170.0;
  double _weight = 70.0;
  TimeOfDay? _morningTime;
  TimeOfDay? _noonTime;
  TimeOfDay? _eveningTime;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initValues();

    // Initialize the FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  TimeOfDay stringToTimeOfDay(String time) {
    // Zamanı saat ve dakika bileşenlerine ayır
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // TimeOfDay nesnesi oluştur ve döndür
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _initValues() async {
    Kullanici? kullanici = await KullaniciDeposu().kullaniciGetir(widget.profil!.kullaniciAdi);
    Hatirlatici? hatirlatici = await HatirlaticiDeposu().hatirlaticiGetir(widget.profil!.kullaniciId!);
    if (kullanici != null) {
      setState(() {
        _age = kullanici.yas ?? _age;
        _height = kullanici.boy?.toDouble() ?? _height;
        _weight = kullanici.kilo?.toDouble() ?? _weight;


      });
    }
  }

  void showFeedbackDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FeedbackDialog(message: message);
      },
    );
  }

  void scheduleNotification(TimeOfDay time, String message) {
    final now = DateTime.now();
    final notificationTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_channel', // channel_id
      'Hatırlatıcılar',   // channel_name
    );
    const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Hatırlatıcı',
      message,
      notificationTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Text(
                  "Kullanıcı Bilgileri",
                  style: TextStyle(
                    color: const Color(0xff8201fe),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
                Text(
                  " ve ",
                  style: TextStyle(
                    color: const Color(0xff8201fe),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
                Text(
                  "Hatırlatıcı",
                  style: TextStyle(
                    color: const Color(0xff8201fe),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 30),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              Text(
                'Kaç Yaşındasınız: $_age',
                style: TextStyle(
                  color: const Color(0xff8201fe),
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 22,
                ),
              ),
              Slider(
                value: _age.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _age.toString(),
                onChanged: (double value) {
                  setState(() {
                    _age = value.toInt();
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              Text(
                'Boyunuz Kaç: ${_height.toStringAsFixed(1)} cm',
                style: TextStyle(
                  color: const Color(0xff8201fe),
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 22,
                ),
              ),
              Slider(
                value: _height,
                min: 100.0,
                max: 250.0,
                divisions: 150,
                label: _height.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _height = value;
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              Text(
                'Kilonuz Kaç: ${_weight.toStringAsFixed(1)} kg',
                style: TextStyle(
                  color: const Color(0xff8201fe),
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 22,
                ),
              ),
              Slider(
                value: _weight,
                min: 30.0,
                max: 200.0,
                divisions: 170,
                label: _weight.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _weight = value;
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              buildTimePicker(
                context,
                'Sabah:',
                _morningTime,
                    (time) {
                  setState(() {
                    _morningTime = time;
                    if (time != null) {
                      scheduleNotification(time, 'Sabah hatırlatıcısı');
                    }
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              buildTimePicker(
                context,
                'Öğlen:',
                _noonTime,
                    (time) {
                  setState(() {
                    _noonTime = time;
                    if (time != null) {
                      scheduleNotification(time, 'Öğlen hatırlatıcısı');
                    }
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              buildTimePicker(
                context,
                'Akşam:',
                _eveningTime,
                    (time) {
                  setState(() {
                    _eveningTime = time;
                    if (time != null) {
                      scheduleNotification(time, 'Akşam hatırlatıcısı');
                    }
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Center(
                child: SizedBox(width: MediaQuery.of(context).size.width *.9,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      Kullanici updatedProfile = Kullanici(
                        kullaniciId: widget.profil?.kullaniciId,
                        adSoyad: widget.profil?.adSoyad,
                        eposta: widget.profil?.eposta,
                        kullaniciAdi: widget.profil?.kullaniciAdi ?? '',
                        kullaniciSifre: widget.profil?.kullaniciSifre ?? '',
                        yas: _age,
                        boy: _height.toInt(),
                        kilo: _weight.toInt(),
                      );

                      // UserCubit kullanarak kullanıcı bilgilerini güncelle
                      context.read<UserCubit>().kullaniciGuncelle(updatedProfile);

                      // Hatırlatıcı bilgilerini oluştur ve eklemek
                      Hatirlatici hatirlatici = Hatirlatici(
                        kullaniciId: updatedProfile.kullaniciId ?? 0,
                        sabahSaati: _morningTime?.format(context) ?? '',
                        ogleSaati: _noonTime?.format(context) ?? '',
                        aksamSaati: _eveningTime?.format(context) ?? '',
                      );

                      context.read<HatirlaticiCubit>().hatirlaticiGuncelle(hatirlatici);

                      showFeedbackDialog(context, "Kayıt Yapıldı");

                      await ProfilDeposu().printUserInfo();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff8201fe),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),


      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        profil: widget.profil,
      ),
    );
  }

  Widget buildTimePicker(BuildContext context, String label, TimeOfDay? time, Function(TimeOfDay?) onChanged) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xff8201fe),
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 22,
            ),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width / 60),
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: time ?? TimeOfDay.now(),
              );
              onChanged(pickedTime);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xff8201fe)),
              ),
              child: Center(
                child: Text(
                  time != null ? time.format(context) : 'Saat Seç',
                  style: TextStyle(
                    color: const Color(0xff8201fe),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
