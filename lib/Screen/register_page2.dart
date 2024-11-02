import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentormementor/Screen/login.dart';
import 'package:mentormementor/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

class RegisterPage2 extends StatefulWidget {
  final String userId;

  const RegisterPage2({super.key, required this.userId});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final TextEditingController _nikController = TextEditingController();

  Future<void> _completeRegistration() async {
    try {
      if (_nikController.text.isEmpty) {
        Fluttertoast.showToast(msg: "Mohon isi nomor KTP");
        return;
      }

      final storageService =
          Provider.of<StorageService>(context, listen: false);
      final ktpImageUrl = storageService.imageUrls.isNotEmpty
          ? storageService.imageUrls.last
          : null;

      if (ktpImageUrl == null) {
        Fluttertoast.showToast(msg: "Mohon upload foto KTP");
        return;
      }

      final docRef = FirebaseFirestore.instance
          .collection('users_mentor')
          .doc(widget.userId);

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set({
          'nik': _nikController.text.trim(),
          'ktpImageUrl': ktpImageUrl,
          'registrationComplete': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.update({
          'nik': _nikController.text.trim(),
          'ktpImageUrl': ktpImageUrl,
          'registrationComplete': true,
        });
      }

      await FirebaseAuth.instance.signOut();

      Fluttertoast.showToast(msg: "Registrasi berhasil!");

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print('Error completing registration: $e');
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE0FFF3),
          appBar: AppBar(
            title: const Text('Upload KTP'),
            backgroundColor: const Color(0xFF339989),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Upload Foto KTP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await storageService.uploadImage();
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Error uploading image: ${e.toString()}");
                      }
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: storageService.imageUrls.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload, size: 50),
                                Text('Tap untuk upload foto KTP'),
                              ],
                            )
                          : Image.network(
                              storageService.imageUrls.last,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nikController,
                    decoration: InputDecoration(
                      labelText: 'Nomor KTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _completeRegistration,
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

  @override
  void dispose() {
    _nikController.dispose();
    super.dispose();
  }
}
