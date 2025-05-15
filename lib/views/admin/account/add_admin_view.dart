import 'package:acopiatech/helpers/loading/loading_screen.dart';
import 'package:acopiatech/services/auth/admin_functions.dart';
import 'package:acopiatech/utilities/dialogs/error_dialog.dart';
import 'package:acopiatech/utilities/generics/validate_field.dart';
import 'package:flutter/material.dart';

class AddAdminView extends StatefulWidget {
  const AddAdminView({super.key});

  @override
  State<AddAdminView> createState() => _AddAdminViewState();
}

class _AddAdminViewState extends State<AddAdminView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añadir administrador')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Form(
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;

                if (validateField(email) == 'Requerido') {
                  showErrorDialog(
                    context,
                    'Por favor, registre el correo electrónico.',
                  );
                  return;
                }
                LoadingScreen().show(
                  context: context,
                  text: 'Asignando rol de administrador a $email',
                );

                try {
                  await assignAdminRole(email);
                } on Exception {
                  showErrorDialog(
                    context,
                    'Error al asignar el rol de administrador...',
                  );
                }

                LoadingScreen().hide();
              },
              child: Text('Asignar como administador'),
            ),
          ],
        ),
      ),
    );
  }
}
