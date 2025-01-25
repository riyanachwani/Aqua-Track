import 'package:flutter/material.dart';
import '../models/item.dart'; // Import the Item model

class ItemListView extends StatelessWidget {
  final List<Item> items; // Accepting a list of items

  const ItemListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: () {
              // Example: Perform some action or navigate
              print("${item.time}");
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.image,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              item.time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Text(
              "${item.ml} ml",
              textScaleFactor: 1.2,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
