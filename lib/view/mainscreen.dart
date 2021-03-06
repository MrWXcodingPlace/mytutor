import 'package:flutter/material.dart';
import 'package:mytutor/view/favouritescreen.dart';
import 'package:mytutor/view/profilescreen.dart';
import 'package:mytutor/view/subjectscreen.dart';
import 'package:mytutor/view/subscribescreen.dart';
import 'package:mytutor/view/tutotscreen.dart';
import '../model/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> children;

  @override
  void initState() {
    super.initState();
    children = [
      SubjectScreen(user: widget.user),
      const TutorScreen(),
      const SubscribeScreen(),
      const FavouriteScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        iconSize: 30.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Tutors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
