import 'package:fireproject/Main_pages/Screens/ingredients.dart';
import 'package:flutter/material.dart';

class MealsPage extends StatefulWidget {
  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  List<String> meals = ['Spaghetti', 'Pizza', 'Salad']; // Example meal names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(meals[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your navigation logic here
          // For example:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIngredientsPage()),
          );
        },
        tooltip: 'Add Meal',
        child: Icon(Icons.add),
      ),
    );
  }
}

