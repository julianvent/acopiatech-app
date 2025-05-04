import 'package:acopiatech/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<bool> showCancelCollectionDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Cancelar recolección',
    content: '¿Estás seguro que deseas cancelar esta recolección?',
    optionsBuilder: () => {'No': false, 'Cancelar recolección': true},
  ).then((value) => value ?? false);
}
