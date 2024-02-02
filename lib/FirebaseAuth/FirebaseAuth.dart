import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //add user details
  Future addUserDetails(String name, String email, String photoUrl) async {
    await _firestore.collection('users').add({
      'name': name,
      'email': email,
      'photourl': photoUrl,
    });
  }

  // Log Out
  Future<User?> logOut() async {
    User? user = await _auth.currentUser;
    _auth.signOut();
    return user;
  }

  //Sing In
  Future<User?> signInWithEmailAndPass(String email, String pass) async {
    UserCredential? credential;
    try {
      credential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } catch (e) {
      print("Some error While Sign In !");
    }
    return credential?.user;
  }

  //Sign up
  Future<User?> signUpWithEmailAndPass(String email, String pass) async {
    UserCredential? credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
    } catch (e) {
      print("Creating an account have some problem !!");
    }
    return credential?.user;
  }

/*  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? gacc = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? gAuth = await gacc?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth?.accessToken,
      idToken: gAuth?.idToken
    );
    await _auth.signInWithCredential(credential);
    return _auth.currentUser;
  }*/
}
