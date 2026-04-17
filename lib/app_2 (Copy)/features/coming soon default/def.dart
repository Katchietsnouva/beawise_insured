import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';

class StatementScreen extends StatelessWidget {
  const StatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Statement', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.assignment, size: 64, color: Colors.white70),
              SizedBox(height: 16),
              Text(
                '...  Module',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text('Coming soon...', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
