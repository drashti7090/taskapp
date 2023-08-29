import 'package:flutter/material.dart';
import 'package:task_app/splash_screen.dart';
import 'package:task_app/splash_screen_api.dart';


void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "taskapp",
        // home: SplashScreen(),
        home: SplashScreenApi(),
      )
  );
}
