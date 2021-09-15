import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginProcess extends StatefulWidget {
  const LoginProcess({Key? key}) : super(key: key);
  @override
  _LoginProcessState createState() => _LoginProcessState();
}

class _LoginProcessState extends State<LoginProcess> {
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Process'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _emailPasswordCreateUser,
              child: const Text('Email/Password User Create'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
            ElevatedButton(
              onPressed: _emailPasswordLoginUser,
              child: const Text('Email/Password User Login'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
            ElevatedButton(
              onPressed: _emailPasswordResetPassword,
              child: const Text('Password Reset Link',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.limeAccent),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
            ElevatedButton(
              onPressed: _updatePassword,
              child: const Text('Update Password'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.purpleAccent),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text('Update Email'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Signin with Gmail'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
            ElevatedButton(
              onPressed: _signInWithPhone,
              child: const Text('Signin with Phone'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
            ElevatedButton(
              onPressed: _emailPasswordLogoutUser,
              child: const Text('Logout'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black))),
            ),
          ],
        ),
      ),
    );
  }

  void _emailPasswordCreateUser() async {
    String _email = 'hamitseyrek@gmail.com';
    String _password = '12345678p';
    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      var _user = _credential.user;
      await _user!.sendEmailVerification();
      if (_auth.currentUser != null) {
        debugPrint('Please verify your email!');
        await _auth.signOut();
      } else {}
      debugPrint(_user.toString());
    } catch (e) {
      debugPrint('********************ERROR1****************');
      debugPrint(e.toString());
    }
  }

  void _emailPasswordLoginUser() async {
    String _email = 'hamitseyrek@gmail.com';
    String _password = '12345678p';
    try {
      if (_auth.currentUser == null) {
        var _user = (await _auth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        if (!_user!.emailVerified) {
          debugPrint('Please verify emai');
          _auth.signOut();
        }
      } else {
        debugPrint('Already user login');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('********************ERROR2****************');
      debugPrint(e.toString());
    }
  }

  void _emailPasswordLogoutUser() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
  }

  void _emailPasswordResetPassword() async {
    String _email = 'hamitseyrek@gmail.com';
    try {
      await _auth.sendPasswordResetEmail(email: _email);
    } catch (e) {
      debugPrint('********************ERROR3****************');
      debugPrint(e.toString());
    }
  }

  void _updatePassword() async {
    if (_auth.currentUser != null) {
      try {
        await _auth.currentUser!.updatePassword('12345678p');
        debugPrint('*******UPDATED PASSWORD*******');
      } catch (e) {
        try {
          String _email2 = 'hamitseyrek@gmail.com';
          String _password = '12345678p';

          AuthCredential _credential =
              EmailAuthProvider.credential(email: _email2, password: _password);
          await _auth.currentUser!.reauthenticateWithCredential(_credential);
          await _auth.currentUser!.updatePassword('12345678p');
        } catch (e) {
          debugPrint('********************ERROR4****************');
          debugPrint(e.toString());
        }
      }
    }
  }

  void _updateEmail() async {
    if (_auth.currentUser != null) {
      try {
        await _auth.currentUser!.updateEmail('hamitseyrek@gmail.com');
        debugPrint('*******UPDATED EMAIL*******');
      } catch (e) {
        try {
          String _email2 = 'hamitseyrek@gmail.com';
          String _password = '12345678p';

          AuthCredential _credential =
              EmailAuthProvider.credential(email: _email2, password: _password);
          await _auth.currentUser!.reauthenticateWithCredential(_credential);
          await _auth.currentUser!.updateEmail('hamitseyrek@gmail.com');
        } catch (e) {
          debugPrint('********************ERROR4****************');
          debugPrint(e.toString());
        }
      }
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint('********************ERROR6****************');
      debugPrint(e.toString());
      final credential = GoogleAuthProvider.credential();
      return await _auth.signInWithCredential(credential);
    }
  }

  void _signInWithPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+90 544 210 12 34',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
        }
        debugPrint('********************ERROR7****************');
        debugPrint(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) async {
        debugPrint('***************SEND CODE************');
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = '123456';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await _auth.signInWithCredential(credential);
        debugPrint('***********SUCCESSFUL*********');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('***************TIMEOUT************');
      },
    );
  }
}
