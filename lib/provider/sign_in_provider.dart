import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  String? _age;
  String? get age => _age;

  String? _dob;
  String? get dob => _dob;

  String? _religion;
  String? get religion => _religion;

  String? _language;
  String? get language => _language;

  String? _gender;
  String? get gender => _gender;

  String? _address;
  String? get address => _address;

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  String? _personalStatement;
  String? get personalStatement => _personalStatement;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

// sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance

        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // saving all values
        _uid = userDetails.uid;
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'account-exists-with-different-credentials':
            _errorCode =
                "You already have an account with us, Use another provider";
            _hasError = true;
            notifyListeners();
            break;

          case 'null':
            _errorCode = "Unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
            break;
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // Function to delete user data
  Future<void> deleteUser() async {
    try {
      // Get the current user
      User? currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        // Delete user data from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .delete();

        // Delete user from Firebase Authentication
        await currentUser.delete();

        // Sign out the user
        await signOut();

        // Clear stored data
        await clearStoredData();
      }
    } catch (error) {
      // Handle errors
      _hasError = true;
      _errorCode = error.toString();
      notifyListeners();
    }
  }

  // sign in with facebook
  Future signInwithFacebook() async {
    final LoginResult result = await facebookAuth.login();
    // getting the profile
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

    final profile = jsonDecode(graphResponse.body);

    if (result.status == LoginStatus.success) {
      try {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await firebaseAuth.signInWithCredential(credential);
        // saving the values
        _name = profile['name'];
        _email = profile['email'];
        _imageUrl = profile['picture']['data']['url'];
        _uid = profile['id'];
        _hasError = false;
        _provider = "FACEBOOK";
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['imageUrl'],
              _phoneNumber = snapshot['phoneNumber'],
              _age = snapshot['age'],
              _dob = snapshot['dob'],
              _religion = snapshot['religion'],
              _language = snapshot['language'],
              _address = snapshot['address'],
              _provider = snapshot['provider'],
              _gender = snapshot['gender'],
              _personalStatement = snapshot['personalStatement'],
              _hasError = false,
              notifyListeners()
            });
  }

  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      'name': _name,
      'email': _email,
      'uid': uid,
      'imageUrl': _imageUrl,
      'provider': _provider,
      'phoneNumber': _phoneNumber,
      'age': _age,
      'language': _language,
      'address': _address,
      'dob': _dob,
      'religion': _religion,
      'gender': _gender,
      'personalStatement': _personalStatement,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setString('name', _name ?? '');
    s.setString('email', _email ?? '');
    s.setString('uid', _uid ?? '');
    s.setString('imageUrl', _imageUrl ?? '');
    s.setString('provider', _provider ?? '');
    s.setString('phoneNumber', _phoneNumber ?? '');
    s.setString('age', _age ?? '');
    s.setString('language', _language ?? '');
    s.setString('address', _address ?? '');
    s.setString('dob', _dob ?? '');
    s.setString('religion', _religion ?? '');
    s.setString('gender', _gender ?? '');
    s.setString('personalStatement', _personalStatement ?? '');

    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('imageUrl');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    _phoneNumber = s.getString('phoneNumber');
    _age = s.getString('age');
    _language = s.getString('language');
    _address = s.getString(
      'address',
    );
    _dob = s.getString('dob');
    _religion = s.getString('religion');
    _gender = s.getString('gender');
    _personalStatement = s.getString('personalStatement');

    notifyListeners();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.clear();
    _name = null;
    _email = null;
    _imageUrl = null;
    _uid = null;
    _provider = null;
    _phoneNumber = null;
    _age = null;
    _language = null;
    _address = null;
    _dob = null;
    _religion = null;
    _gender = null;
    _personalStatement = null;

    notifyListeners();
  }

  // check user exist
  Future<bool> checkUserExist() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print("USER ALREADY EXIST");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  // signOut function
  Future signOut() async {
    await firebaseAuth.signOut();
    await facebookAuth.logOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
    // await clearUserDataFromSharedPreferences();
    // clear stored data
    clearStoredData();
  }

  // Future clearStoredData() async {
  //   final SharedPreferences s = await SharedPreferences.getInstance();
  //   s.clear();
  // }

  Future saveAdditionalUserData({
    required String age,
    required String dob,
    required String address,
    required String language,
    required String email,
    required String religion,
    required String gender,
    required String name,
    required String phoneNumber,
    required String personalStatement,
  }) async {
    try {
      // Validation
      if (age.isEmpty ||
          // dob.isEmpty ||
          address.isEmpty ||
          phoneNumber.isEmpty ||
          personalStatement.isEmpty) {
        throw 'Please fill in all required fields.';
      }

      // Save additional user data to Firestore
      final DocumentReference r =
          FirebaseFirestore.instance.collection("users").doc(uid);
      await r.update({
        'name': name,
        'age': age,
        'dob': dob,
        'address': address,
        'phoneNumber': phoneNumber,
        'language': language,
        'religion': religion,
        'email': email,
        'gender': gender,
        'personalStatement': personalStatement,
      });

      // Save additional user data to SharedPreferences
      final SharedPreferences s = await SharedPreferences.getInstance();
      s.setString('age', age);
      s.setString('name', name);
      s.setString('dob', dob);
      s.setString('address', address);
      s.setString('phoneNumber', phoneNumber);
      s.setString('language', language);
      s.setString('email', email);
      s.setString('gender', gender);
      s.setString('religion', religion);
      s.setString('personalStatement', personalStatement);

      // Update local variables
      _age = age;
      _dob = dob;
      _address = address;
      _phoneNumber = phoneNumber;
      _personalStatement = personalStatement;
      _language = language;
      _email = email;
      _gender = gender;
      _name = name;
      _religion = religion;

      // Notify listeners
      notifyListeners();
    } catch (error) {
      // Handle errors
      _hasError = true;
      _errorCode = error.toString();
      notifyListeners();
    }
  }

  Future getAdditionalUserData() async {
    // Retrieve additional user data from SharedPreferences
    final SharedPreferences s = await SharedPreferences.getInstance();
    _age = s.getString('age');
    _dob = s.getString('dob');
    _address = s.getString('address');
    _phoneNumber = s.getString('phoneNumber');
    _personalStatement = s.getString('personalStatement');
    _language = s.getString('language');
    _email = s.getString('email');
    _gender = s.getString('gender');
    _name = s.getString('name');
    _religion = s.getString('religion');

    // Notify listeners
    notifyListeners();
  }
}
