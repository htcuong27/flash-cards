import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final supabase = Supabase.instance.client;

Future<void> initializeSupabase() async {
  const env = String.fromEnvironment("SUPABASE_KEY", defaultValue: "NOT_FOUND");
  const url = String.fromEnvironment("SUPABASE_URL", defaultValue: "NOT_FOUND");
  await Supabase.initialize(
    url: url,
    anonKey: env,
  );
}

Future<AuthResponse> signInWithGoogle() async {
  const iosClientId =
      '655506060476-pf2e826uh56uocv47r2br0n0ugf4mtvl.apps.googleusercontent.com';

  final GoogleSignIn signIn = GoogleSignIn.instance;

  unawaited(
    signIn.initialize(clientId: iosClientId),
  );

  // Perform the sign in
  final googleAccount = await signIn.authenticate();
  final googleAuthorization =
      await googleAccount.authorizationClient.authorizationForScopes([]);
  final googleAuthentication = googleAccount.authentication;
  final idToken = googleAuthentication.idToken;
  final accessToken = googleAuthorization!.accessToken;

  if (idToken == null) {
    throw 'No ID Token found.';
  }

  return await supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
}

Future<void> signInWithApple() async {
  try {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo:
          kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
    );
  } catch (e) {
    print('Error signing in with Apple: $e');
  }
}

Future<void> signInWithEmail({
  required String email,
  required String password,
}) async {
  final AuthResponse response = await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );

  if (response.user == null) {
    throw Exception(
        'Đăng nhập không thành công: Không có thông tin người dùng.');
  }
}

Future<void> signOut() async {
  await supabase.auth.signOut();
}

User? get currentUser => supabase.auth.currentUser;
