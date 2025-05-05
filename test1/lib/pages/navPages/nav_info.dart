import 'package:flutter/material.dart';

class InfoPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Benvenuto nella tua serratura intelligente!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Cos\'è la serratura intelligente?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Questa app ti consente di utilizzare un codice NFC per aprire le porte delle stanze in modo sicuro e conveniente.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Istruzioni per l\'uso:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Registrati nell\'app con i tuoi dati personali.\n'
                '2. Associa un dispositivo NFC per ottenere il codice di accesso.\n'
                '3. Avvicina il tuo dispositivo NFC alla serratura per sbloccare la porta.\n'
                '4. Per ogni stanza puoi avere un codice differente e personalizzabile.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Contatti e Supporto:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Per qualsiasi problema, contattaci all\'email supporto@serratureintelligenti.com.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}