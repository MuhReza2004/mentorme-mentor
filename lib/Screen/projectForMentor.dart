import 'package:flutter/material.dart';
import 'package:mentormementor/services/storage/storage_service.dart';

class ProjectForMentorPage extends StatefulWidget {
  const ProjectForMentorPage({super.key});

  @override
  State<ProjectForMentorPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectForMentorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PROJECTKU',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahProjectPage()),
          );
          // Aksi ketika tombol ditekan, misalnya, navigasi ke halaman upload project
        },
        backgroundColor: const Color(0xff2ECC71),
        child: const Icon(Icons.upload),
      ),
    );
  }

  Widget _buildProjectCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman detail project
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 127,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tampilkan data project (judul, dll.)
                Text(
                  'Judul Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ...
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class TambahProjectPage extends StatefulWidget {
  @override
  _TambahProjectPageState createState() => _TambahProjectPageState();
}

class _TambahProjectPageState extends State<TambahProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF3),
      appBar: AppBar(
        title: const Text("Tambah Project Baru"),
        backgroundColor: const Color(0xFFE0FFF3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload Foto
            _buildSectionTitle("Upload Foto Kamu"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async
              {
                await StorageService().uploadImage(prefix: 'ktp');
                // Aksi yang akan dijalankan saat Container di-tap,
                // misal: membuka galeri atau kamera
                // ...
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 48,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Informasi Project
            _buildSectionTitle("Informasi Project"),
            const SizedBox(height: 10),
            _buildTextField(
              "HTML (Hypertext Markup Language) adalah bahasa...",
              enabled: false,
            ),
            const SizedBox(height: 20),
            
            // Materi Ajar
            _buildSectionTitle("Materi Ajar"),
            const SizedBox(height: 10),
            _buildAddButton("Tambahkan Materi Ajar"),
            const SizedBox(height: 20),

            // Preview Video
            _buildSectionTitle("Preview Video"),
            const SizedBox(height: 10),
            _buildTextField("Masukkan Link Preview Video"),
            const SizedBox(height: 30),

            // harga Project
            _buildSectionTitle("Harga Project"),
            const SizedBox(height: 10),
            _buildTextField("Masukkan harga"),
            const SizedBox(height: 30),


            // Tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOutlinedButton("Batalkan"),
                _buildElevatedButton("Tambah Project Baru"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat judul section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Fungsi untuk membuat TextField
  Widget _buildTextField(String hintText, {bool enabled = true}) {
     final focusNode = FocusNode();

    return TextField(
      focusNode: focusNode,
      maxLines: null,
      enabled: true,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Fungsi untuk membuat tombol "Tambahkan"
  Widget _buildAddButton(String text) {
    return OutlinedButton(
      onPressed: () {
        // Aksi ketika tombol "Tambahkan" ditekan
      },
style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0), // Adjust padding here
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns content horizontally
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0), // Adjust left padding for text
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 16.0), // Spacing between text and icon
        const Icon(Icons.add_circle, color: Colors.blue),
      ],
    ),
  );
  }

  // Fungsi untuk membuat tombol "Batalkan"
  Widget _buildOutlinedButton(String text) {
    return OutlinedButton(
      onPressed: () {
        // Aksi ketika tombol "Batalkan" ditekan
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, color: Colors.black),
        foregroundColor: Colors.black,
      ),
      child: Text(text),
    );
  }

  // Fungsi untuk membuat tombol "Tambah Project Baru"
  Widget _buildElevatedButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Aksi ketika tombol "Tambah Project Baru" ditekan
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff27DEBF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        foregroundColor: Colors.black, // Ubah warna teks di sini
      ),
      child: Text(text),
    );
  }
}

