import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sohbet_uygulamasi/app/landing_page.dart';
import 'file:///D:/Source/Flatter%20Uygulamalar/sohbet_uygulamasi/lib/locator/locator.dart';
import 'package:sohbet_uygulamasi/viewmodel/user_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        title: "Sohbet Uygulaması",
        theme: ThemeData.dark(),
        home: LandingPage(),
        ),
    );
  }
}
  