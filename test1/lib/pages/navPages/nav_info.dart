import 'package:flutter/material.dart';

class InfoPageWidget extends StatelessWidget {

  const InfoPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Informazioni per utilizzo',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
