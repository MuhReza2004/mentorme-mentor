// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageService extends ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  Future<void> uploadImage() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User tidak ditemukan');
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) return;

      final String fileName = 'ktp_$userId.jpg';

      final Reference storageRef = _storage.ref().child('ktp_images/$fileName');

      final UploadTask uploadTask = storageRef.putFile(File(image.path));

      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageUrls.add(downloadUrl);

      await FirebaseFirestore.instance
          .collection('users_mentor')
          .doc(userId)
          .set({
        'ktpImageUrl': downloadUrl,
      }, SetOptions(merge: true));

      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      _imageUrls.remove(imageUrl);

      final Reference ref = _storage.refFromURL(imageUrl);

      await ref.delete();

      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'ktpImageUrl': null,
        });
      }

      notifyListeners();
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }

  Future<void> loadExistingImage() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final String? ktpImageUrl = data['ktpImageUrl'] as String?;

        if (ktpImageUrl != null && !_imageUrls.contains(ktpImageUrl)) {
          _imageUrls.add(ktpImageUrl);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading existing image: $e');
      rethrow;
    }
  }
}
