import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerfied;
  const AuthUser({
    required this.email,
    required this.isEmailVerfied,
  });

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(email: user.email,  isEmailVerfied: user.emailVerified);
}
