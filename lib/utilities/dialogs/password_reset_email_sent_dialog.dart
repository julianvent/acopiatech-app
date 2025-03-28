import 'package:acopiatech/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Restablecer contraseña',
    content:
        'Hemos enviado un link para restablecer tu contraseña a tu correo electrónico. Por favor revisa tu bandeja de entrada',
    optionsBuilder: () => {'Cerrar': null},
  );
}
