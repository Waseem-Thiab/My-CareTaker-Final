import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireproject/Main_pages/goals/tdee_model.dart';
import 'package:flutter/material.dart';

class GoalSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Your Goal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose Your Goal',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 71, 157, 255),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 71, 157, 255),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/tdee',
                  arguments: Goal.LoseWeight,
                );
              },
              child: Text(
                'Lose Weight',
                style: TextStyle(fontSize: 18.0, color: Colors.lightBlue[50]),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 71, 157, 255),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/tdee',
                  arguments: Goal.MaintainWeight,
                );
              },
              child: Text(
                'Maintain Weight',
                style: TextStyle(fontSize: 18.0, color: Colors.lightBlue[50]),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 71, 157, 255),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/tdee',
                  arguments: Goal.GainWeight,
                );
              },
              child: Text(
                'Gain Weight',
                style: TextStyle(fontSize: 18.0, color: Colors.lightBlue[50]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Goal {
  LoseWeight,
  MaintainWeight,
  GainWeight,
}

class TDEEFormPage extends StatefulWidget {
  @override
  _TDEEFormPageState createState() => _TDEEFormPageState();
}

class _TDEEFormPageState extends State<TDEEFormPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController ageController = TextEditingController();
  // TextEditingController goalController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController activityLevelController = TextEditingController();

  final Map<String, double> activityLevels = {
    'Sedentary': 1.2,
    'Lightly active': 1.375,
    'Moderately active': 1.55,
    'Very active': 1.725,
    'Super active': 1.9,
  };

  Goal? goal;
  String gender = '';
  double weight = 0;
  double height = 0;
  int age = 0;
  double activityLevel = 1.2; // Initial value set to Sedentary

  void calculateTDEE() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      formKey.currentState!.save();

      double bmr = 10 * weight + 6.25 * height - 5 * age + 5;
      double tdee = bmr * activityLevel;

      double adjustedTDEE = tdee;

      switch (goal) {
        case Goal.LoseWeight:
          adjustedTDEE *= 0.8; // Subtract 20% for losing weight
          break;
        case Goal.MaintainWeight:
          // Keep TDEE as is
          break;
        case Goal.GainWeight:
          adjustedTDEE *= 1.2; // Add 20% for gaining weight
          break;
        default:
          break;
      }

      adjustedTDEE = double.parse(adjustedTDEE.toStringAsFixed(3));
      if (user != null) {
        // Check if there's an existing goal
        var goalSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('goal')
            .get();

        if (goalSnapshot.docs.isNotEmpty) {
          // Update existing goal
          var goalDoc = goalSnapshot.docs.first;
          await goalDoc.reference.update({
            'goal': goal.toString().split('.').last,
            'gender': genderController.text,
            'height': height,
            'weight': weight,
            'age': age,
            'activity level': activityLevel,
            'tdee': adjustedTDEE
            // You may need to update other fields here
          });

          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: const Text('Your goal has been updated.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Color.fromARGB(255, 18, 142, 214),
                duration: const Duration(seconds:3 ), // Adjust duration as needed
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ), // Adjust duration as needed
            
          ));

         
        } else {
          Goals goals = Goals(
              goal: goal.toString().split('.').last,
              gender: genderController.text,
              height: height,
              weight: weight,
              age: age,
              activityLevel: activityLevel,
              tdee: adjustedTDEE);

          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('goal')
              .add(goals.toJson());
        }

         Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    goal = ModalRoute.of(context)?.settings.arguments as Goal?;

    return Scaffold(
      appBar: AppBar(
        title: Text('TDEE Calculator',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: gender.isNotEmpty ? gender : null,
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                    genderController.text = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  weight = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: heightController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
                onSaved: (value) {
                  height = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  age = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<double>(
                decoration: InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: activityLevel,
                items: activityLevels.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    activityLevel = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your activity level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: calculateTDEE,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 71, 157, 255),
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Calculate Adjusted TDEE',
                    style:
                        TextStyle(fontSize: 18.0, color: Colors.lightBlue[50]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
