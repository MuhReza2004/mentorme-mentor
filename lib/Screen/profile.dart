import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F8F7), // Light greenish background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1F8F7),
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.notifications, color: Colors.black),
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/User.jpg'), // Replace with your image asset
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Zidan BSA',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Mobile Developer',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                SizedBox(width: 4),
                                Text(
                                  '5.0',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB1E3FF), // Active tab color
                          ),
                          child: const Text('Pengalaman'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Review'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Exchange'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Image.asset('assets/Logo.png', width: 40), // Replace with your asset
                    title: const Text('Website Development'),
                    subtitle: const Text('MySkill - PT. Linimuda Inspirasi Negeri'),
                  ),
                  ListTile(
                    leading: Image.asset('assets/Logo.png', width: 40), // Replace with your asset
                    title: const Text('Junior Web Developer'),
                    subtitle: const Text('BPPTIK Kementerian Komunikasi dan Informatika RI'),
                  ),
                ],
              ),
            ),
        const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.black),
            label: const Text('Tambah Pengalaman', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[200], // Button color
      ),
    ),
  ],
),
          ],
        ),
      ),
    );
  }
}
