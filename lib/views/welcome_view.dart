import 'package:acopiatech/views/login_view.dart';
import 'package:acopiatech/views/register_view.dart';
import 'package:acopiatech/widgets/custom_scaffold.dart';
import 'package:acopiatech/widgets/welcome_buttom.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bienvenido a AcopiaTech',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Tu cliclo de acopio en solo dos clics', //Checar eslogan
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButtom(
                      buttonText: 'Iniciar sesión',
                      onTapWidget: LoginView(),
                    ),
                  ),
                  Expanded(
                    child: WelcomeButtom(
                      buttonText: 'Registrarse',
                      onTapWidget: RegisterView(),
                      )
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
