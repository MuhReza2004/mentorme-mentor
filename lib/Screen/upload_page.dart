import 'package:flutter/material.dart';
import 'package:mentormementor/services/storage/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _nikController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  // fetch images
  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false)
        .loadExistingImage();
  }

  Future<void> _saveData(StorageService storageService) async {
    try {
      if (_nikController.text.isEmpty) {
        Fluttertoast.showToast(msg: "Mohon isi nomor KTP");
        return;
      }

      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Fluttertoast.showToast(msg: "User belum login");
        return;
      }

      // Ambil URL gambar terakhir yang diupload (jika ada)
      final String? ktpImageUrl = storageService.imageUrls.isNotEmpty
          ? storageService.imageUrls.last
          : null;

      if (ktpImageUrl == null) {
        Fluttertoast.showToast(msg: "Mohon upload foto KTP");
        return;
      }

      // Update data di Firestore
      await FirebaseFirestore.instance
          .collection('users_mentor')
          .doc(userId)
          .update({
        'nik': _nikController.text,
        'ktpImageUrl': ktpImageUrl,
      });

      Fluttertoast.showToast(msg: "Data berhasil disimpan");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Upload KTP'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              try {
                await storageService.uploadImage();
              } catch (e) {
                Fluttertoast.showToast(
                    msg: "Error uploading image: ${e.toString()}");
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nikController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor KTP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: storageService.imageUrls.isEmpty
                      ? const Center(child: Text('Belum ada foto KTP'))
                      : ListView.builder(
                          itemCount: storageService.imageUrls.length,
                          itemBuilder: (context, index) {
                            final String imageUrl =
                                storageService.imageUrls[index];
                            return Card(
                              child: Column(
                                children: [
                                  Image.network(
                                    imageUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  ButtonBar(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await storageService
                                                .deleteImage(imageUrl);
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Error deleting image: ${e.toString()}");
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                ElevatedButton(
                  onPressed: () => _saveData(storageService),
                  child: const Text('Simpan Data'),
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
