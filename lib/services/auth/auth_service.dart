import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore =FirebaseFirestore.instance;

  User? getCurrentUser(){
    return _auth.currentUser;
  }

  Future<UserCredential> signInWithEmailPassword(String email,String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      _firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          'email': email
        }
      );
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  // Function to sign in the user anonymously
  Future<User?> signInAnonymously() async {
    User? user;
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      user= userCredential.user;
      print("Anonymous UID: $userCredential.user?.uid");// This is the temporary UID
    } catch (e) {
      print("Error signing in anonymously: $e");
    }
    return user;
  }

  Future<void> signout() async {
    try{
      return await _auth.signOut();
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

}