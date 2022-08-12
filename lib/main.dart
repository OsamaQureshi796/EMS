import 'package:ems/services/notification_service.dart';
import 'package:ems/utils/app_constants.dart';
import 'package:ems/views/bottom_nav_bar/bottom_bar_view.dart';
import 'package:ems/views/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.toString());
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 
Stripe.publishableKey = publishableKey;
  await Firebase.initializeApp();
   LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
      title: 'Flutter Demo',
      home: FirebaseAuth.instance.currentUser == null? OnBoardingScreen() : BottomBarView(),
    );
  }
}

