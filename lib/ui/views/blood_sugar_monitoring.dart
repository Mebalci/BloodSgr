import 'package:blood_sugar/data/entity/kullanici.dart';
import 'package:blood_sugar/ui/component/textfield.dart';
import 'package:blood_sugar/ui/cubit/kan_sekeri_cubit.dart';
import 'package:blood_sugar/ui/views/bottom_navigation_bar.dart';
import 'package:blood_sugar/ui/views/feedback_dialog.dart';
import 'package:blood_sugar/ui/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:blood_sugar/data/entity/kansekeri_olcumu.dart';
import 'package:intl/intl.dart';


class BloodSugarMonitoring extends StatefulWidget {
  final Kullanici? profil;
  const BloodSugarMonitoring({Key? key, this.profil}) : super(key: key);

  @override
  State<BloodSugarMonitoring> createState() => _BloodSugarMonitoringState();
}

class _BloodSugarMonitoringState extends State<BloodSugarMonitoring> {
  int _selectedIndex = 0;
  List<String> _listGenderText = ['AÇ', 'TOK'];
  List<IconData> _listIconTabToggle = [Icons.restaurant, Icons.done];
  int _tabTextIconIndexSelected = 0;

  TextEditingController bloodSugarController = TextEditingController();
  TextEditingController measurementDateController = TextEditingController();
  TextEditingController measurementTimeController = TextEditingController();
  TextEditingController insulinDoseController = TextEditingController();
  TextEditingController mealInfoController = TextEditingController();
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String? _olcunSaati;

  void showFeedbackDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FeedbackDialog(message: message);
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        measurementDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        measurementTimeController.text = picked.format(context);
      });
    }
  }

  void _validateAndSubmit() {
    List<String> errorMessages = [];

    if (bloodSugarController.text.isEmpty || double.tryParse(bloodSugarController.text) == null) {
      errorMessages.add('Geçersiz kan şekeri değeri');
    }

    if (measurementDateController.text.isEmpty || selectedDate == null) {
      errorMessages.add('Geçersiz tarih formatı');
    }

    if (measurementTimeController.text.isEmpty || selectedTime == null) {
      errorMessages.add('Geçersiz saat formatı');
    }

    if (insulinDoseController.text.isEmpty || double.tryParse(insulinDoseController.text) == null) {
      errorMessages.add('Geçersiz insülin dozu değeri');
    }


    String errorMessage = errorMessages.join("\n");

    if (errorMessages.isNotEmpty) {
      showFeedbackDialog(context, errorMessage);
    } else {
      final kanSekeriCubit = context.read<KanSekeriCubit>();
      final measurementDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      _olcunSaati='${selectedTime!.hour}:${selectedTime!.minute} / '
          '${selectedDate!.day} - ${selectedDate!.month} - ${selectedDate!.year}';
      final yeniOlcum = KanSekeriOlcumu(
        kullaniciId: widget.profil!.kullaniciId!,
        kanSekeri: double.parse(bloodSugarController.text),
        olcumSaati: _olcunSaati.toString(),
        insulinDozu: double.parse(insulinDoseController.text),
        yemekBilgisi: mealInfoController.text,
        acTokDurumu: _tabTextIconIndexSelected,
      );
      kanSekeriCubit.olcumEkle(yeniOlcum);
      showFeedbackDialog(context, "Kayıt Yapıldı");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            " ",
            style: TextStyle(
              color: Color(0xff8201fe),
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 20,
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    "Kan Şekeri Takibi",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0xff8201fe),
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlutterToggleTab(
                    width: MediaQuery.of(context).size.width / 13,
                    borderRadius: 15,
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    unSelectedTextStyle: const TextStyle(
                      color: Color(0xff8201fe),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    labels: _listGenderText,
                    icons: _listIconTabToggle,
                    selectedIndex: _tabTextIconIndexSelected,
                    selectedLabelIndex: (index) {
                      setState(() {
                        _tabTextIconIndexSelected = index;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 26),
            InputField(hint: "Kan Şekerinizi Giriniz", controller: bloodSugarController,keyboardType: TextInputType.number,),

            InkWell(
              onTap: () => _selectDate(context),
              child: IgnorePointer(
                child: InputField(
                  hint: "Ölçüm Tarihini Giriniz",
                  controller: measurementDateController,
                ),
              ),
            ),

            InkWell(
                onTap: () => _selectTime(context),
                child: IgnorePointer(
                  child: InputField(
                    hint: "Ölçüm Saatini Giriniz",
                    controller: measurementTimeController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),

            InputField(hint: "İnsülin Dozunu Giriniz", controller: insulinDoseController, keyboardType: TextInputType.number),

            InputField(hint: "Yemek Bilgisini Giriniz", controller: mealInfoController),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 3),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 15,
                child: ElevatedButton(
                  onPressed: () {
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
                      fontSize: MediaQuery.of(context).size.width / 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(selectedIndex: _selectedIndex, profil: widget.profil),
    );
  }

}
