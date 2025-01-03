import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentormementor/Global/fontStyle.dart';
import 'package:mentormementor/Global/global.dart';
import 'package:mentormementor/Screen/mainScreen.dart';
import 'package:mentormementor/Screen/register_page1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFE0FFF3),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // Atur padding secukupnya
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Supaya kotak menyesuaikan dengan konten
              children: [
                Image.asset(
                  'assets/Logo.png',
                  width: 60, // Sesuaikan ukuran logo
                  height: 60,
                ),
                const SizedBox(height: 15),
                const Row(
                  mainAxisSize: MainAxisSize
                      .min, // Menyesuaikan lebar berdasarkan isi Row
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Sedang masuk...",
                      style: Subjudulstyle.defaultTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      showLoadingDialog();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        );

        if (userCredential.user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users_mentor')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists) {
            currentUser = userCredential.user;

            Fluttertoast.showToast(msg: "Login berhasil");
            hideLoadingDialog();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (c) => const MainScreen()),
            );
          } else {
            hideLoadingDialog();
            Fluttertoast.showToast(msg: "Data pengguna tidak ditemukan!");
            await FirebaseAuth.instance.signOut();
          }
        }
      } catch (error) {
        hideLoadingDialog();
        Fluttertoast.showToast(msg: "Email/Password salah!");
      }
    } else {
      Fluttertoast.showToast(msg: "Mohon isi semua data dengan benar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Logo.png', // Ganti dengan path logo
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text('MentorME for Mentor',
                    style: judulstyle.defaultTextStyle),
                const SizedBox(height: 10),
                const Text('Login', style: Subjudulstyle.defaultTextStyle),
                const SizedBox(height: 30),
                TextFormField(
                  controller: emailTextEditingController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: Captionsstyle.defaultTextStyle,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordTextEditingController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: Captionsstyle.defaultTextStyle,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.security),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Or social login',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Aksi login dengan Google
                      },
                      icon: Image.asset(
                        'assets/google.png',
                        width: 27, // Lebar gambar
                        height: 27,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF339989),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun?',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage1(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar di sini',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF339989),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
