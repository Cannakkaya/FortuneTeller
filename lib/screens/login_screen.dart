import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tarot_app/screens/home_screen.dart'; // HomeScreen location
import 'package:tarot_app/screens/register_screen.dart'; // RegisterScreen location

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Loading state

  // Firebase ile manuel giriş (Email ve Password)
  Future<void> _loginWithEmailPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showError("Please fill in both fields");
        return;
      }

      // Firebase giriş işlemi
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Giriş başarılıysa yönlendirme
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "An error occurred");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Firebase ile Google giriş fonksiyonu
  Future<void> _googleLogin() async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase ile giriş işlemi
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Başarılı giriş sonrası HomeScreen'e yönlendirme
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showError("Google login error: $e");
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  // Hata mesajı göstermek için
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Kullanıcı adı ve şifre alanları
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _loginWithEmailPassword,
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
            SizedBox(height: 20),
            // Google ile giriş yap butonu
            ElevatedButton(
              onPressed: _isLoading ? null : _googleLogin,
              child: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text('Login with Google'),
            ),
            SizedBox(height: 10),
            // Register ekranına yönlendirme butonu
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
