// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageService extends ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _ktpImageUrl;
  String? _sertifikatImageUrl;
  String? _tempUserId;

  String? get ktpImageUrl => _ktpImageUrl;
  String? get sertifikatImageUrl => _sertifikatImageUrl;

  StorageService() {
    _tempUserId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> uploadImage({String? prefix}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) return;

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = '${prefix ?? "image"}_$timestamp.jpg';

      // Perbaikan path storage
      String storagePath;
      if (prefix == 'ktp') {
        storagePath = 'temp_images/ktp/$fileName';
      } else if (prefix == 'sertifikat') {
        storagePath = 'temp_images/sertifikat/$fileName';
      } else {
        storagePath = 'temp_images/other/$fileName';
      }

      Reference storageRef = _storage.ref().child(storagePath);

      // Upload file
      final UploadTask uploadTask = storageRef.putFile(
        File(image.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          print(
              'Progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
        },
        onError: (e) {
          print('Error during upload: $e');
        },
      );

      // Tunggu sampai upload selesai
      final TaskSnapshot taskSnapshot = await uploadTask;

      // Dapatkan URL download
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Update URL sesuai prefix
      if (prefix == 'ktp') {
        _ktpImageUrl = downloadUrl;
      } else if (prefix == 'sertifikat') {
        _sertifikatImageUrl = downloadUrl;
      }

      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Gagal mengupload gambar: $e');
    }
  }

  Future<void> moveFilesToPermanent(String userId) async {
    try {
      // Pindahkan KTP
      if (_ktpImageUrl != null) {
        final Reference oldRef = _storage.refFromURL(_ktpImageUrl!);
        final String fileName = oldRef.name;
        final Reference newRef =
            _storage.ref().child('users/$userId/ktp/$fileName');

        // Upload ke lokasi baru
        final File tempFile = File('${Directory.systemTemp.path}/$fileName');
        await oldRef.writeToFile(tempFile);
        final UploadTask uploadTask = newRef.putFile(tempFile);
        await uploadTask;

        // Update URL
        _ktpImageUrl = await newRef.getDownloadURL();

        // Hapus file temporary
        await tempFile.delete();
        try {
          await oldRef.delete();
        } catch (e) {
          print('Error deleting old KTP file: $e');
        }
      }

      // Pindahkan Sertifikat
      if (_sertifikatImageUrl != null) {
        final Reference oldRef = _storage.refFromURL(_sertifikatImageUrl!);
        final String fileName = oldRef.name;
        final Reference newRef =
            _storage.ref().child('users/$userId/sertifikat/$fileName');

        // Upload ke lokasi baru
        final File tempFile = File('${Directory.systemTemp.path}/$fileName');
        await oldRef.writeToFile(tempFile);
        final UploadTask uploadTask = newRef.putFile(tempFile);
        await uploadTask;

        // Update URL
        _sertifikatImageUrl = await newRef.getDownloadURL();

        // Hapus file temporary
        await tempFile.delete();
        try {
          await oldRef.delete();
        } catch (e) {
          print('Error deleting old sertifikat file: $e');
        }
      }

      _tempUserId = userId;
      notifyListeners();
    } catch (e) {
      print('Error moving files: $e');
      throw Exception('Gagal memindahkan file: $e');
    }
  }

  void clearImages() {
    _ktpImageUrl = null;
    _sertifikatImageUrl = null;
    _tempUserId = null;
    notifyListeners();
  }
}
