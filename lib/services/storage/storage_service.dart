// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageService with ChangeNotifier {
  // firebase storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  //Image are stored in firebase storage as downloadURLs
  List<String> _imageUrls = [];

  //Loading status
  bool _isLoading = false;

  //Uploading status
  bool _isUploading = false;

  //getter image
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  //read image
  Future<void> fetchImages() async {
    // start loading
    _isLoading = true;

    final ListResult result = await storage.ref('uploadded_images/').listAll();

    final urls =
        await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    // upadate urls
    _imageUrls = urls;

    // stop loading
    _isLoading = false;

    // update ui
    notifyListeners();
  }

  //Deleting image
  Future<void> deleteImages(String imageUrl) async {
    try {
      _imageUrls.remove(imageUrl);

      final String Path = extractPathFromUrl(imageUrl);
      await storage.ref('uploadded_images/$Path').delete();
    } catch (e) {
      print("error deleting image: $e");
    }

    notifyListeners();
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);

    String encodedPath = uri.pathSegments.last;

    return Uri.decodeComponent(encodedPath);
  }

// upload image
  Future<void> uploadImage() async {
    _isUploading = true;
    notifyListeners();

    // Pick Image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    try {
      // Define path
      String firePath = 'uploadded_images/${DateTime.now()}.png';
      // Upload
      await storage.ref(firePath).putFile(file);
      // after upload, fetch url
      String downloadUrl = await storage.ref(firePath).getDownloadURL();
      // update image
      _imageUrls.add(downloadUrl);
      notifyListeners();
    }

    // handle eror
    catch (e) {
      print("error uploading image: $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
