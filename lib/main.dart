import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking/firebase_options.dart';
import 'package:parking/pages/chat_page.dart';
import 'package:parking/pages/home_page.dart';
import 'package:parking/pages/login_page.dart';
import 'package:parking/router_path.dart';
import 'package:parking/services/auth/auth_gate.dart';
import 'package:parking/themes/light_mode.dart';
import 'package:parking/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context)=> ThemeProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String receiverEmail= "receiverEmail";
    String receiverID ="receiverID";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        // Check for a route that includes a dynamic parameter

        if(uri.pathSegments.first == 'scan-qr'){
          if(uri.queryParameters.containsKey('uid'))
            receiverID = uri.queryParameters['uid']!;
          if(uri.queryParameters.containsKey('email'))
            receiverEmail = uri.queryParameters['email']!;
          return MaterialPageRoute(
            builder: (context) => ChatPage(receiverEmail:receiverEmail , receiverID: receiverID),
          );
          }
      },
    );
  }


}


