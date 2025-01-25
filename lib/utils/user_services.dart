import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetching all fields for the user by their ID
  Future<Map<String, dynamic>> getUserSettings(String userId) async {
    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user settings: $e');
    }
  }

  // Function to extract user data from snapshot
  Map<String, dynamic> getUserDataFromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;

    return {
      'name': userData['Name'] ?? 'No Name',
      'email': userData['Email'] ?? 'No Email',
      'age': userData['Age'] ?? 0,
      'bedTime': userData['Bed Time'] ?? 'No Time',
      'gender': userData['Gender'] ?? 'Not Specified',
      'height': userData['Height']?.toDouble() ?? 0.0,
      'weight': userData['Weight']?.toDouble() ?? 0.0,
      'targetIntake': userData['targetIntake']?.toDouble() ?? 0.0,
      'currentIntake': userData['currentIntake']?.toDouble() ?? 0.0,
      'currentIntakePercentage': userData['currentIntakePercentage'] ?? 0,
      'lastResetTime': userData['lastResetTime'] ?? Timestamp.now(),
      'profileSetupComplete': userData['profileSetupComplete'] ?? false,
    };
  }
}
