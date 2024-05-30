import 'dart:io';
import 'dart:typed_data';
import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/data/entity/profil.dart';
import 'package:blood_sugar/data/repo/profil_repo.dart';
import 'package:blood_sugar/ui/component/textfield.dart';
import 'package:blood_sugar/ui/cubit/profil_cubit.dart';
import 'package:blood_sugar/ui/views/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'bottom_navigation_bar.dart';

class CreateProfile extends StatefulWidget {
  final Kullanici? profil;
  const CreateProfile({super.key,this.profil});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File? _imageFile;
  String? _selectedGender;
  Uint8List? _resimBytes;
  final picker = ImagePicker();
  final int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _initValues();
    _resmiAl();
  }

  Future<void> _resimSecVeYukle() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  var aclikKanMinController = TextEditingController();
  var aclikKanMaxController = TextEditingController();
  var toklukKanMaxController = TextEditingController();
  var kullanilanInsulinController = TextEditingController();

  void showFeedbackDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FeedbackDialog(message: message);
      },
    );
  }

  void _initValues() async {
    Profil? kullanici =
    await ProfilDeposu().profilGetir(widget.profil!.kullaniciId!);

    if (kullanici != null) {
      aclikKanMinController.text = kullanici.aclikKanMin.toString();
      aclikKanMaxController.text = kullanici.aclikKanMax.toString();
      toklukKanMaxController.text = kullanici.toklukKanMax.toString();
      kullanilanInsulinController.text = kullanici.kullanilanInsulin.toString();
      setState(() {
        _selectedGender = kullanici.cinsiyet;
      });
    }
  }

  Future<void> _validateAndSubmit() async {
    List<String> errorMessages = [];

    if (aclikKanMinController.text.isNotEmpty &&
        double.tryParse(aclikKanMinController.text) == null) {
      errorMessages.add('Geçersiz Açlık Min Kan Şekeri Değeri');
    }
    if (aclikKanMaxController.text.isNotEmpty &&
        double.tryParse(aclikKanMaxController.text) == null) {
      errorMessages.add('Geçersiz Açlık Max Kan Şekeri Değeri');
    }
    if (toklukKanMaxController.text.isNotEmpty &&
        double.tryParse(toklukKanMaxController.text) == null) {
      errorMessages.add('Geçersiz Tokluk Kan Şekeri Değeri');
    }
    String errorMessage = errorMessages.join("\n");

    if (errorMessages.isNotEmpty) {
      showFeedbackDialog(context, errorMessage);
    } else {
      Profil yeniProfil = Profil(
        kullaniciId: widget.profil!.kullaniciId!,
        aclikKanMin: int.parse(aclikKanMinController.text),
        aclikKanMax: int.parse(aclikKanMaxController.text),
        toklukKanMax: int.parse(toklukKanMaxController.text),
        kullanilanInsulin: kullanilanInsulinController.text,
        cinsiyet: _selectedGender ?? 'boş',
      );
      context.read<ProfilCubit>().profilGuncelle(yeniProfil);
      showFeedbackDialog(context, "Kayıt Yapıldı.");
    }
  }

  Future<File> uint8ListToFile(Uint8List data) async {
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/frame.png');
    return await file.writeAsBytes(data);
  }

  Future<File?> _resmiAl() async {
    _resimBytes = await ProfilDeposu().resimGetir(widget.profil!.kullaniciId!);
    if (_resimBytes != null) {
      return _imageFile = await uint8ListToFile(_resimBytes!);

    }
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar( title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text("Profil Oluştur",
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<File?>(
                  future: _resmiAl(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: _resimSecVeYukle,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurpleAccent,
                            image: DecorationImage(
                              image: FileImage(snapshot.data!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: _resimSecVeYukle,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage(
                                  'C:/Users/mebalci/Desktop/mobil_dersleri/blood_sugar/lib/assets/blood-1.png',),
                                fit: BoxFit.scaleDown
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Açlık Kan Şekeri:',
                      style: TextStyle(
                          color: const Color(0xff8201fe),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 22),
                    ),
                  ],
                ),
                InputField(
                  hint: aclikKanMinController.text.isNotEmpty
                      ? "${aclikKanMinController.text} mg/dl"
                      : "Olması Gereken Minimum Değer",
                  controller: aclikKanMinController,
                  keyboardType: TextInputType.number,
                ),
                InputField(
                  hint: aclikKanMaxController.text.isNotEmpty
                      ? "${aclikKanMaxController.text} mg/dl"
                      : "Olması Gereken Maksimum Değer",
                  controller: aclikKanMaxController,
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Text(
                      'Tokluk Kan Şekeri:',
                      style: TextStyle(
                          color: const Color(0xff8201fe),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 22),
                    ),
                  ],
                ),
                InputField(
                  hint: toklukKanMaxController.text.isNotEmpty
                      ? "${toklukKanMaxController.text} mg/dl"
                      : "Olması Gereken Maksimum Değer",
                  controller: toklukKanMaxController,
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Text(
                      'Kullanılan İnsülin:',
                      style: TextStyle(
                          color: const Color(0xff8201fe),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 22),
                    ),
                  ],
                ),
                InputField(
                  hint: kullanilanInsulinController.text.isNotEmpty
                      ? kullanilanInsulinController.text
                      : "Kullanılan İnsülin",
                  controller: kullanilanInsulinController,
                ),
                Row(
                  children: [
                    Text(
                      'Cinsiyet:',
                      style: TextStyle(
                          color: const Color(0xff8201fe),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 22),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Radio<String>(
                        value: 'Kadın',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      Text('Kadın'),
                      Radio<String>(
                        value: 'Erkek',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      Text('Erkek'),
                      Radio<String>(
                        value: 'Diğer',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      Text('Diğer'),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height / 15,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _validateAndSubmit();
                      });
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
                          fontSize: MediaQuery.of(context).size.width / 22),
                    ),
                  ),
                ),
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
  }
