import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentormementor/Screen/register_page3.dart';
import 'package:mentormementor/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

class RegisterPage2 extends StatefulWidget {
  final String nama;
  final String email;
  final String phone;
  final String password;

  const RegisterPage2({
    super.key,
    required this.nama,
    required this.email,
    required this.phone,
    required this.password,
  });

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

      if (storageService.ktpImageUrl == null) {
        Fluttertoast.showToast(msg: "Mohon upload foto KTP");
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage3(
            nama: widget.nama,
            email: widget.email,
            phone: widget.phone,
            password: widget.password,
            nik: _nikController.text.trim(),
            ktpImageUrl: storageService.ktpImageUrl!,
          ),
        ),
      );
    } catch (e) {
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
                        await storageService.uploadImage(prefix: 'ktp');
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
                      child: storageService.ktpImageUrl == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload, size: 50),
                                Text('Tap untuk upload foto KTP'),
                              ],
                            )
                          : Image.network(
                              storageService.ktpImageUrl!,
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
