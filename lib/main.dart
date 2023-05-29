import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grocals/pages/add_message.dart';
import 'package:grocals/pages/guest.dart';
import 'package:grocals/pages/guest_produce_details.dart';
import 'package:grocals/pages/home.dart';
import 'package:grocals/pages/add_produce.dart';
import 'package:grocals/pages/add_interest.dart';
import 'package:grocals/pages/inbox.dart';
import 'package:grocals/pages/interest_details.dart';
import 'package:grocals/pages/login.dart';
import 'package:grocals/pages/my_interests.dart';
import 'package:grocals/pages/produce_details.dart';
import 'package:grocals/pages/account.dart';
import 'package:grocals/pages/registration.dart';
import 'package:grocals/pages/my_posts.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:grocals/pages/reset_password.dart';
import 'package:grocals/pages/update_profile.dart';
import 'package:grocals/person.dart';
import 'package:grocals/shared_preferences.dart';

Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FutureBuilder(
              future: _fbApp,
              builder: (context, snapshot) {
                if(snapshot.hasError) {
                  print('You have an error! ${snapshot.error.toString()}');
                  return Text('Something went wrong!');
                }
                else if(snapshot.hasData) {
                  return AnimatedSplashScreen(
                    splash: "assets/logo.png",
                    backgroundColor: Colors.green,
                    nextScreen: LoginScreen(),
                    splashTransition: SplashTransition.fadeTransition,
                  );
                }
                else {
                  return Center (child: CircularProgressIndicator(),);
                }
              }
            ),

            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegistrationScreen(),
              '/home': (context) => const Home(),
              '/addProduce': (context) => const AddProduce(),
              '/produceDetails': (context) => const ProduceDetails(),
              '/interestDetails': (context) => const InterestDetails(),
              '/addInterest': (context) => const AddInterest(),
              '/addMessage': (context) => const AddMessage(),
              '/account': (context) => const Account(),
              '/myPosts': (context) => const MyPosts(),
              '/myInterests': (context) => const MyInterests(),
              '/inbox': (context) => const Inbox(),
              '/updateProfile': (context) => const UpdateProfile(),
              '/resetPassword': (context) => const ResetPassword(),
              '/guest': (context) => const Guest(),
              '/guestProduceDetails': (context) => const GuestProduceDetails(),
            },
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)),
        );
      },
    );
  }
}
