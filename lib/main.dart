import 'package:firebase_core/firebase_core.dart';
import 'package:flatter_app_android/domain/user.dart';
import 'package:flatter_app_android/pages/landing.dart';
import 'package:flatter_app_android/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyANcT9R4e-A0HFOUR2YMmomK-An8y_s3rQ',
          appId: '1:454418983603:android:408bed17f584d3e5965ec6',
          messagingSenderId: '454418983603',
          projectId: 'mobile-sensors-8d2ec',
          // storageBucket: 'myapp-b9yt18.appspot.com',
        )
    );
  } catch(e) {
    print('Ошибка инициализации Firebase: $e');
  }

  runApp(const CurrentListApp());
}

class CurrentListApp extends StatelessWidget {
  const CurrentListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
        value: AuthService().currentUser,
        initialData: null,
        child: MaterialApp(
      title: 'Page1|Home',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        primarySwatch: Colors.yellow,
        dividerColor: Colors.white24,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 230, 230, 230),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,

          ),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          bodyMedium: const TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          labelSmall: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),

      home: const LandingPage(),
    ));
  }
}
