import 'package:chat_app/CHAT_FIRE/chat_fire_data_screen.dart';
import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/helper_controllers.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/z_firestore_crud/todo_app/data_operations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(HelperController());
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignIn = false;
  HelperController hController = Get.find<HelperController>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: isSignIn == true ? const HomeScreen() : const LoginScreen(),
      //home: const MyDataOperations(),
      home: const DataScreen(),
    );
  }

  getLoginStatus() async {
    await hController.loadUserLoggedInStatus().then((val) {
      if (val) {
        setState(() {
          isSignIn = true;
        });
      } else {
        setState(() {
          isSignIn = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLoginStatus();
  }
}
