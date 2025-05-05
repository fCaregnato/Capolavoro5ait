import 'package:flutter/material.dart';

class SettingsPageWidget extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageWidget> {
  bool _isNotificationsEnabled = true;
  double _volumeLevel = 0.5;
  bool _isDarkMode = false;
  String _selectedLanguage = 'Italiano';
  String _userAccountStatus = 'Non loggato';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Impostazioni'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Sezione per le notifiche
            ListTile(
              title: Text('Notifiche'),
              subtitle: Text('Abilita o disabilita le notifiche dell\'app'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isNotificationsEnabled = value;
                  });
                },
              ),
            ),
            Divider(),

            // Sezione per il volume
            ListTile(
              title: Text('Volume'),
              subtitle: Text('Regola il livello del volume'),
              trailing: Container(
                width: 150, // Imposta una larghezza fissa
                child: Slider(
                  value: _volumeLevel,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: (_volumeLevel * 100).toStringAsFixed(0) + '%',
                  onChanged: (double value) {
                    setState(() {
                      _volumeLevel = value;
                    });
                  },
                ),
              ),
            ),

            Divider(),

            // Sezione per il tema (Dark Mode)
            ListTile(
              title: Text('Modalità scura'),
              subtitle: Text('Attiva o disattiva la modalità scura'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
            ),
            Divider(),

            // Sezione per il cambio della lingua
            ListTile(
              title: Text('Lingua'),
              subtitle: Text('Seleziona la lingua dell\'app'),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: <String>['Italiano', 'English', 'Español']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Divider(),

            // Sezione per la gestione dell'account utente
            ListTile(
              title: Text('Account utente'),
              subtitle: Text(_userAccountStatus),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(_userAccountStatus == 'Non loggato'
                          ? 'Login'
                          : 'Logout'),
                      content: _userAccountStatus == 'Non loggato'
                          ? Text('Accedi con il tuo account per continuare.')
                          : Text('Vuoi uscire dal tuo account?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _userAccountStatus = _userAccountStatus == 'Non loggato'
                                  ? 'Loggato come: Nome Utente'
                                  : 'Non loggato';
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(_userAccountStatus == 'Non loggato' ? 'Accedi' : 'Logout'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annulla'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(),

            // Sezione per le informazioni sull'app
            ListTile(
              title: Text('Info sull\'app'),
              subtitle: Text('Versione e informazioni generali'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Info sull\'app'),
                      content: Text('Versione: 1.0.0\nSviluppato da [Nome]'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}