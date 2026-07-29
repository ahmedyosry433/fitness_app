import 'package:flutter/material.dart';

class AiAgentPage extends StatelessWidget {
  const AiAgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Text(
          'Smart coach',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
