class Item {
  final String time;
  final String image;
  final double ml;

  Item({
    required this.time,
    required this.image,
    required this.ml,
  });

// Method to create an Item from Firestore document
  factory Item.fromMap(Map<String, dynamic> data) {
    return Item(
      time: data['time'] ?? '',
      image: data['image'] ?? '',
      ml: data['ml']?.toDouble() ?? 0.0,
    );
  }

  // Convert Item to Map (to save in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'image': image,
      'ml': ml,
    };
  }

}

