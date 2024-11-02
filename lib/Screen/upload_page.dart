import 'package:flutter/material.dart';
import 'package:mentormementor/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  void initState() {
    super.initState();

    fetchImages();
  }

  // fetch images
  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(builder: (context, StorageService, child) {
      // list of images
      final List<String> imageUrls = StorageService.imageUrls;

      return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => StorageService.uploadImage(),
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final String imageUrl = imageUrls[index];

              // image post ui
              return Image.network(imageUrl);
            },
          ));
    });
  }
}
