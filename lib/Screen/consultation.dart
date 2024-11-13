import 'package:flutter/material.dart';


class ConsultationScreen extends StatefulWidget {
  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1F8F7), // Light green background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
  child: Text(
    'Berlangsung',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
),

            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Tidak ada sesi konsultasi yang berlangsung',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 24),
           const  Center(
  child: Text(
    'Riwayat',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
),

            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  ConsultationHistoryCard(
                    imagePath: 'assets/User.jpg', // Replace with actual asset path
                    name: 'Nadia V',
                    role: 'Trainee',
                    session: 'Sesi Konsultasi Selesai',
                  ),
                  ConsultationHistoryCard(
                    imagePath: 'assets/User.jpg', // Replace with actual asset path
                    name: 'Shean D',
                    role: 'Trainee',
                    session: 'Sesi Konsultasi Selesai',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultationHistoryCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  final String session;

  ConsultationHistoryCard({
    required this.imagePath,
    required this.name,
    required this.role,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(name),
        subtitle: Text(role),
        trailing: Text(session, style: TextStyle(color: Colors.green)),
      ),
    );
  }
}
