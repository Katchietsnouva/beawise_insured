import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/features/dashboard/widgets/summary_stat_card.dart';
import 'package:insured/app_2/features/dashboard/widgets/summary_stat_h_policy_financial_modal.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:insured/app_2/providers/dashboard_provider.dart';

class SummaryStatCardHeader extends ConsumerStatefulWidget {
  const SummaryStatCardHeader({super.key});

  @override
  ConsumerState<SummaryStatCardHeader> createState() =>
      _SummaryStatCardHeaderState();
}

class _SummaryStatCardHeaderState extends ConsumerState<SummaryStatCardHeader> {
  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final isMobile = Responsive.isMobile(context);
    final viewMode = ref.watch(clientViewModeProvider);
    return dashboardAsync.when(
      data: (data) {
        if (data.numberOfClients == 0 &&
            data.quotes == 0 &&
            data.renewalsDue == 0 &&
            data.policies.count == 0) {
          return const SizedBox.shrink();
        }

        final policies = data.policies;

        final clientCard = CardAnimationLayout(
          index: 1,
          bounceX: true,
          child: SummaryStatCard(
            title: 'Total Clients',
            value: data.numberOfClients.toString(),
            color: Colors.blue,
            icon: Icons.people,
            onTap: () => context.go('/clients'),
          ),
        );

        final quoteCard = CardAnimationLayout(
          index: 2,
          bounceX: true,
          child: SummaryStatCard(
            title: 'Quotes',
            value: data.quotes.toString(),
            color: Colors.orange,
            icon: Icons.description,
            onTap: () => context.go('/quotes'),
          ),
        );

        final renewalsCard = CardAnimationLayout(
          index: 3,
          bounceX: true,
          child: SummaryStatCard(
            title: 'Renewals Due',
            value: data.renewalsDue.toString(),
            color: Colors.green,
            icon: Icons.update,
            onTap: () => context.go('/renewals'),
          ),
        );

        final productionCard = CardAnimationLayout(
          index: 4,
          bounceX: true,
          child: SummaryStatCard(
            title: 'Production',
            value: policies.count.toString(),
            color: Colors.purple,
            icon: Icons.policy,
            subValues: {
              'BAL': 'KES ${policies.balance}',
              'COMM': '${data.commission}',
            },
            // subValue: 'BAL: KES ${policies.balance} ',
            // subValue: 'BAL: KES ${policies.balance} | COMM: ${data.commission}',
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => PolicyFinancialModal(
                  policyCount: policies.count,
                  grossPremium: policies.grossPremium,
                  receipted: policies.receipted,
                  balance: policies.balance,
                  commission: data.commission,
                  onViewAll: () => context.go('/policies'),
                ),
              );
            },
          ),
        );

        Widget topRow = Row(
          children: [
            Expanded(child: clientCard),
            const SizedBox(width: 16),
            Expanded(child: quoteCard),
          ],
        );
        Widget bottomRow = Row(
          children: [
            Expanded(child: renewalsCard),
            const SizedBox(width: 16),
            Expanded(child: productionCard),
          ],
        );
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () => ref.invalidate(dashboardDataProvider),
                tooltip: 'Refresh dashboard',
              ),
              // const SizedBox(height: 8),
              isMobile
                  ? Column(
                      children: [topRow, const SizedBox(height: 16), bottomRow],
                    )
                  : Row(
                      children: [
                        Expanded(child: topRow),
                        const SizedBox(width: 16),
                        Expanded(child: bottomRow),
                      ],
                    ),
            ],
          ),
        );
      },
      loading: () => buildGhostList(viewMode, context),

      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Failed to load dashboard',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.invalidate(dashboardDataProvider),
              child: const CustomText('Retry', type: CustomTextType.caption),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGhostList(ClientViewMode viewMode, BuildContext context) {
    const int ghostCount = 4;

    // if (viewMode == ClientViewMode.list) {
    //   return ListView.separated(
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    //     itemCount: ghostCount,
    //     separatorBuilder: (_, __) => const SizedBox(height: 12),
    //     itemBuilder: (ctx, i) =>
    //         CardAnimationLayout(index: i, child: const GhostCard()),
    //   );
    // } else {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
        childAspectRatio: Responsive.isMobile(context) ? 1.4 : 2.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: ghostCount,
      itemBuilder: (ctx, i) =>
          CardAnimationLayout(index: i, child: const GhostCard()),
    );
    // }
  }
}

//     return Padding(
//       padding: const EdgeInsets.only(right: 20.0),
//       child: Container(
//         child: (!isMobile)
//             ? Column(children: [topRow, const SizedBox(height: 16), bottomRow])
//             : Row(
//                 children: [
//                   Expanded(child: topRow),
//                   const SizedBox(width: 16),
//                   Expanded(child: bottomRow),
//                 ],
//               ),
//       ),
//     );
//   }
// }
