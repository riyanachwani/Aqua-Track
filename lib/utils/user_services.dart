import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetching user ID
  Future<String> getUserId() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return user.uid; // Return the user's ID
      } else {
        throw Exception('No user is logged in');
      }
    } catch (e) {
      throw Exception('Failed to get user ID: $e');
    }
  }

  // Fetching all fields for the user by their ID
  Future<DocumentSnapshot> getUserSettings(String userId) async {
    try {
      // Fetch the user document from Firestore using the user ID
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot; // Return the DocumentSnapshot
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
      'Name': userData['Name'] ?? 'No Name',
      'Email': userData['Email'] ?? 'No Email',
      'Age': userData['Age'] ?? 0,
      'Bed Time': userData['Bed Time'] ?? 'No Time',
      'Gender': userData['Gender'] ?? 'Not Specified',
      'Height': userData['Height']?.toDouble() ?? 0.0,
      'Weight': userData['Weight']?.toDouble() ?? 0.0,
      'targetIntake': userData['targetIntake']?.toDouble() ?? 0.0,
      'currentIntake': userData['currentIntake']?.toDouble() ?? 0.0,
      'currentIntakePercentage': userData['currentIntakePercentage'] ?? 0,
      'lastResetTime': userData['lastResetTime'] ?? Timestamp.now(),
      'profileSetupComplete': userData['profileSetupComplete'] ?? false,
    };
  }
}
