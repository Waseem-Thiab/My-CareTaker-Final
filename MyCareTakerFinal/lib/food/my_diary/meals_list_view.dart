// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/Main_pages/Screens/mealspage.dart';
import 'package:fireproject/food/fitness_app_theme.dart';
import 'package:fireproject/food/models/meals_list_data.dart';
import 'package:fireproject/food/ui_view/viewing_food.dart';
import 'package:fireproject/main.dart';
import 'package:flutter/material.dart';

class MealsListView extends StatefulWidget {
  const MealsListView({
    super.key,
  });

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView> {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  List<MealsListData> mealsListData = MealsListData.tabIconsList;
  DateTime selectedDay = DateTime.now();
  @override
  void initState() {
    // getDocId();
    // animationController?.forward();
    super.initState();
  }

  Future<Map<String, int>> fetchMealCalories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .collection("food")
        .get();

    Map<String, int> mealCalories = {
      'Breakfast': 0,
      'Lunch': 0,
      'Snack': 0,
      'Dinner': 0,
    };

    querySnapshot.docs.forEach((DocumentSnapshot doc) {
      String mealType = doc['meal'];
      int calories = doc['calories'];
      mealCalories[mealType] = (mealCalories[mealType]! + calories);
    });

    return mealCalories;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 410,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: 410,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser!.uid)
                .collection("food")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty ||
                  snapshot.data == null) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    right: 16,
                    left: 16,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MealsView(
                      indexx: index,
                      calories: 0, // Show zero calories when no data available
                      mealsListData: mealsListData[index],
                    );
                  },
                );
              }
              Map<String, int> mealCalories = {
                'Breakfast': 0,
                'Lunch': 0,
                'Snack': 0,
                'Dinner': 0,
              };

              snapshot.data?.docs.forEach((DocumentSnapshot doc) {
                String mealType = doc['meal'];
                int calories = doc['calories'];

                mealCalories[mealType] =
                    (mealCalories[mealType] ?? 0) + calories;
              });

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  right: 16,
                  left: 16,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  String mealType = mealCalories.keys.elementAt(index);
                  int? totalCalories = mealCalories[mealType];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FoodListPage()),
                      );
                    },
                    child: MealsView(
                      indexx: index,
                      calories: totalCalories,
                      mealsListData: mealsListData[index],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class MealsView extends StatelessWidget {
  MealsView({
    super.key,
    required this.calories,
    required this.indexx,
    this.mealsListData,
  });
  int indexx;
  int? calories;
  final MealsListData? mealsListData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: HexColor(mealsListData!.endColor).withOpacity(0.6),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
                gradient: LinearGradient(
                  colors: <HexColor>[
                    HexColor(mealsListData!.startColor),
                    HexColor(mealsListData!.endColor),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(54.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 54, left: 16, right: 16, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mealsListData!.titleTxt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: FitnessAppTheme.white,
                      ),
                    ),
                    const SizedBox(
                      height: 2.7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // getFoodData(documentId: [indexx]),
                        Text(
                          '${calories ?? 0}',
                          style: const TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            letterSpacing: 0.2,
                            color: FitnessAppTheme.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 4,
                          ),
                          child: Text(
                            'kcal',
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              letterSpacing: 0.2,
                              color: FitnessAppTheme.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 8,
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(mealsListData!.imagePath),
            ),
          )
        ],
      ),
    );
  }
}
