import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text("This was a demo screen"),
      ),
    );
  }
}
