import 'package:fireproject/food/fitness_app_home_screen.dart';
import 'package:fireproject/food/models/meal_consume.dart';
import 'package:fireproject/food/models/meals_list_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/food/my_diary/my_diary_screen.dart';
import 'package:fireproject/food/services/food_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class customFood extends StatefulWidget {
  const customFood({super.key});

  @override
  State<customFood> createState() => _customFoodState();
}

class _customFoodState extends State<customFood> {
  Food? foodtoadd;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;
  final TextEditingController mealController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController foodNameController = TextEditingController();

  final TextEditingController servingSizeController = TextEditingController();
  final TextEditingController servingUnitController = TextEditingController();

  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  DateTime currentDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();
    mealController.dispose();
    caloriesController.dispose();
    foodNameController.dispose();
    servingSizeController.dispose();
    servingUnitController.dispose();
  }

  String getCurrentDateAndDay() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}";
    String formattedDay = DateFormat('EEE').format(now); // Gives full day name
    return '$formattedDay $formattedDate';
  }

  String servingUnit = '---';
  var units = [
    '---',
    'g',
    'ml',
    'cup',
    'pc(s)',
    'spoon',
  ];

  String mealType = '---';

  var meals = [
    '---',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.only(right: 0),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 25,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text("Add Custom Food",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              if (foodNameController.text.isEmpty ||
                  caloriesController.text.isEmpty ||
                  mealController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please fill all required fields.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              int calories = int.tryParse(caloriesController.text) ?? 0;
              int servingSize = int.tryParse(servingSizeController.text) ?? 0;

              Food food = Food(
                name: foodNameController.text,
                meal: mealController.text,
                calories: calories,
                servingSize: servingSize,
                servingUnit: servingUnit,
                day: currentDate,
              );

              FoodService foodService = FoodService();

              try {
                if (foodtoadd == null) {
                  foodService.addFood(food);
                  if (kDebugMode) {
                    print('Food created successfully');
                  }
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Your meal has been added successfully',
                      style: TextStyle(
                          color: Color.fromARGB(255, 45, 135, 253),
                          fontWeight: FontWeight.bold)),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  duration:
                      const Duration(seconds: 3), // Adjust duration as needed
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ), // Adjust duration as needed
                ));
                
              } catch (e) {
                print('Error processing Food: $e');
              }
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.check_rounded,
                size: 25,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: foodNameController,
              decoration: InputDecoration(
                labelText: "Enter Food Name",
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Calories",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Spacer(),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: caloriesController,
                    decoration: InputDecoration(
                      hintText: "Ex. 250",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Text(
                  "Select Meal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Spacer(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        onChanged: (String? newValue) {
                          setState(() {
                            mealType = newValue!;
                            mealController.text = newValue;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        items: meals.map((String meal) {
                          return DropdownMenuItem(
                            value: meal,
                            child: Text(meal),
                          );
                        }).toList(),
                        value: mealType,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
