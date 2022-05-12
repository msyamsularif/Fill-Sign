import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/viewmodels/cubit/recent_file/recent_file_cubit.dart';
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
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo-sign.png',
          height: 300,
        ),
      ),
    );
  }
}
