import 'package:flash_cards/blocs/auth/auth_bloc.dart';
import 'package:flash_cards/blocs/review/review_bloc.dart';
import 'package:flash_cards/blocs/word/word_bloc.dart';
import 'package:flash_cards/core/theme/colors.dart';
import 'package:flash_cards/screens/login_screen.dart';
import 'package:flash_cards/screens/main_screen.dart';
import 'package:flash_cards/screens/splash_screen.dart';
import 'package:flash_cards/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => WordBloc(),
        ),
        BlocProvider(
          create: (context) => ReviewBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'AvoMeow',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: const AppNavigator(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainScreen();
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
