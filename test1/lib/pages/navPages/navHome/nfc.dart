import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart'; // Pacchetto per la gestione dell'NFC

Future<void> handleNfcCommand(BuildContext context, String command, {String? message}) async {
  if (!await NfcManager.instance.isAvailable()) {
    if (!context.mounted) return;
    _showNfcDialog(context, 'NFC non disponibile');
    return;
  }

  switch (command) {
    case 'write':
      if (!context.mounted) return;
      _showNfcDialog(context, 'NFC abilitato. Avvicina il dispositivo per scrivere.');
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        try {
          Ndef? ndef = Ndef.from(tag);
          if (ndef == null || !ndef.isWritable) {
            if (!context.mounted) return;
            _showNfcDialog(context, 'Tag non scrivibile');
            return;
          }
          await ndef.write(NdefMessage([NdefRecord.createText(message ?? 'Messaggio di default')]));
          if (!context.mounted) return;
          _showNfcDialog(context, 'Messaggio scritto con successo!');
        } catch (e) {
          if (!context.mounted) return;
          _showNfcDialog(context, 'Errore nella scrittura: $e');
        } finally {
          NfcManager.instance.stopSession();
        }
      });
      break;
    
    case 'read':
      if (!context.mounted) return;
      _showNfcDialog(context, 'NFC abilitato. Avvicina il dispositivo per leggere.');
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        try {
          Ndef? ndef = Ndef.from(tag);
          if (ndef == null) {
            if (!context.mounted) return;
            _showNfcDialog(context, 'Nessun dato disponibile su questo tag');
            return;
          }
          NdefMessage message = await ndef.read();
          String payload = message.records.first.payload.sublist(3).toString();
          if (!context.mounted) return;
          _showNfcDialog(context, 'Messaggio ricevuto: $payload');
        } catch (e) {
          if (!context.mounted) return;
          _showNfcDialog(context, 'Errore nella lettura: $e');
        } finally {
          NfcManager.instance.stopSession();
        }
      });
      break;
    
    case 'add_lock':
      if (!context.mounted) return;
      _showNfcDialog(context, 'Aggiunta nuova lock card in corso...');
      // Logica per aggiungere una nuova lock card
      break;
    
    case 'open_lock':
      if (!context.mounted) return;
      _showNfcDialog(context, 'Apertura lucchetto in corso...');
      // Logica per aprire un lucchetto
      break;
    
    default:
      if (!context.mounted) return;
      _showNfcDialog(context, 'Comando non riconosciuto');
      break;
  }
}

void _showNfcDialog(BuildContext context, String message) {
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('NFC'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
