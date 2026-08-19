import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/features/clients/add_client_screen.dart';
import 'package:insured/app_2/features/dashboard/recents.dart';
import 'package:insured/app_2/features/dashboard/widgets/hamburger_drawer.dart';
import 'package:insured/app_2/features/dashboard/widgets/top_header.dart';
import 'package:insured/app_2/features/dashboard/widgets/quick_actions_row.dart';
import 'package:insured/app_2/features/dashboard/widgets/summary_stat_card.dart';
import 'package:insured/app_2/features/dashboard/widgets/client_card.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/features/motor/motor_quote_screen.dart';
import 'package:insured/app_2/features/quotes_old/quotes_screen.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';

class DashboardMobile extends ConsumerWidget {
  DashboardMobile({super.key});

  void _handleNewClient(BuildContext context, WidgetRef ref) async {
    print('New Client tapped');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => const AddClientScreen()),
    // );
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddClientModal(),
    );

    if (result == true) {
      ref.read(clientsPaginationProvider.notifier).refreshCurrentPage();
      FuturisticToastS.show(
        context: context,
        message: 'Client list refreshed successfully!',
        icon: Icons.check_circle,
        alignment: Alignment.topCenter,
      );
    }
  }

  void _handleViewQuotes(BuildContext context) {
    print('View Quotes tapped');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => MotorQuoteScreen()),
    // );
    context.push('/motor/quote');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      // drawer: const HamburgerDrawer(),
      // appBar: AppBar(
      //   // backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   actions: [
      //     IconButton(icon: const Icon(Icons.person_add), onPressed: () {}),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Summary Cards in 2x2 grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: const [
                SummaryStatCard(
                  title: 'Total Clients',
                  value: '128',
                  color: Colors.blue,
                  icon: Icons.people,
                ),
                SummaryStatCard(
                  title: 'Total Quotes',
                  value: '342',
                  color: Colors.orange,
                  icon: Icons.description,
                ),
                SummaryStatCard(
                  title: 'Accepted',
                  value: '210',
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                SummaryStatCard(
                  title: 'Pending',
                  value: '132',
                  color: Colors.purple,
                  icon: Icons.pending,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // const QuickActionsRow(),
            QuickActionsRow(
              onNewClient: () => _handleNewClient(context, ref),
              onViewQuotes: () => _handleViewQuotes(context),
            ),
            const SizedBox(height: 32),
            const Text(
              'Recent Clients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search clients...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentClients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) => ClientCard(client: recentClients[i]),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, right: 24.0),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AddClientModal(),
            );

            if (result == true) {
              ref.read(clientsPaginationProvider.notifier).refreshCurrentPage();
            }
          },
          backgroundColor: const Color(0xFF00FFB2).withOpacity(0.1),
          child: const Icon(Icons.add, color: Color(0xFF00FFB2)),
        ),
      ),
    );
  }
}
