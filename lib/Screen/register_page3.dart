import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentormementor/Screen/login.dart';
import 'package:mentormementor/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

class RegisterPage3 extends StatefulWidget {
  final String nama;
  final String email;
  final String phone;
  final String password;
  final String nik;
  final String ktpImageUrl;

  const RegisterPage3({
    super.key,
    required this.nama,
    required this.email,
    required this.phone,
    required this.password,
    required this.nik,
    required this.ktpImageUrl,
  });

  @override
  State<RegisterPage3> createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {
  Future<void> _finalizeRegistration() async {
    try {
      final storageService =
          Provider.of<StorageService>(context, listen: false);

      // Cek apakah sertifikat sudah diupload
      if (storageService.sertifikatImageUrl == null) {
        Fluttertoast.showToast(
          msg: "Mohon upload foto sertifikat",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        return;
      }

      // Buat user Auth terlebih dahulu
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // Pindahkan file ke folder permanen dengan userId
      await storageService.moveFilesToPermanent(userCredential.user!.uid);

      // Data untuk Firestore
      final userData = {
        'nama': widget.nama,
        'email': widget.email,
        'phone': widget.phone,
        'nik': widget.nik,
        'ktpImageUrl': storageService.ktpImageUrl,
        'sertifikatImageUrl': storageService.sertifikatImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'mentor',
        'registrationComplete': true,
      };

      try {
        // Simpan ke Firestore
        await FirebaseFirestore.instance
            .collection('users_mentor')
            .doc(userCredential.user!.uid)
            .set(userData);

        await FirebaseAuth.instance.signOut();

        // Clear images setelah berhasil
        storageService.clearImages();

        Fluttertoast.showToast(
          msg: "Registrasi berhasil!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } catch (firestoreError) {
        // Jika gagal menyimpan ke Firestore, hapus user Auth
        await userCredential.user?.delete();
        throw Exception('Gagal menyimpan data: $firestoreError');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan saat registrasi';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah terdaftar';
      }
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE0FFF3),
          appBar: AppBar(
            title: const Text('Upload Sertifikat'),
            backgroundColor: const Color(0xFF339989),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Upload Foto Sertifikat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await storageService.uploadImage(prefix: 'sertifikat');
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                        );
                      }
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: storageService.sertifikatImageUrl == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload, size: 50),
                                Text('Tap untuk upload foto sertifikat'),
                              ],
                            )
                          : Image.network(
                              storageService.sertifikatImageUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _finalizeRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF339989),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
