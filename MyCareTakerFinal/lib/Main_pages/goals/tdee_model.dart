
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireproject/Main_pages/goals/tdee.dart';

class Goals {

  String goal;
  String gender ='';
  double height=0;
  double weight=0;
  int age =0;
  double activityLevel = 1.2;
  double tdee = 0;

  Goals({
    required this.goal,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.activityLevel,
    required this.tdee
  });

  // Convert them  to a JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'gender': gender,
      'height': height,
      'weight': weight,
      'age': age,
      'activity level': activityLevel,
      'tdee': tdee
    };
  }
  factory Goals.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Goals(
    goal: data["goal"] ?? '',
      gender: data["gender"] ?? '',
      height: (data['height'] ?? 0),
      weight: (data['weight'] ?? 0),
      age: (data["age"] ?? 0),
      activityLevel: (data["activity level"] ?? 1.2),
      tdee: (data["tdee"] ?? 0)
    );
  }

 
}
