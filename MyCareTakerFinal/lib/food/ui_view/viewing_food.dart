import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireproject/food/ui_view/update%20food.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/food/models/meal_consume.dart';
import 'package:fireproject/food/services/food_services.dart';

class FoodListPage extends StatelessWidget {
  final FoodService foodService = FoodService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 217, 226, 233),
          Color.fromARGB(255, 209, 229, 241),
          Color.fromARGB(255, 191, 221, 241),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: StreamBuilder<List<Food>>(
          stream: foodService.fetchFood(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No food items available'));
            }

            final foodList = snapshot.data!;
            return ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final food = foodList[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipOval(
                        child: Image.asset(
                          _getImagePath(food.meal),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      food.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          '${food.meal} - ${food.calories} kcal',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          food.day.toString(),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_square,
                              color: Color.fromARGB(255, 233, 192, 11)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return UpdateFoodDialog(
                                    food: food, foodId: food.id!);
                              },
                            );
                          },
                        ),
                        Builder(builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              // Show confirmation dialog
                              bool confirmDelete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              false); // User doesn't confirm delete
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              true); // User confirms delete
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // If user confirms delete, proceed with delete operation
                              if (confirmDelete == true) {
                                await foodService.deleteFood(food.id!);
                               
                              }
                            },
                          );
                        })
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

String _getImagePath(String mealType) {
  switch (mealType) {
    case 'Breakfast':
      return 'assets/fitness_app/breakfast.png';
    case 'Lunch':
      return 'assets/fitness_app/lunch.png';
    case 'Snack':
      return 'assets/fitness_app/snack.png';
    case 'Dinner':
      return 'assets/fitness_app/dinner.png';
    default:
      return 'assets/fitness_app/placeholder.png'; // Provide a default image path if meal type is not recognized
  }
}
