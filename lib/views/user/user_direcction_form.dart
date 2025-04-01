import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/widgets/user_text_field.dart';
import 'package:flutter/material.dart';

class UserDirecctionForm extends StatefulWidget {
  const UserDirecctionForm({super.key});

  @override
  State<UserDirecctionForm> createState() => _UserDirecctionFormState();
}

class _UserDirecctionFormState extends State<UserDirecctionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar nueva dirección',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                UserTextField(
                  validator: null,
                  fieldName: 'Nombres',
                  controller: _nameController,
                  myIcon: Icons.person_2_outlined,
                  filled: false,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  validator: null,
                  fieldName: 'Apellidos',
                  controller: _nameController,
                  myIcon: Icons.person_2_outlined,
                  filled: false,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  validator: null,
                  fieldName: 'Calle',
                  controller: _nameController,
                  myIcon: Icons.location_on_outlined,
                  filled: false,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: UserTextField(
                        validator: null,
                        fieldName: 'No. ext',
                        controller: _nameController,
                        myIcon: Icons.numbers_rounded,
                        filled: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: UserTextField(
                        validator: null,
                        fieldName: 'No. int(opcional)',
                        controller: _nameController,
                        myIcon: Icons.numbers_rounded,
                        filled: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                UserTextField(
                  validator: null,
                  fieldName: 'Colonia',
                  controller: _nameController,
                  myIcon: Icons.location_on_outlined,
                  filled: false,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  validator: null,
                  fieldName: 'Código postal',
                  controller: _nameController,
                  myIcon: Icons.local_post_office_outlined,
                  filled: false,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  validator: null,
                  fieldName: 'Referencias (opcional)',
                  controller: _nameController,
                  myIcon: Icons.home_work_outlined,
                  filled: false,
                  numberOfLines: 3,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  validator: null,
                  fieldName: 'Ciudad',
                  controller: _nameController,
                  myIcon: Icons.location_city,
                  filled: false,
                ),
                const SizedBox(height: 10),
                UserTextField(
                  validator: null,
                  fieldName: 'Estado',
                  controller: _nameController,
                  myIcon: Icons.location_city,
                  filled: false,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsPalette.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    fixedSize: Size(200, 50),
                  ),
                  child: const Text(
                    'Guardar dirección',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
