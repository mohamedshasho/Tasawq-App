import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/helper/notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class PostAuthData {
  Future<User> singIN({required String email, required String password});
  Future<User> singUp(
      {required String typePerson,
      required String email,
      required String password,
      required String username,
      String? category});
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
}

class PostAuth extends PostAuthData {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Future<User> singIN({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final user = auth.currentUser;
      if (user != null) {
        await setPreference(EMAIL, user.email);
        DatabaseReference db =
            FirebaseDatabase.instance.reference().child(PERSON).child(user.uid);

        DataSnapshot? dataSnapshot = await db.once();
        await setPreference(TYPE_PERSON, dataSnapshot.value[TYPE_PERSON]);
        await setPreference(USERNAME, dataSnapshot.value[USERNAME]);
        return user;
      }
      throw 'Error';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      }
    }
    throw 'Error';
  }

  @override
  Future<User> singUp(
      {required String typePerson,
      required String email,
      required String password,
      required String username,
      String? category}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      final user = auth.currentUser;
      String? token = await NotificationsService().getToken();
      if (user != null) {
        if (typePerson == DELIVERY) {
          DatabaseReference db = FirebaseDatabase.instance
              .reference()
              .child(PERSON)
              .child(user.uid);
          await db.set({
            CATEGORY: category,
            USERNAME: username,
            TYPE_PERSON: typePerson,
            TOKEN: token != null ? token : ''
          });
          await setPreference(TYPE_PERSON, typePerson);
          await setPreference(EMAIL, user.email);
          await setPreference(USERNAME, username);
          return user;
        } else {
          DatabaseReference db = FirebaseDatabase.instance
              .reference()
              .child(PERSON)
              .child(user.uid);
          await db.set({
            USERNAME: username,
            TYPE_PERSON: typePerson,
            TOKEN: token != null ? token : ''
          });
          await setPreference(TYPE_PERSON, typePerson);
          await setPreference(EMAIL, user.email);
          await setPreference(USERNAME, username);
          return user;
        }
      }
      throw 'not found user';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
    } catch (e) {
      throw e.toString();
    }
    throw 'Error';
  }

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      final user = auth.currentUser;
      if (user != null) {
        String? token = await NotificationsService().getToken();
        await setPreference(
            TYPE_PERSON, USER); //only user can signIn with google and facebook

        print(user.email);
        DatabaseReference db =
            FirebaseDatabase.instance.reference().child(PERSON).child(user.uid);
        DataSnapshot? snapshot = await db.once();

        if (snapshot.value != null) {
          await setPreference(EMAIL, user.email);
          await setPreference(USERNAME, user.displayName);
          return user;
        } else {
          await db.set({
            USERNAME: user.displayName,
            TYPE_PERSON: USER,
            TOKEN: token != null ? token : '',
          });
          await setPreference(EMAIL, user.email);
          await setPreference(USERNAME, user.displayName);
          return user;
        }
      }
    } catch (error) {
      throw 'error: ' + error.toString();
    }
    throw 'Error';
  }

  Future<User> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // final requestData = await FacebookAuth.instance.getUserData(
        //   fields: "email, name, picture.type(large)",
        // ); more request for api and not use it thin f**k
        // print(requestData);
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await auth.signInWithCredential(facebookAuthCredential);
        final user = auth.currentUser;
        if (user != null) {
          String? token = await NotificationsService().getToken();
          await setPreference(TYPE_PERSON, USER);
          await setPreference(EMAIL, user.email);
          await setPreference(USERNAME, user.displayName);
          DatabaseReference db = FirebaseDatabase.instance
              .reference()
              .child(PERSON)
              .child(user.uid);
          DataSnapshot? snapshot = await db.once();

          /// once() Listens for a single value event and then stops listening.
          if (snapshot.value != null) {
            return user;
          } else {
            await db.set({
              USERNAME: user.displayName,
              TYPE_PERSON: USER,
              TOKEN: token != null ? token : '',
            });
            return user;
          }
        } else {
          throw 'Not Complete Sign in ,try again!';
        }
      } else {
        throw 'Error: ${result.message}';
      }
    } catch (e) {
      throw 'Error try Again!';
    }
  }
}
