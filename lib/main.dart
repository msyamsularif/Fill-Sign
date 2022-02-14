import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'presentation/screens/app_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const AppScreen());
}
