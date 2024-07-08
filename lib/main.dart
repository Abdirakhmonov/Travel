import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson_72/firebase_options.dart';
import 'package:lesson_72/services/location_permission.dart';
import 'package:lesson_72/views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // PermissionStatus cameraPermission = await Permission.camera.status;
  // PermissionStatus locationPermission = await Permission.location.status;

  //// Permission_Handler packegi orqali qilindi
  // print(cameraPermission);
  // if (cameraPermission != PermissionStatus.granted) {
  //   await Permission.camera.request();
  // }
  // if (locationPermission != PermissionStatus.granted) {
  //   locationPermission = await Permission.location.request();
  // }

  // if (!(await Permission.camera.request().isGranted) ||
  //     !(await Permission.location.request().isGranted)) {
  //   Map<Permission, PermissionStatus> statuses =
  //       await [Permission.camera, Permission.location].request();
  //   print(statuses);
  // }
  await LocationPermission.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
