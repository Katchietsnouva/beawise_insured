import 'package:flutter/material.dart';
import '../constants/app_dimens.dart';
import '../constants/app_colors.dart';

enum SocialProvider { google, apple }

class SocialButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  IconData get _icon {
    switch (provider) {
      case SocialProvider.google:
        return Icons
            .g_mobiledata; // Placeholder – use actual Google icon asset later
      case SocialProvider.apple:
        return Icons.apple;
    }
  }

  String get _label {
    switch (provider) {
      case SocialProvider.google:
        return 'Sign in Google';
      case SocialProvider.apple:
        return 'Sign in Apple';
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(_icon, color: Colors.white),
      label: Text(_label),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.glassBorder),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(AppDimens.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
      ),
    );
  }
}
