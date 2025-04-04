import 'package:acopiatech/widgets/user/user_text_field.dart';
import 'package:flutter/material.dart';

class UserAccountForm extends StatefulWidget {
  const UserAccountForm({super.key});
  

  @override
  State<UserAccountForm> createState() => _UserAccountFormState();
}

class _UserAccountFormState extends State<UserAccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final String _name;
  late final String _lastName;
  late final String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,),
        ),
      ),
      body: Form(
        child: Padding(padding: EdgeInsets.all(8.0),
        child: Column(
          spacing: 16.0,
          children: [
            UserTextField(
              fieldName: 'Nombres', filled: false
              ),
            UserTextField(
              fieldName: 'Apellidos', filled: false
              ),
              
          ],
        ),
        )
        ),
    );
  }
}