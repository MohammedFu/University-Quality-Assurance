import 'package:flutter/material.dart';
import 'color_notifier_page.dart';

class ColorChangePage extends StatelessWidget {
  final ColorNotifier colorNotifier;

  const ColorChangePage({Key? key, required this.colorNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Theme Color'),
      ),
      body: Card(
        color: Colors.blueGrey,
        margin: EdgeInsets.all(25),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(
            onPressed: () {
              colorNotifier
                  .updateColor(Colors.black12); // Change to desired color
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(''),
          ),
          ElevatedButton(
            onPressed: () {
              colorNotifier
                  .updateColor(Colors.white); // Change to desired color
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(''),
          ),
        ]),
      ),
    );
  }
}
