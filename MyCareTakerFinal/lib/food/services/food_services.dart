import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/food/models/meal_consume.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodService {
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  final String currentDay = DateFormat('EEEE, d MMMM').format(DateTime.now());

  final CollectionReference foodCollection = FirebaseFirestore.instance.collection('users');

  Stream<List<Food>> fetchFood() {
    if (firebaseUser == null) {
      return Stream.error('User not logged in');
    }

    return foodCollection
        .doc(firebaseUser!.uid)
        .collection('food')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Food.fromFirestore(doc)).toList());
  }

  Future<void> addFood(Food food) async {
    if (firebaseUser == null) {
      return Future.error('User not logged in');
    }

    try {
      String foodName = food.name;
      int calories = food.calories;
      String mealType = food.meal;

      QuerySnapshot querySnapshot = await foodCollection
          .doc(firebaseUser!.uid)
          .collection('food')
          .where('meal', isEqualTo: mealType)
          .where("day", isEqualTo: currentDay)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        int existingCalories = doc['calories'] ?? 0;
        int newTotalCalories = existingCalories + calories;

        await doc.reference.update({'calories': newTotalCalories});


      } else {
        await foodCollection
            .doc(firebaseUser!.uid)
            .collection('food')
            .add({
         'name': food.name,
        'meal': food.meal,
        'calories': food.calories,
        'servingSize': food.servingSize,
        'servingUnit': food.servingUnit,
        'day': Timestamp.fromDate(food.day),
        });
      }

 
    } catch (e) {
      if (kDebugMode) {
        print('Error adding food: $e');
      }
    }
  }

  Future<void> deleteFood(String id) async {
    if (firebaseUser == null) {
      return Future.error('User not logged in');
    }

    try {
      await foodCollection
          .doc(firebaseUser!.uid)
          .collection('food')
          .doc(id)
          .delete();

          
      if (kDebugMode) {

        
        print('Food deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting food: $e');
      }
    }
  }

  Future<void> updateFood(String id, Map<String, dynamic> data) async {
    if (firebaseUser == null) {
      return Future.error('User not logged in');
    }

    try {
      await foodCollection
          .doc(firebaseUser!.uid)
          .collection('food')
          .doc(id)
          .update(data);
      if (kDebugMode) {
        print('Food updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating food: $e');
      }
    }
  }
}
