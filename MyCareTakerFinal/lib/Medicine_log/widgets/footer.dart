import 'package:flutter/material.dart';

// A StatefulWidget Footer that provides a custom footer bar with buttons.
class Footer extends StatefulWidget {
  // Callback function triggered when the floating action button is pressed.
  final VoidCallback onButtonPressed;

  // Constructor with required onButtonPressed callback.
  const Footer({super.key, required this.onButtonPressed});

  @override
  State<Footer> createState() => _FooterState();
}

// State class for Footer widget.
class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    // Container for the footer layout.
    return Container(
      margin: const EdgeInsets.only(bottom: 15,right: 15), // Bottom margin for spacing.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end
        , // Distributes children evenly along the row.
        children: [
          // Expanded widget to give equal space to the icon.
          ///////////////////////////////////////////////////////////// // Home icon.
          ///
         
          // FloatingActionButton in the middle of the footer.
          FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 109, 140, 187), // Button color.
            onPressed: () => widget
                .onButtonPressed(), // Calls the passed callback when pressed.
            elevation: 0, // Removes shadow for a flat design.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Rounded edges.
            ),
            mini: false, // Regular-sized floating action button.
            child: const Icon(Icons.add,
                color: Colors.white), // Add icon inside the button.
          ),
          // Expanded widget to give equal space to the icon.
           // History icon.
        ],
      ),
    );
  }
}
