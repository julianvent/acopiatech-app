import 'package:acopiatech/views/login_view.dart';
import 'package:flutter/material.dart';

class WelcomeButtom extends StatelessWidget {
  const WelcomeButtom({super.key, this.buttonText});

  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (e) => const LoginView()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
        ),
        child: Text(
          buttonText!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
