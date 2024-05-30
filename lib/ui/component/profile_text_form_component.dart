import 'package:flutter/material.dart';

class ProfileTextFormComponent extends StatelessWidget {
  const ProfileTextFormComponent({
    Key? key,
    required this.profiletextformtxt,
  }) : super(key: key);

  final String profiletextformtxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: profiletextformtxt,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: MediaQuery.of(context).size.height/61,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10),
        ),
      ),
    );
  }
}
