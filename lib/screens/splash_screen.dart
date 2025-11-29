import 'package:flash_cards/screens/intro_screen.dart';
import 'package:flash_cards/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startInitialization();
    _listenAuth();
  }

  void _listenAuth() async {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      if (event == AuthChangeEvent.initialSession ||
          event == AuthChangeEvent.signedIn) {
        if (session != null) {
          _handleNewUserSignIn(session.user);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IntroScreen()),
          );
        }
      } else if (event == AuthChangeEvent.signedOut) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
        );
      }
    });
  }

  Future<void> _handleNewUserSignIn(User user) async {
    final response = await supabase
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .limit(1)
        .maybeSingle();
    print('Profile response: $response');
    if (response == null) {
      try {
        await supabase.from('profiles').insert({
          'id': user.id,
          'name': user.userMetadata?['full_name'] ??
              user.email?.split('@')[0] ??
              'Người dùng mới',
          'email': user.email,
          'avatar_url': user.userMetadata?['avatar_url'] ?? '',
        });
      } catch (e) {
        debugPrint('Lỗi khi tạo profile cho user ${user.id}: $e');
      }
    } else {
      await supabase.from('profiles').update(
          {'last_seen': DateTime.now().toIso8601String()}).eq('id', user.id);
    }
  }

  void _startInitialization() async {
    try {
      await initializeSupabase();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet, using offline mode')),
      );
      await Future.delayed(const Duration(milliseconds: 3000));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
