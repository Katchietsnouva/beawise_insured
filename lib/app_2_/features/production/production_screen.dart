import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Production', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.factory,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(height: 16),
              CustomText('Production Module', type: CustomTextType.subHeader),
              SizedBox(height: 8),
              CustomText('Coming soon...', type: CustomTextType.paragraph),
            ],
          ),
        ),
      ),
    );
  }
}
