import 'package:flutter/material.dart';

class HomePageWidget extends StatelessWidget {
  final String username;

  const HomePageWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CustomCard(username: username),
          ]   
        ),
      ),
      backgroundColor: Colors.transparent, // Nessun colore di sfondo
    );
  }
}

class CustomCard extends StatelessWidget {
  final String username;

  const CustomCard({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Card(
        color: Colors.white.withAlpha(90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 130, // Altezza ridotta della card
          child: Stack(
            children: [
              ClipPath(
                clipper: VerticalDiagonalClipper(),
                child: Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 150,
                ),
              ),
              Center(
                child: Text(
                  'Welcome, $username!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerticalDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 10.0;
    var path = Path();
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0); // Angolo sinistro superiore arrotondato
    path.lineTo(size.width * 0.33, 0); // 1/3 della larghezza
    path.lineTo(size.width * 0.25, size.height); // Partizione obliqua
    path.lineTo(radius, size.height); // Angolo sinistro inferiore arrotondato
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePageWidget(username: 'Username'),
  ));
}
