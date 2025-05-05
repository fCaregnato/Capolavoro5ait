import 'package:flutter/material.dart';
import 'package:test1/pages/navPages/navHome/api_home.dart';
import 'package:test1/pages/navPages/navHome/lockCards.dart';
import 'package:test1/pages/navPages/navHome/nfc.dart';

class HomePageWidget extends StatefulWidget {
  final String username;
  final String password;

  const HomePageWidget({super.key, required this.username, required this.password});

  @override
  HomePageWidgetState createState() => HomePageWidgetState();
}

class HomePageWidgetState extends State<HomePageWidget> {
  List<dynamic> locks = [];
  bool isLoadingLocks = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchLocks();
  }

  // Funzione per caricare i dati di Locks
  Future<void> fetchLocks() async {
    setState(() {
      isLoadingLocks = true;
      errorMessage = null;
    });

    try {
      // Fetching the locks
      locks = await ApiService.fetchLocks(widget.username, widget.password);

      setState(() {
        isLoadingLocks = false;
      });
    } catch (e) {
      errorMessage = e.toString();
      setState(() {
        isLoadingLocks = false;
      });
    }
  }

  // Funzione per aggiornare la configurazione di un lock (puoi aggiungere la logica qui)
  Future<void> updateLockConfig(Map<String, dynamic> lock) async {
    debugPrint('Lock passed to updateLockConfig: $lock');

    setState(() {
      isLoadingLocks = true;
      errorMessage = null;
    });


    try {
      await ApiService.updateLockConfig(lock);

      await fetchLocks();
      
    } catch (e) {
      errorMessage = 'Errore: ${e.toString()}';
    } finally {
      setState(() {
        isLoadingLocks = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoadingLocks
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  Expanded(
                    child: errorMessage != null
                        ? Center(child: Text('Error: $errorMessage'))
                        : locks.isEmpty
                            ? const Center(child: Text('No locks found.'))
                            : ListView.builder(
                                itemCount: locks.length,
                                itemBuilder: (context, index) {
                                  var lock = locks[index];

                                  return LockCard(
                                    lock: lock,
                                    onTap: () => handleNfcCommand(context, "read"),
                                    onEdit: () {
                                      showEditDialog(
                                        context, lock, (lock) {
                                          updateLockConfig(lock,);
                                        },
                                        false,
                                      );
                                    },
                                    onDelete: () => debugPrint('Delete tapped: ${lock['esp_name']}'),
                                  );
                                },
                              ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () => debugPrint('Add new lock'),
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
