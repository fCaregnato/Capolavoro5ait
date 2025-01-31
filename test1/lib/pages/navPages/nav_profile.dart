import 'package:flutter/material.dart';

class ProfilePageWidget extends StatelessWidget {
  final String username;

  const ProfilePageWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profilo di $username',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
