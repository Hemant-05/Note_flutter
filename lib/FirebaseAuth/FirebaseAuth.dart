import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note/Resources/UserModel.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user = _auth.currentUser;

  //add user details
  Future addUserDetails(String name, String email, String photoUrl) async {
    final uid = _auth.currentUser?.uid;
    if(user != null) {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'uid': uid,
      });
    }
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
