import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  String? id; // id should be nullable
  String name;
  String dosage;
  String image;
  List<String> days;
  List<Timestamp> reminderTime;
  String amount;
  String? userId; // Add the userId parameter

  Medicine({
    this.id, // id is now nullable and not required
    required this.name,
    required this.dosage,
    required this.image,
    required this.days,
    required this.reminderTime,
    required this.amount,
    this.userId, // Initialize the userId parameter
  });

  // Convert the Medicine object to a JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId, // Include userId in the JSON data
      'name': name,
      'dosage': dosage,
      'image': image,
      'days': days,
      'reminder_time': reminderTime,
      'amount': amount,
    };
  }

  // Factory constructor to create a Medicine object from Firestore document data
  factory Medicine.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Medicine(
      id: doc.id,
      userId: data['userId'], // Get the userId from Firestore data
      name: data['name'],
      dosage: data['dosage'],
      image: data['image'],
      days: List<String>.from(data['days']),
      reminderTime: data['reminder_time'] is List
          ? (data['reminder_time'] as List)
              .map((item) => item as Timestamp)
              .toList()
          : [], // Handle it as a list of Timestamps
      amount: data['amount'],
    );
  }
}
