import 'dart:async';

import 'package:fill_and_sign/core/viewmodels/cubit/recent_file/recent_file_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../app_theme.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider<RecentFileCubit>(
              create: (context) => RecentFileCubit()..loadDocumentPath(),
              child: const HomeScreen(),
            ),
          ),
          (route) => false),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secoundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              MdiIcons.fileSign,
              color: Colors.white,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "Mitra Fill & Sign",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: 'Austein',
                letterSpacing: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
