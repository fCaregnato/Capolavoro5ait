import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username; // Passiamo il nome utente

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Size mediaSize;
  int _currentIndex = 0; // Indice corrente per la BottomNavigationBar

  // Lista delle schermate
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildHomePage(),
      _buildLocksPage(),
      _buildProfilePage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size; // Ottieni la dimensione dello schermo
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.orange,
            Colors.orangeAccent,
            Colors.purpleAccent,
            Colors.purple,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Locks&go'),
          leading: const Icon(Icons.lock),
          centerTitle: false,
          backgroundColor: Colors.white.withAlpha(80), // Rendi la barra dell'app trasparente
          elevation: 0,
        ),
        body: _pages[_currentIndex], // Mostra la schermata selezionata
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Cambia schermata
            });
          },
          backgroundColor: Colors.white.withAlpha(150),
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: 'Locks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Schermata Home
  Widget _buildHomePage() {
    return Center(
      child: Text(
        'Ciao ${widget.username}, questa è la tua homepage!',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Schermata Locks
  Widget _buildLocksPage() {
    return Center(
      child: Text(
        'Gestisci i tuoi Locks qui!',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Schermata Profile
  Widget _buildProfilePage() {
    return Center(
      child: Text(
        'Profilo di ${widget.username}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

