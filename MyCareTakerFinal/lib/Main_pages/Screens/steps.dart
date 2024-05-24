import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class stepsTracker extends StatefulWidget {
  const stepsTracker({super.key});
  @override
  State<stepsTracker> createState() {
    return _stepsTrackerState();
  }
}

class _stepsTrackerState extends State<stepsTracker> {
 int _stepCount = 0;
  final TextEditingController stepsController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // Assuming Z-axis represents vertical movement (steps)
        if (event.z > 10.0) {
          _stepCount++;
        }
      });
    });
  }

  Future<void> _saveDailyGoal() async {
    try {
      final userStepsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('Steps');

      QuerySnapshot querySnapshot = await userStepsCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first document (assuming a single document)
        await userStepsCollection.doc(querySnapshot.docs.first.id).update({
          'dailyGoal': stepsController.text,
          'counter': _stepCount,
        });
      } else {
        // Add a new document
        await userStepsCollection.add({
          'dailyGoal': stepsController.text,
          'counter': _stepCount,
        });
      }

       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Steps goal updated successfully',
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
      print('Error saving daily goal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save daily goal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
          title: const Text(
            "Step Tracker",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
      ),
      body: Container(
        decoration: BoxDecoration( gradient: LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(255, 171, 225, 248),
                Color.fromARGB(255, 68, 191, 243),
                Color.fromARGB(255, 2, 124, 238)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Step Count:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_stepCount',
                    style: TextStyle(
                        fontSize: 36,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: stepsController,
              decoration: InputDecoration(
                labelText: 'Enter Daily Steps Goal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 60, 163)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[200],
                            fixedSize: Size(200, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
              onPressed: _saveDailyGoal,
              child: Text('Save Goal',style: TextStyle(fontSize: 25,color: Colors.blue[900]),),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .collection('Steps')
                    .snapshots(),
                builder: (context, snapshot) {
                 

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                      'No daily steps goal set',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    );
                  }

                  var doc = snapshot.data!.docs.first;
                  var stepsGoal = doc['dailyGoal'];

                  return Text(
                    'Daily Steps Goal: $stepsGoal',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _stepCount = 0; // Reset step count
          });
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
