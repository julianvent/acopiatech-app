import 'package:flutter/material.dart';

class UserRecollectionForm extends StatefulWidget {
  const UserRecollectionForm({super.key});

  @override
  State<UserRecollectionForm> createState() => _UserRecollectionFormState();
}

enum Turno { matutino, vespertino }

class _UserRecollectionFormState extends State<UserRecollectionForm> {
  Turno turnoSeleccionado = Turno.matutino;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nueva recolección',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Turno de recolección'),
                  SegmentedButton<Turno>(
                    multiSelectionEnabled: false,
                    segments: const <ButtonSegment<Turno>>[
                      ButtonSegment<Turno>(
                        value: Turno.matutino,
                        label: Text('Matutino'),
                      ),
                      ButtonSegment<Turno>(
                        value: Turno.vespertino,
                        label: Text('Vespertino'),
                      ),
                    ],
                    selected: <Turno>{turnoSeleccionado},
                    onSelectionChanged: (Set<Turno> newTurno) {
                      setState(() {
                        turnoSeleccionado = newTurno.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                children: [
                  Text(
                    'Fecha y hora',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
