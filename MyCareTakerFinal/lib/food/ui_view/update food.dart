import 'package:fireproject/food/models/meal_consume.dart';
import 'package:fireproject/food/services/food_services.dart';
import 'package:flutter/material.dart';

class UpdateFoodDialog extends StatefulWidget {
  final Food food;
  final String foodId;

  UpdateFoodDialog({required this.food, required this.foodId});

  @override
  _UpdateFoodDialogState createState() => _UpdateFoodDialogState();
}

class _UpdateFoodDialogState extends State<UpdateFoodDialog> {
  final TextEditingController _caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _caloriesController.text = widget.food.calories.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Food'),
      content: TextField(
        controller: _caloriesController,
        decoration: InputDecoration(labelText: 'Calories'),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final int updatedCalories = int.tryParse(_caloriesController.text) ?? widget.food.calories;
            final foodService = FoodService();
            await foodService.updateFood(widget.foodId, {'calories': updatedCalories});
          
            Navigator.of(context).pop();

             ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: const Text('Your meal has been updated successfully', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Color.fromARGB(255, 18, 142, 214),
                duration: const Duration(seconds:3 ), // Adjust duration as needed
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ), // Adjust duration as needed
            
          ));
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
