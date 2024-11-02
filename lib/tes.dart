import 'package:flutter/material.dart';
import 'package:mentormementor/services/storage/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nikController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    try {
      await Provider.of<StorageService>(context, listen: false)
          .loadExistingImage();

      // Load NIK jika sudah ada
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users_mentor')
            .doc(userId)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data['nik'] != null) {
            _nikController.text = data['nik'];
          }
        }
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveData(StorageService storageService) async {
    try {
      if (_nikController.text.isEmpty) {
        Fluttertoast.showToast(msg: "Mohon isi nomor KTP");
        return;
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Fluttertoast.showToast(msg: "Silakan login terlebih dahulu");
        return;
      }

      final ktpImageUrl = storageService.imageUrls.isNotEmpty
          ? storageService.imageUrls.last
          : null;

      if (ktpImageUrl == null) {
        Fluttertoast.showToast(msg: "Mohon upload foto KTP");
        return;
      }

      await FirebaseFirestore.instance
          .collection('users_mentor')
          .doc(userId)
          .update({
        'nik': _nikController.text,
        'ktpImageUrl': ktpImageUrl,
      });

      Fluttertoast.showToast(msg: "Data berhasil disimpan");
      // Navigate to next screen if needed
    } catch (e) {
      Fluttertoast.showToast(msg: "Terjadi kesalahan: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE0FFF3),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE0FFF3),
            title: LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.grey[300],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xff3DD598)),
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
                      'Scan Foto KTP',
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
                              msg: "Gagal upload gambar: ${e.toString()}");
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
                                  Icon(
                                    Icons.upload,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
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
                    const Text(
                      'NO KTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan No. KTP',
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
                    onPressed: () => _saveData(storageService),
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

  @override
  void dispose() {
    _nikController.dispose();
    super.dispose();
  }
}
