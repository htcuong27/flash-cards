import 'package:flash_cards/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/home_screen.dart';
import '../screens/review_screen.dart';
import '../screens/add_word_screen.dart';
import '../core/theme/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ReviewScreen(),
    const AddWordScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProfileIcon({bool isActive = false}) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return Icon(isActive ? Icons.person : Icons.person_outline);
    }

    final avatarUrl = user.userMetadata?['avatar_url'] as String?;

    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: isActive
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            )
          : null,
      child: CircleAvatar(
        radius: 12,
        backgroundColor: AppColors.inactive,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null
            ? Icon(
                Icons.person,
                size: 16,
                color: isActive ? Colors.white : AppColors.background,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    label: const Text('10'), // This can be made dynamic later
                    child: const Icon(Icons.library_books_outlined),
                  ),
                  activeIcon: Badge(
                    label: const Text('10'),
                    child: const Icon(Icons.library_books),
                  ),
                  label: 'Review',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  activeIcon: Icon(Icons.add_circle),
                  label: 'Add',
                ),
                BottomNavigationBarItem(
                  icon: _buildProfileIcon(),
                  activeIcon: _buildProfileIcon(isActive: true),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.inactive,
              onTap: _onItemTapped,
              backgroundColor: AppColors.cardColor,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
