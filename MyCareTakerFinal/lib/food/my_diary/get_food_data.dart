import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/food/fitness_app_theme.dart';
import 'package:flutter/material.dart';

class getFoodData extends StatelessWidget {
  getFoodData({super.key, required this.documentId});

  final firebaseUser = FirebaseAuth.instance.currentUser;

  final String documentId;
  @override
  Widget build(BuildContext context) {
    CollectionReference food = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .collection('food');
    return FutureBuilder<DocumentSnapshot>(
      future: food.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['calories']}');
        }
        return const CircularProgressIndicator(
          semanticsLabel: "Loading",
        );
      },
    );
  }
}







//   Future getDocId() async {
//     String currentDate = getCurrentDateAndDay();
//     // String mealTitle = mealsListData[i].titleTxt;
//     int totalMealCalories = 0;
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(firebaseUser!.uid)
//         .collection('food')
//         .where({'meal', 'day'}, isEqualTo: {mealTitle, currentDate})
//         .get()
//         .then((snapshot) {
//           snapshot.docs.forEach((doc) {
//             totalMealCalories +=
//                 doc['calories'] as int; // Sum calories for the meal
//           });
//         });
//   }