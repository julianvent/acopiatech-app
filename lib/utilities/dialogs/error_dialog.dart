import 'package:acopiatech/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: 'Un error ha ocurrido...',
    content: text,
    optionsBuilder: () => {'Cerrar': null},
  );
}
