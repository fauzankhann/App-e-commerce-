import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/home_page.dart';
import 'package:e_commerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // If snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        // Connection Initialized -- Firebase App is running
        if (snapshot.connectionState == ConnectionState.done) {

          // StreamBuilder can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              // If Stream snapshot has error, then we show error itself
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              // Connection state active - Do the user login check inside the
              // if statement
              if(streamSnapshot.connectionState == ConnectionState.active) {

                //Get the user
                Object? _user = streamSnapshot.data;

                //if the user is null, we are not logged in
                if(_user == null) {
                  // user not logged in, head to login page
                  return LoginPage();
                } else {
                  // if user is not logged in, head to home page
                  return HomePage();
                }
              }

              // Checking the auth state - Loading
              return Scaffold(
                body: Center(
                    child: Text(
                      "Checking Authentication...",
                      style: Constants.regularHeading,
                    )
                ),
              );
            },
          );
        }

        //Connecting to Firebase - Loading *Put a loading circle
        return Scaffold(
          body: Center(
              child: Text(
            "Initializing App...",
                style: Constants.regularHeading,
              )
          ),
        );
      },
    );
  }
}
