import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_auth1/service/database.dart';
import 'package:user_auth1/service/shared_pref.dart';

class AuthService {
  // Instances
  final DatabaseMethods databaseMethods = DatabaseMethods();
  final SharedpreferenceHelper sharedPreferenceHelper =
      SharedpreferenceHelper();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Step 1: Start Google Sign-In process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Step 2: Check if the user successfully signed in
      if (gUser == null) {
        print('User cancelled the Google sign-in process.');
        return;
      }

      // Step 3: Obtain Google authentication details
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Step 4: Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Step 5: Sign in to Firebase with the credential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      User? user = userCredential.user;

      // Step 6: Check if user is valid
      if (user == null) {
        print('Firebase user is null after sign-in.');
        return;
      }

      // Step 7: Prepare user data map for Firestore
      Map<String, dynamic> userData = {
        "Name": user.displayName ?? "",
        "Email": user.email ?? "",
        "Image": user.photoURL ?? "",
        "uid": user.uid,
      };

      // Step 8: Save user details to Firestore
      await databaseMethods.addUserDetail(userData, user.uid);

      // Step 9: Save user details locally with SharedPreferences
      await sharedPreferenceHelper.saveUserId(user.uid);
      await sharedPreferenceHelper.saveUserName(user.displayName ?? "");
      await sharedPreferenceHelper.saveUserEmail(user.email ?? "");
      await sharedPreferenceHelper.saveUserImage(user.photoURL ?? "");

      // Step 10: Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Registered successfully'),
          ),
        );
      }
    } catch (error) {
      print("Error during Google Sign-In: $error");

      // Show error message if context is still valid
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error signing in with Google'),
          ),
        );
      }
    }
  }
}
