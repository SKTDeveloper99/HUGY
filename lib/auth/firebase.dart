import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //instance of firebase authentication

  Future<bool> createNewUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> getCoins() async {
    final user = _auth.currentUser;

    int? coins = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      return value.data()?['coins'];
    });

    if (coins == null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'coins': 0});
    }

    return coins ?? 0;
  }

  Future<bool> addCoins(int coins) async {
    final user = _auth.currentUser; // get user

    FirebaseFirestore.instance //get a firebase instance
        .collection('users') // look through the users collection
        .doc(user!.uid) // look through the users document
        .update({
      'coins': FieldValue.increment(coins)
    }); // update the coins with new coins

    return true;
  }
}
