import 'package:flutter/material.dart';

class LockCard extends StatelessWidget {
  final Map<String, dynamic> lock;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const LockCard({
    super.key,
    required this.lock,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
        child: Card(
          color: Colors.white.withAlpha(90),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: lock['favourites'] == 1
                ? BorderSide(color: Colors.amber, width: 7) // Golden border if favourite
                : BorderSide.none, // No border if not favourite
          ),
          child: Stack(
            children: [
              ClipPath(
                clipper: VerticalDiagonalClipper(),
                child: Container(
                  color: Color(int.parse("0xFF${lock['color']}")),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 7.3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.25,
                  top: 15,
                  bottom: 10,
                  right: MediaQuery.of(context).size.width * 0.15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lock['esp_name']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        lock['text'] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blueGrey[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 2,
                top: 1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey.shade700,
                          size: 24,
                        ),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 24,
                        ),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 7,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.lock,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width * 0.17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}

class VerticalDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20.0;
    var path = Path();
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.20, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class LockConfigEditDialog extends StatefulWidget {
  final Map<String, dynamic> lock;
  final Function(Map<String, dynamic>) onSave;
  final bool isNew;

  const LockConfigEditDialog({
    Key? key,
    required this.lock,
    required this.onSave,
    required this.isNew,
  }) : super(key: key);

  @override
  LockConfigEditDialogState createState() => LockConfigEditDialogState();
}

class LockConfigEditDialogState extends State<LockConfigEditDialog> {
  late TextEditingController textController;
  late TextEditingController name;
  bool favourite = false;
  String selectedColor = "";

  final Map<String, String> predefinedColors = {
    "Red": "D0312D",
    "Blue": "0492C2",
    "Green": "00ab41",
    "Yellow": "FFDF00",
    "Purple": "D05FAD",
  };

  late final Map<String, String> hexToColorMap;

  @override
  void initState() {
    super.initState();

    // Reverse the map to enable hex-to-name lookup
    hexToColorMap = {for (var entry in predefinedColors.entries) entry.value: entry.key};

    // Get color name from hex value
    String hexColor = widget.lock['color'] ?? "D0312D"; // Default to Red if null
    selectedColor = hexToColorMap[hexColor] ?? "Custom"; // Use hexToColorMap for lookup

    name = TextEditingController(text: widget.lock['esp_name'] ?? "");
    textController = TextEditingController(text: widget.lock['text'] ?? "");
    favourite = widget.lock['favourites'] == 1;
  }

  @override
  void dispose() {
    textController.dispose();
    name.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Convert color name to hex before saving
    String hexColor = predefinedColors[selectedColor] ?? selectedColor;


    Map<String, dynamic> updatedLock = {
      'name': name.text,
      'color': hexColor, // Save as hex
      'text': textController.text,
      'favourites': favourite ? 1 : 0,
      'user_id': widget.lock['user_id'],
      'lock_id': widget.lock['lock_id'],
    };

    widget.onSave(updatedLock);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isNew ? 'Create New Lock' : 'Edit Lock Configuration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          TextField(
            controller: name,
            decoration: InputDecoration(labelText: 'Description'),
          ),

          DropdownButtonFormField<String>(
            value: predefinedColors.containsKey(selectedColor) ? selectedColor : "Custom",
            items: predefinedColors.keys.map((color) {
              return DropdownMenuItem(
                value: color,
                child: Text(color),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedColor = value ?? "Red";
                widget.lock['color'] = predefinedColors[selectedColor] ?? selectedColor;
              });
            },
            decoration: InputDecoration(labelText: 'Color'),
          ),

          SizedBox(height: 12),
          TextField(
            controller: textController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 12),
          
          Row(
            children: [
              Text('Favourite'),
              Checkbox(
                value: favourite,
                onChanged: (value) {
                  setState(() {
                    favourite = value ?? false;
                  });
                },
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showEditDialog(BuildContext context, Map<String, dynamic> lock, Function(Map<String, dynamic>) onSave, isNew) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: LockConfigEditDialog(lock: lock, onSave: onSave, isNew: isNew,),
      );
    },
  );
}
