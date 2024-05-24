import 'package:flutter/material.dart';

class AddIngredientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ingredients'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Enter Ingredients'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Description'),
              maxLines: null, // Allow multiple lines for description
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your logic to save ingredients and description
                Navigator.pop(context); // Go back to the previous page
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
