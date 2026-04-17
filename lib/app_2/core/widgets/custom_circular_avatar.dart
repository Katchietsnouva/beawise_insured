import 'package:flutter/material.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/data/models/user_model.dart';

class CustomCircularAvatar extends StatelessWidget {
  // final User? user;
  final String? user;
  final double? radius;
  final double? fontSize;
  const CustomCircularAvatar({required this.user, this.radius, this.fontSize});

  @override
  Widget build(BuildContext context) {
    String initials = '';
    // if (user?.name != null && user!.name.length >= 2) {
    //   // Get the first two characters, capitalize the first and lowercase the second
    //   initials = user!.name[0].toUpperCase() + user!.name[1].toLowerCase();
    // } else if (user?.name != null && user!.name.isNotEmpty) {
    //   // If the name has only one character, show it capitalized
    //   initials = user!.name[0].toUpperCase();
    // } else {
    //   initials = 'NA'; // F
    //   allback when email is null or empty
    // }

    if (user != null && user!.trim().isNotEmpty) {
      final parts = user!.trim().split(' ');
      if (parts.length >= 2) {
        // initials = parts[0][0].toUpperCase() + parts[1][0].toLowerCase();
        initials = user![0].toUpperCase() + user![1].toLowerCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    } else {
      initials = 'NA';
    }

    return CircleAvatar(
      radius: radius ?? 20,

      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.favColour.withOpacity(0.4)
          : AppColors.favColourDark,
      child: Text(
        initials,
        //  user.email[ 0].toUpperCase() + user.email[1].toLowerCase(),
        // user?.email.length ?? >= 2
        // ? user.email[ 0].toUpperCase() + user.email[1].toLowerCase()
        // : user.email.substring(0, 1).toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
