import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentormementor/Screen/Pelajaranku.dart';
import 'package:mentormementor/Screen/consultation.dart';
import 'package:mentormementor/Screen/profile.dart';
import 'package:mentormementor/Screen/projectForMentor.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainStateScreen();
}

class _MainStateScreen extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;
  String userName = '';

  onItemClicked(int index) {
    if (tabController != null) {
      // <-- Tambahkan pengecekan null
      setState(() {
        selectedIndex = index;
        tabController!.index = selectedIndex;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users_mentor')
            .doc(userId)
            .get();

        if (docSnapshot.exists) {
          setState(() {
            userName = docSnapshot.get('nama') ?? 'User';
          });
        }
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: selectedIndex == 3 ? null : AppBar(
        backgroundColor: const Color(0xffE0FFF3),
        scrolledUnderElevation: 0,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/User.jpg'),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi! $userName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: const Color(0xff339989),
                  onPressed: () {
                    // Handle notifications icon tap
                  },
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xff7DE2D1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/Coin.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '15',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // Handle the add button tap
                        },
                        child: const Icon(
                          Icons.add_box,
                          color: Color(0xff339989),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children:  [

          //*ALL MAIN SCREEN*//

           Pelajaranku(),
           ProjectForMentorPage(),
           ConsultationScreen(),
           ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Pelajaranku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}
