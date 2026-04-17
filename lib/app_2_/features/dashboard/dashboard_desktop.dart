import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_spinner.dart';
import 'package:insured/app_2/core/widgets/custom_super_tab_bar.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/features/clients/add_client_screen.dart';
import 'package:insured/app_2/features/dashboard/widgets/certificate_card.dart';
import 'package:insured/app_2/features/dashboard/widgets/summary_stat_header.dart';
import 'package:insured/app_2/features/dashboard/widgets/quick_actions_row.dart';
import 'package:insured/app_2/features/dashboard/widgets/client_card.dart';
import 'package:insured/app_2/features/renewals/widgets/renewal_card.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:insured/app_2/providers/dashboard_provider.dart';
import 'package:insured/app_2/providers/settings_provider.dart';
import 'package:insured/app_2/providers/view_provideers/policy_view_provider.dart';
import 'package:intl/intl.dart';

class DashboardDesktop extends ConsumerStatefulWidget {
  const DashboardDesktop({super.key});

  @override
  ConsumerState<DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends ConsumerState<DashboardDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      final currentMode = ref.read(clientViewModeProvider);
      final desiredMode = settings.defaultView == 'Card View'
          ? ClientViewMode.grid
          : ClientViewMode.list;
      if (currentMode != desiredMode) {
        ref.read(clientViewModeProvider.notifier).update((_) => desiredMode);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleNewClient(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<(bool, Map<String, dynamic>)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddClientModal(),
    );

    if (result != null) {
      final (success, _) = result;
      if (success) {
        ref.invalidate(dashboardDataProvider);
        ref.read(clientsPaginationProvider.notifier).refreshAllAndReset();
        ref.invalidate(dashboardRecentClientsProvider);
        // FuturisticToastS.show(
        //   context: context,
        //   message: 'Client list refreshed successfully!',
        //   icon: Icons.check_circle,
        //   alignment: Alignment.topCenter,
        // );
      }
    }
  }

  void _handleViewQuotes(BuildContext context) {
    print('View Quotes tapped');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => MotorQuoteScreen()),
    // );
    context.go('/quotes');
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isLight = settings.themeMode == 'Light';
    // final viewMode = ref.watch(clientViewModeProvider);

    final renewalsViewMode = ref.watch(renewalsDashboardViewModeProvider);
    final certificatesViewMode = ref.watch(
      certificatesDashboardViewModeProvider,
    );

    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onSurface,
        onRefresh: () async {
          // Invalidate all relevant providers to refresh the data
          ref.invalidate(dashboardDataProvider);
          ref.refresh(dashboardRecentClientsProvider);
          ref.refresh(dashboardRecentRenewalsProvider);
          ref.refresh(dashboardRecentCertificatesProvider);
        },

        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 2.0 : 16,
          ),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate.fixed([
                  // const SizedBox(height: 2),
                  SummaryStatCardHeader(),
                  const SizedBox(height: 24),
                  QuickActionsRow(
                    onNewClient: () => _handleNewClient(context, ref),
                    // onViewQuotes: () => context.go('/motor/quote'),
                    onViewQuotes: () => context.go('/motor/quote'),
                  ),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildTabSwitcher(context),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),

              if (_selectedTabIndex == 0) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    title: 'Renewals Due',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!Responsive.isMobile(context))
                          IconButton(
                            icon: Icon(
                              renewalsViewMode == ClientViewMode.list
                                  ? Icons.grid_view
                                  : Icons.view_list,
                            ),
                            onPressed: () {
                              ref
                                  .read(
                                    renewalsDashboardViewModeProvider.notifier,
                                  )
                                  .update(
                                    (mode) => mode == ClientViewMode.list
                                        ? ClientViewMode.grid
                                        : ClientViewMode.list,
                                  );
                            },
                          ),
                        IconButton(
                          // icon: const Icon(Icons.refresh),
                          icon:
                              ref
                                  .watch(dashboardRecentRenewalsProvider)
                                  .isRefreshing
                              ? CustomSpinner()
                              : const Icon(Icons.refresh),
                          onPressed: () =>
                              ref.refresh(dashboardRecentRenewalsProvider),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildRecentRenewalsSliver(context, ref, renewalsViewMode),
              ] else if (_selectedTabIndex == 1) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    // title: 'Recent Clients',
                    title: 'Recent Clients',

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () =>
                              ref.refresh(dashboardRecentClientsProvider),
                        ),
                        IconButton(
                          icon: Icon(
                            renewalsViewMode == ClientViewMode.list
                                ? Icons.grid_view
                                : Icons.view_list,
                          ),
                          onPressed: () {
                            ref
                                .read(clientViewModeProvider.notifier)
                                .update(
                                  (state) => state == ClientViewMode.list
                                      ? ClientViewMode.grid
                                      : ClientViewMode.list,
                                );
                          },
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: Responsive.isMobile(context) ? 150 : 250,
                          child: CustomTextField(
                            hint: 'Search...',
                            icon: Icons.search,
                            controller: _searchController,
                            isSearchField: true,
                            onSearchChanged: (query) => setState(
                              () => _searchQuery = query.toLowerCase(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildRecentClientsSliver(context, ref),

                // ],
                // ] else ...[
              ] else if (_selectedTabIndex == 2) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    title: 'Recent Certificates',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!Responsive.isMobile(context))
                          IconButton(
                            icon: Icon(
                              certificatesViewMode == ClientViewMode.list
                                  ? Icons.grid_view
                                  : Icons.view_list,
                            ),
                            onPressed: () {
                              ref
                                  .read(
                                    certificatesDashboardViewModeProvider
                                        .notifier,
                                  )
                                  .update(
                                    (mode) => mode == ClientViewMode.list
                                        ? ClientViewMode.grid
                                        : ClientViewMode.list,
                                  );
                            },
                          ),
                        IconButton(
                          icon:
                              ref
                                  .watch(dashboardRecentCertificatesProvider)
                                  .isRefreshing
                              ? CustomSpinner()
                              : const Icon(Icons.refresh),
                          onPressed: () =>
                              ref.refresh(dashboardRecentCertificatesProvider),
                        ),
                      ],
                    ),
                  ),
                ),

                _buildRecentCertificatesSliver(
                  context,
                  ref,
                  certificatesViewMode,
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
              // SliverToBoxAdapter(child: _companyogo()),
              // const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => _handleNewClient(context, ref),
        onPressed: () => _handleViewQuotes(context),
        elevation: 20,
        backgroundColor: Theme.of(
          context,
        ).primaryColor.withOpacity(isLight ? 1 : 0.25),
        child: Icon(
          Icons.receipt_long,
          size: 32,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildTabSwitcher(BuildContext context) {
    return CustomSuperTabBar(
      tabs: const [
        SuperTabItem(label: 'Renewals Due', icon: Icons.history, index: 0),
        SuperTabItem(
          label: 'Certificate extensions',
          icon: Icons.people_outline,
          index: 2,
        ),
        // SuperTabItem( label: 'Recent Clients', icon: Icons.description, index: 1,),
      ],
      mode: SuperTabBarMode.ColorModeA,
      selectedIndex: _selectedTabIndex,
      onTap: (value) => setState(() => _selectedTabIndex = value),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              title,
              type: CustomTextType.subHeader,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildRecentRenewalsSliver(
    BuildContext context,
    WidgetRef ref,
    ClientViewMode viewMode,
  ) {
    final recentRenewalsAsync = ref.watch(dashboardRecentRenewalsProvider);
    return recentRenewalsAsync.when(
      data: (renewals) {
        if (renewals.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CustomText(
                'No recent renewals',
                type: CustomTextType.paragraph,
              ),
            ),
          );
        }

        Padding itemBuilder(BuildContext ctx, int i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardAnimationLayout(
            index: i,
            bounce: true,
            child: RenewalCard(
              viewMode: viewMode,
              entry: renewals[i],
              index: i,
              currency: NumberFormat.currency(locale: 'en_US', symbol: 'KES '),
              onTap: () => context.push('/renewal-detail', extra: renewals[i]),
            ),
          ),
        );

        if (viewMode == ClientViewMode.list) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: renewals.length,
            ),
          );
        } else {
          // return SliverGrid(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
          //     childAspectRatio: Responsive.isMobile(context) ? 0.9 : 1.1,
          //     crossAxisSpacing: 12,
          //     mainAxisSpacing: 12,
          //   ),
          //   delegate: SliverChildBuilderDelegate(
          //     itemBuilder,
          //     childCount: renewals.length,
          //   ),
          // );
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: Responsive.isMobile(context)
                  ? 2
                  : Responsive.isTablet(context)
                  ? 2
                  : Responsive.isDesktop(context)
                  ? 3
                  : 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childCount: renewals.length,
              itemBuilder: (ctx, i) => itemBuilder(ctx, i),
            ),
          );
        }
      },
      loading: () => _buildGhostSliver(),
      error: (err, _) =>
          SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildRecentClientsSliver(BuildContext context, WidgetRef ref) {
    final recentClientsAsync = ref.watch(dashboardRecentClientsProvider);
    final viewMode = ref.watch(clientViewModeProvider);

    return recentClientsAsync.when(
      data: (clients) {
        final filteredClients = clients.where((client) {
          return client.name.toLowerCase().contains(_searchQuery) ||
              (client.email?.toLowerCase().contains(_searchQuery) ?? false);
        }).toList();

        if (filteredClients.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CustomText(
                'No clients found',
                type: CustomTextType.paragraph,
              ),
            ),
          );
        }

        if (viewMode == ClientViewMode.list) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 4,
                  right: 16,
                  bottom: 12,
                ),
                child: CardAnimationLayout(
                  index: i,
                  bounce: true,
                  bounceX: true,
                  child: ClientCard(
                    client: filteredClients[i],
                    viewMode: viewMode,
                  ),
                ),
              ),
              childCount: filteredClients.length,
            ),
          );
        } else {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
              childAspectRatio: Responsive.isMobile(context) ? 0.9 : 2.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 4,
                  right: 16,
                  bottom: 12,
                ),
                child: CardAnimationLayout(
                  index: i,
                  bounce: true,
                  bounceX: true,
                  child: ClientCard(
                    client: filteredClients[i],
                    viewMode: viewMode,
                  ),
                ),
              ),
              childCount: filteredClients.length,
            ),
          );
        }
      },
      loading: () => _buildGhostSliver(),
      error: (err, _) =>
          SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildRecentCertificatesSliver(
    BuildContext context,
    WidgetRef ref,
    ClientViewMode certificatesViewMode,
  ) {
    final recentCertsAsync = ref.watch(dashboardRecentCertificatesProvider);
    return recentCertsAsync.when(
      data: (certs) {
        if (certs.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CustomText(
                'No recent certificates',
                type: CustomTextType.paragraph,
              ),
            ),
          );
        }

        Padding itemBuilder(BuildContext ctx, int i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardAnimationLayout(
            index: i,
            bounce: true,
            child: CertificateCard(
              authState: ref.read(authProvider),

              viewMode: certificatesViewMode,
              cert: certs[i],
              onTap: () => context.push('/certificate-detail', extra: certs[i]),
            ),
          ),
        );

        if (certificatesViewMode == ClientViewMode.list) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: certs.length,
            ),
          );
        } else {
          // return SliverGrid(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
          //     childAspectRatio: Responsive.isMobile(context) ? 0.9 : 1.1,
          //     crossAxisSpacing: 12,
          //     mainAxisSpacing: 12,
          //   ),
          //   delegate: SliverChildBuilderDelegate(
          //     itemBuilder,
          //     childCount: certs.length,
          //   ),
          // );
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: Responsive.isMobile(context)
                  ? 2
                  : Responsive.isTablet(context)
                  ? 2
                  : Responsive.isDesktop(context)
                  ? 3
                  : 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childCount: certs.length,
              itemBuilder: (ctx, i) => itemBuilder(ctx, i),
            ),
          );
        }
      },
      loading: () => _buildGhostSliver(),
      error: (err, _) =>
          SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildGhostSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => CardAnimationLayout(
          index: i,
          bounce: true,
          bounceX: true,
          child: const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: GhostCard(),
          ),
        ),
        childCount: 3,
      ),
    );
  }

  Widget _companyogo() {
    final String pathPrefix = (kIsWeb && kDebugMode) ? '' : 'assets';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.7,
              child: CustomText("Powered by:", type: CustomTextType.caption),
            ),
            SizedBox(width: 10),
            Image(
              // image: AssetImage('${pathPrefix}/images/Insured.png'),
              image: AssetImage(
                '${pathPrefix}/images/${Theme.of(context).brightness == Brightness.dark ? 'inscloud' : 'inscloud'}.png',
              ),
              // height: 80,
              width: 150,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
