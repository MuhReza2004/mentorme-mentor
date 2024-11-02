import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:mentormementor/Global/global.dart';
import 'package:mentormementor/Screen/login.dart';
import 'package:mentormementor/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// hash password
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential auth = await firebaseAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        );

        currentUser = auth.user;
        if (currentUser != null) {
          // hash password
          String hashedPassword =
              hashPassword(passwordTextEditingController.text.trim());
          Map<String, dynamic> userData = {
            'id': currentUser!.uid,
            'nama': namaTextEditingController.text.trim(),
            'phone': phoneTextEditingController.text
                .trim(), // Assuming you meant phone
            'email': emailTextEditingController.text.trim(),
            'password': hashedPassword,
            'role': 'mentor',
            'createdAt': FieldValue.serverTimestamp(),
          };

          await FirebaseFirestore.instance
              .collection('users_mentor')
              .doc(currentUser!.uid)
              .set(userData);

          await Fluttertoast.showToast(msg: "Akun berhasil dibuat");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const LoginPage()));
        }
      } catch (error) {
        Fluttertoast.showToast(msg: "Error Registration: $error");
      }
    } else {
      Fluttertoast.showToast(msg: "Error Registration: Mohon isi semua field");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 10),
              Image.asset(
                'assets/Logo.png', // Ganti dengan path logo
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'MentorME',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF339989),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Masukkan data diri Anda',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Nama',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                        },
                        onChanged: (text) => setState(() {
                          namaTextEditingController.text = text;
                        }),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Phone',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                        },
                        onChanged: (text) => setState(() {
                          phoneTextEditingController.text = text;
                        }),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                        },
                        onChanged: (text) => setState(() {
                          emailTextEditingController.text = text;
                        }),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: !_passwordVisible,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                            hintText: 'password',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.security,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                })),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          if (text.length < 6) {
                            return 'Minimal 6 karakter';
                          }
                          if (!text.contains(RegExp(r'[A-Z]'))) {
                            return 'Minimal 1 huruf besar';
                          }
                          if (!text.contains(RegExp(r'[a-z]'))) {
                            return 'Minimal 1 huruf kecil';
                          }
                          if (!text.contains(RegExp(r'[0-9]'))) {
                            return 'Minimal 1 angka';
                          }
                        },
                        onChanged: (text) => setState(() {
                          passwordTextEditingController.text = text;
                        }),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: (!_passwordVisible),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                            hintText: 'Confirm password',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.security,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                })),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          if (text != passwordTextEditingController.text) {
                            return 'Password tidak sama';
                          }
                        },
                        onChanged: (text) => setState(() {
                          confirmTextEditingController.text = text;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  submitForm();
                  // Aksi daftar
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF339989),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Or social register',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                // Social register buttons
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // Aksi register dengan Apple
                    },
                    icon: const Icon(Icons.apple),
                    iconSize: 40,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // Aksi register dengan Google
                    },
                    icon: Image.asset(
                      'assets/google.png',
                      width: 27,
                      height: 27,
                    ), // Ganti dengan path gambar Google Anda
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      // Aksi navigasi ke halaman login
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Masuk disini',
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
    );
  }
}


class KtpRegist extends StatefulWidget {
  const KtpRegist({super.key});

  @override
  State<KtpRegist> createState() => KtpRegistState();
}

class KtpRegistState extends State<KtpRegist> {
  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        final List<String> imageUrls = storageService.imageUrls;

        return Scaffold(
          backgroundColor: const Color(0xFFE0FFF3),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE0FFF3),
            title: LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff3DD598)),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Scan Foto KtpRegist',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => storageService.uploadImage(),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.upload,
                              size: 40,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: imageUrls.length,
                                itemBuilder: (context, index) {
                                  final String imageUrl = imageUrls[index];
                                  return Image.network(imageUrl);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'NO KtpRegist',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'No. KtpRegist',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF339989),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      textStyle: const TextStyle(fontSize: 18),
                      foregroundColor: const Color(0xffffffff),
                    ),
                    onPressed: () {
                      // Handle the "Next" button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KtpRegist()),
                      );
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
