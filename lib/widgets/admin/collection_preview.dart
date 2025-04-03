import 'package:flutter/material.dart';

class RecollectionPreview extends StatelessWidget {
  const RecollectionPreview({super.key, required this.clientDirection});
  final String clientDirection;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey[400]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recolección a domicilio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.circle, color: Colors.green, size: 14),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Entregar en:',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4.0),
            Text(
              clientDirection,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}