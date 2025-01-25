import 'package:flutter/material.dart';
import '../models/item.dart'; // Import the Item model

class ItemListView extends StatelessWidget {
  final List<Item> items; // Accepting a list of items

  const ItemListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              onTap: () {
                print("${item.time}");
              },
              leading: Image.asset(item.image),
              title: Text(item.time),
              trailing: Text("${item.ml} ml",
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          );
        },
      ),
    );
  }
}
