import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/features/dashboard/dashboard_desktop.dart';
import 'package:insured/app_2/features/dashboard/dashboard_mobile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return Responsive.isMobile(context)
    // ? DashboardMobile()
    // : DashboardDesktop();
    // }
    return DashboardDesktop();
  }
}
