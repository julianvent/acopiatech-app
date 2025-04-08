import 'package:acopiatech/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Eliminar',
    content: '¿Estás seguro que quieres eliminar este registro?',
    optionsBuilder: () => {'Cancelar': false, 'Eliminar': true},
  ).then((value) => value ?? false);
}
