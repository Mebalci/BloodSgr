import 'package:flutter/material.dart';

class BloodSugarTextFormComponent extends StatelessWidget {
  const BloodSugarTextFormComponent({
    Key? key,
    required this.bloodsugartextformtxt,
  }) : super(key: key);


 final String bloodsugartextformtxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: bloodsugartextformtxt,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize:  MediaQuery.of(context).size.height/61,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10),
        ),
      ),
    );
  }
}
