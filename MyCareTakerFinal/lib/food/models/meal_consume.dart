import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String? id; // id should be nullable
  String name;
  String meal;
  int calories=0;
  num servingSize=0;
  String servingUnit;
  DateTime day;

  Food({
    this.id, // id is now nullable and not required
    required this.name,
    required this.meal,
    required this.calories,
    required this.servingSize,
    required this.servingUnit,
    required this.day,
  });

  // Convert the Medicine object to a JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'meal': meal,
      'calories': calories,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'day': day,
    };
  }

  // Factory constructor to create a meal object from Firestore document data
  factory Food.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id,
      name: data['name'],
      meal: data['meal'],
      calories: data['calories'],
      servingSize: data['servingSize'],
      servingUnit: data['servingUnit'],
         // Handle it as a list of Timestamps
       day: (data['day'] as Timestamp).toDate(),
    );
  }

  
}
