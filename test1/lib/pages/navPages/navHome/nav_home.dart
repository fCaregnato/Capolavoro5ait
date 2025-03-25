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
  List<dynamic> lockConfigs = [];
  bool isLoadingLocks = true;
  bool isLoadingConfig = true;
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

      // Now call fetchLockConfigs independently after locks are fetched
      fetchLockConfigs();

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

  // Funzione per caricare i dati di Config (la configurazione dei locks)
  Future<void> fetchLockConfigs() async {
    setState(() {
      isLoadingConfig = true;
      errorMessage = null;
    });

    try {
      List<dynamic> fetchedConfigs = [];
      for (var lock in locks) {
        // Fetch lock configurations for each lock
        var lockConfig = await ApiService.fetchLockConfigs(
          lock['user_id'], 
          lock['id_esp'],
          "0FFFFF", // Default color or any value
          "",
          false,
          ""
        );
        fetchedConfigs.add(lockConfig);  // Add each config to the list
      }

      setState(() {
        lockConfigs = fetchedConfigs; // Set lockConfigs after fetching
        isLoadingConfig = false;
      });
    } catch (e) {
      errorMessage = e.toString();
      setState(() {
        isLoadingConfig = false;
      });
    }
  }

  // Funzione per aggiornare la configurazione di un lock
  Future<void> updateLockConfig(String userId, String espId, String color, String espName ,bool favourite, String text) async {
    setState(() {
      isLoadingLocks = true;
      errorMessage = null;
    });

    try {
      // Directly call the API, since it's already handling the response
      final response = await ApiService.fetchLockConfigs(userId, espId, color, espName, favourite, text);
      
      if (response.isNotEmpty) {
        // If valid response, refresh lock configs
        debugPrint('Configurazione aggiornata con successo');
        await fetchLockConfigs();
      } else {
        errorMessage = 'No valid configurations received.';
      }
    } catch (e) {
      // Handle any error from the API call
      errorMessage = 'Error: ${e.toString()}';
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
      body: isLoadingLocks || isLoadingConfig
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

                                  // Find the corresponding config using esp_id
                                  var lockConfig = lockConfigs.isNotEmpty
                                      ? lockConfigs.firstWhere(
                                          (config) => (config as Map<String, dynamic>)['id_esp'] == lock['id_esp'],
                                          orElse: () => {} // Return an empty map if no match is found
                                        )
                                      : {};  // If no config found, use an empty map

                                  return LockCard(
                                    lock: lock,
                                    config: lockConfig,  // Pass the corresponding lock config
                                    onTap: () => handleNfcCommand(context, "read"),
                                    onEdit: () {
                                      // Aggiungi logica per editare i dati
                                      showEditDialog(
                                        context, lock, (updatedLock) {
                                          updateLockConfig(
                                            updatedLock['user_id'],
                                            updatedLock['esp_id'],
                                            updatedLock['color'],
                                            updatedLock['esp_name'],
                                            updatedLock['favourite'],
                                            updatedLock['text'],
                                          );
                                        }
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
