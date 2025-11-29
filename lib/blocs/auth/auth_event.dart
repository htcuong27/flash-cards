part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthCheckRequested extends AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class AuthGoogleLoginRequested extends AuthEvent {}

final class AuthAppleLoginRequested extends AuthEvent {}

final class AuthLogoutRequested extends AuthEvent {}

final class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const AuthSignupRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object> get props => [email, password, fullName];
}

final class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}
