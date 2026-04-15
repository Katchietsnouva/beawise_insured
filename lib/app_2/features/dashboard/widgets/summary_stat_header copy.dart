
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/features/dashboard/widgets/summary_stat_card.dart';
import 'package:insured/app_2/features/dashboard/widgets/summary_stat_h_policy_financial_modal.dart';
import 'package:insured/app_2/providers/dashboard_provider.dart';
//


import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
// import '/dashboard_stats.dart';


class SummaryStatCardHeader extends ConsumerWidget {
  const SummaryStatCardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final isDesktop = Responsive.isDesktop(context);

    return dashboardAsync.when(
      loading: () => _buildLoadingState(isDesktop),
      error: (err, _) => Center(
        child: Text("Error loading stats", style: TextStyle(color: Colors.red)),
      ),
      data: (stats) {
        final cards = [
          SummaryStatCard(
            title: 'CLIENTS',
            value: '${stats.numberOfClients}',
            color: const Color(0xFF00FFB2),
            icon: Icons.people_outline,
            onTap: () => context.go('/clients'),
          ),
          SummaryStatCard(
            title: 'QUOTES',
            value: '${stats.quotes}',
            color: Colors.orange,
            icon: Icons.request_quote_outlined,
            onTap: () => context.go('/motor/quote'),
          ),
          SummaryStatCard(
            title: 'RENEWALS',
            value: '${stats.renewalsDue}',
            color: Colors.blue,
            icon: Icons.autorenew,
            onTap: () => context.go('/renewals'),
          ),
          SummaryStatCard(
            title: 'POLICIES',
            value: '${stats.policies.count}',
            subValue:
                'BAL: KES ${stats.policies.balance.toStringAsFixed(0)} | COMM: ${stats.commission}',
            color: Colors.purpleAccent,
            icon: Icons.shield_outlined,
            onTap: () => context.go('/policies'),
          ),
        ];

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: isDesktop
                  ? Row(
                      children: cards
                          .map(
                            (c) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: c,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.4,
                      children: cards,
                    ),
            ),
            // Artistic Refresh Button
            Positioned(
              top: -5,
              right: 0,
              child: IconButton(
                onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
                icon: const Icon(
                  Icons.sync,
                  color: Color(0xFF00FFB2),
                  size: 18,
                ),
                tooltip: "Sync Dashboard",
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState(bool isDesktop) {
    return Row(
      children: List.generate(
        4,
        (i) => const Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: GhostCard(),
          ),
        ),
      ),
    );
  }
}




final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardStats>(() {
  return DashboardNotifier();
});

class DashboardNotifier extends AsyncNotifier<DashboardStats> {
  @override
  Future<DashboardStats> build() async {
    return _fetchDashboard();
  }

  Future<DashboardStats> _fetchDashboard() async {
    // Replace with your actual API call / Auth headers
    final response = await http.get(Uri.parse('https://demo.inscloud.net/api/agent/dashboard'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return DashboardStats.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Failed to load dashboard');
    }
    throw Exception('Server Error');
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchDashboard());
  }
}


class DashboardStats {
  final int numberOfClients;
  final int renewalsDue;
  final int quotes;
  final double commission;
  final PolicyStats policies;

  DashboardStats({
    required this.numberOfClients,
    required this.renewalsDue,
    required this.quotes,
    required this.commission,
    required this.policies,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      numberOfClients: json['number_of_clients'] ?? 0,
      renewalsDue: json['renewals_due'] ?? 0,
      quotes: json['quotes'] ?? 0,
      commission: (json['commission'] as num).toDouble(),
      policies: PolicyStats.fromJson(json['policies']),
    );
  }
}

class PolicyStats {
  final int count;
  final double grossPremium;
  final double receipted;
  final double balance;

  PolicyStats({
    required this.count,
    required this.grossPremium,
    required this.receipted,
    required this.balance,
  });

  factory PolicyStats.fromJson(Map<String, dynamic> json) {
    return PolicyStats(
      count: json['count'] ?? 0,
      grossPremium: (json['gross_premium'] as num).toDouble(),
      receipted: (json['receipted'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:insured/app_2/core/utils/responsive.dart';
// import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
// import 'package:insured/app_2/features/dashboard/widgets/summary_stat_card.dart';
// import 'package:insured/app_2/features/dashboard/widgets/summary_stat_h_policy_financial_modal.dart';
// import 'package:insured/app_2/providers/dashboard_provider.dart';

// class SummaryStatCardHeader extends ConsumerStatefulWidget {
//   const SummaryStatCardHeader({super.key});

//   @override
//   ConsumerState<SummaryStatCardHeader> createState() =>
//       _SummaryStatCardHeaderState();
// }

// class _SummaryStatCardHeaderState extends ConsumerState<SummaryStatCardHeader> {
//   @override
//   Widget build(BuildContext context) {
//     final dashboardAsync = ref.watch(dashboardDataProvider);
//     final isMobile = !Responsive.isMobile(context);

//     return dashboardAsync.when(
//       data: (data) {
//         final policies = data.policies;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // Refresh button
//             IconButton(
//               icon: const Icon(Icons.refresh, size: 20),
//               onPressed: () => ref.invalidate(dashboardDataProvider),
//               tooltip: 'Refresh dashboard',
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//             ),
//             const SizedBox(height: 8),
//             // Cards row
//             Row(
//               children: [
//                 Expanded(
//                   child: CardAnimationLayout(
//                     index: 1,
//                     bounceX: true,
//                     child: SummaryStatCard(
//                       title: 'Total Clients',
//                       value: data.numberOfClients.toString(),
//                       color: Colors.blue,
//                       icon: Icons.people,
//                       onTap: () => context.go('/clients'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: CardAnimationLayout(
//                     index: 2,
//                     bounceX: true,
//                     child: SummaryStatCard(
//                       title: 'Quotes',
//                       value: data.quotes.toString(),
//                       color: Colors.orange,
//                       icon: Icons.description,
//                       onTap: () => context.go('/quotes'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: CardAnimationLayout(
//                     index: 3,
//                     bounceX: true,
//                     child: SummaryStatCard(
//                       title: 'Renewals Due',
//                       value: data.renewalsDue.toString(),
//                       color: Colors.green,
//                       icon: Icons.update,
//                       onTap: () => context.go('/renewals'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: CardAnimationLayout(
//                     index: 4,
//                     bounceX: true,
//                     child: SummaryStatCard(
//                       title: 'Policies',
//                       value: policies.count.toString(),
//                       color: Colors.purple,
//                       icon: Icons.policy,
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (ctx) => PolicyFinancialModal(
//                             policyCount: policies.count,
//                             grossPremium: policies.grossPremium,
//                             receipted: policies.receipted,
//                             balance: policies.balance,
//                             commission: data.commission,
//                             onViewAll: () => context.go('/policies'),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Failed to load dashboard',
//               style: TextStyle(color: Colors.red),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => ref.invalidate(dashboardDataProvider),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:insured/app_2/core/utils/responsive.dart';
// // // import 'package:insured/app_2/core/utils/responsive_font_helper.dart';
// // import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
// // import 'package:insured/app_2/features/dashboard/widgets/summary_stat_card.dart';

// // class SummaryStatCardHeader extends StatefulWidget {
// //   const SummaryStatCardHeader({super.key});

// //   @override
// //   State<SummaryStatCardHeader> createState() => _SummaryStatCardHeaderState();
// // }

// // class _SummaryStatCardHeaderState extends State<SummaryStatCardHeader> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final isMobile = (!Responsive.isMobile(context));
// //     Widget topRow = Row(
// //       children: [
// //         Expanded(
// //           child: CardAnimationLayout(
// //             index: 1,
// //             bounceX: true,
// //             child: SummaryStatCard(
// //               title: 'Total Clients',
// //               value: '128',
// //               color: Colors.blue,
// //               icon: Icons.people,
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: 16),
// //         Expanded(
// //           child: CardAnimationLayout(
// //             index: 2,
// //             bounceX: true,
// //             child: SummaryStatCard(
// //               title: 'Total Quotes',
// //               value: '342',
// //               color: Colors.orange,
// //               icon: Icons.description,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );

// //     Widget bottomRow = Row(
// //       children: [
// //         Expanded(
// //           child: CardAnimationLayout(
// //             index: 3,
// //             bounceX: true,
// //             child: SummaryStatCard(
// //               title: 'Total Renewals due',
// //               value: '210',
// //               color: Colors.green,
// //               icon: Icons.check_circle,
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: 16),
// //         Expanded(
// //           child: CardAnimationLayout(
// //             index: 4,
// //             bounceX: true,
// //             child: SummaryStatCard(
// //               title: 'Policies',
// //               value: '132',
// //               color: Colors.purple,
// //               icon: Icons.pending,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );

// //     return Padding(
// //       padding: const EdgeInsets.only(right: 20.0),
// //       child: Container(
// //         child: (!isMobile)
// //             ? Column(children: [topRow, const SizedBox(height: 16), bottomRow])
// //             : Row(
// //                 children: [
// //                   Expanded(child: topRow),
// //                   const SizedBox(width: 16),
// //                   Expanded(child: bottomRow),
// //                 ],
// //               ),
// //       ),
// //     );
// //   }
// // }
