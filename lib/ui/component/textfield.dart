import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const InputField({
    super.key,
    required this.hint,
    this.obscureText=false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: size.width *.9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Center(
        child: TextFormField(
          validator: validator,
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey, fontSize: MediaQuery.of(context).size.height/61),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 10),

          ),
        ),
      ),
    );
  }
}