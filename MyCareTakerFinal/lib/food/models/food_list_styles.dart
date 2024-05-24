import 'package:flutter/material.dart';

// Define text styles
final TextStyle titleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

final TextStyle subtitleStyle = TextStyle(
  fontSize: 16,
);

final TextStyle dayStyle = TextStyle(
  color: Colors.grey[600],
);

// Define card styles
final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(15.0),
);

const double cardElevation = 5.0;
const EdgeInsets cardMargin = EdgeInsets.all(10);
const EdgeInsets cardPadding = EdgeInsets.all(8.0);
const EdgeInsets listTileContentPadding = EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0);

// Define colors
final Color editIconColor = Colors.blueAccent;
final Color deleteIconColor = Colors.redAccent;
