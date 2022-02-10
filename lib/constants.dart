import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


const kBottomContainerHeight = 80.0;
const kActiveCardColour = Color(0xFF1D1E33);
const kInactiveCardColour = Color(0xFF111328);
const kBottomContainerColour = Color(0xFFEB1555);

const kLabelTextStyle = TextStyle(
  fontSize: 18, color: Color(0xFF8D8E98),
);

const kNumberStlye = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  color: Color(0xFF24D976),
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  fontSize: 100,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(
  fontSize: 22,
);

//const String kIpAddress = kIsWeb? "https://49.50.10.15" : "https://49.50.10.15";
const String kIpAddress = kIsWeb? "http://127.0.0.1:8000" : "http://10.0.2.2:8000";