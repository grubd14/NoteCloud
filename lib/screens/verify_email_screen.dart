import 'package:flutter/material.dart';
import 'package:note_cloud/auth/auth_service.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Verify your Email Address'),
          ),
          const Center(
            child: Text(
                """Verify your email address my pressing the button below if you haven't received the email yet!"""),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                await AuthService.firebase().sendVerificationEmail();
              },
              child: const Text('Verify Email'),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
              },
              child: const Text('Restart the firebase instance'),
            ),
          )
        ],
      ),
    );
  }
}
