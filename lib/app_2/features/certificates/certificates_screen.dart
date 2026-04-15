import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_error_refresh_placeholder_adv.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/core/widgets/cust_date_range_filter.dart';
import 'package:insured/app_2/features/dashboard/widgets/certificate_card.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
// import 'package:insured/app_2/features/certificates/widgets/certificate_card.dart';
import 'package:insured/app_2/providers/certificate_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:intl/intl.dart';

class CertificatesScreen extends ConsumerStatefulWidget {
  final StateProvider<ClientViewMode> viewModeProvider;

  const CertificatesScreen({super.key, required this.viewModeProvider});

  @override
  ConsumerState<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends ConsumerState<CertificatesScreen> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _initDatesFromState();
  }

  void _initDatesFromState() {
    final state = ref.read(certificateProvider);
    try {
      _startDate = DateTime.parse(state.startDate);
      _endDate = DateTime.parse(state.endDate);
    } catch (_) {
      final now = DateTime.now();
      // _startDate = DateTime(now.year, now.month, 1);
      // _endDate = DateTime(now.year, now.month + 3, now.day);

      _startDate = DateTime(now.year, now.month, 1);
      _endDate = DateTime(now.year, now.month + 2, 0);
      // _endDate = DateTime(now.year, now.month + 2, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(certificateProvider);
    final notifier = ref.read(certificateProvider.notifier);
    final viewMode = ref.watch(widget.viewModeProvider);

    Widget _buildGhostSliver() {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => CardAnimationLayout(
            index: i,
            bounce: true,
            // bounceX: true,
            animateOnce: true,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: GhostCard(),
            ),
          ),
          childCount: 6,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            left: Responsive.isMobile(context) ? 10 : 20,
          ),
          child: _buildFilterBar(),
        ),
        elevation: 0,
        leadingWidth: 0,
        titleSpacing: 0,
        actions: [
          if (!Responsive.isMobile(context))
            IconButton(
              icon: Icon(
                viewMode == ClientViewMode.list
                    ? Icons.grid_view
                    : Icons.view_list,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                print("YOOoooo oressed");
                ref
                    // .read(certificatesViewModeProvider.notifier)
                    .read(widget.viewModeProvider.notifier)
                    .update(
                      (mode) => mode == ClientViewMode.list
                          ? ClientViewMode.grid
                          : ClientViewMode.list,
                    );
              },
            ),

          if (!Responsive.isMobile(context))
            Padding(
              padding: EdgeInsets.only(
                right: Responsive.isMobile(context) ? 10 : 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.black,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF00FFB2)),
                      onPressed: () => notifier.refreshCurrentPage(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      // body: Column(
      //   children: [
      //     _buildPaginationControls(state, notifier),
      //     Expanded(
      //       child: state.isLoading
      //           // && state.response == null
      //           ?
      //             // const Center(child: CircularProgressIndicator())
      //             CustomScrollView(
      //               slivers: [
      //                 SliverPadding(
      //                   padding: const EdgeInsets.all(20.0),
      //                   sliver: _buildGhostSliver(),
      //                 ),
      //               ],
      //             )
      //           : state.error != null && state.response == null
      //           ? CustomErrorRefreshPlaceholder(
      //               details: state.error,
      //               onRetry: () => notifier.refreshCurrentPage(),
      //             )
      //           : state.response?.certificates.isEmpty ?? true
      //           ? CustomErrorRefreshPlaceholder(
      //               message: 'No certificates found',
      //               icon: Icons.search_off,
      //               color: Theme.of(context).colorScheme.onSurface,
      //               details: state.response?.message,
      //               onRetry: () => notifier.refreshCurrentPage(),
      //             )
      //           // : _buildCertificateList(state),
      //           : _buildCertificateList(state, viewMode),
      //     ),
      //     // _buildBottomNav(state, notifier),
      //   ],
      // ),
      body: Column(
        children: [
          if (!Responsive.isMobile(context))
            _buildPaginationControls(state, notifier),
          Expanded(
            child: RefreshIndicator(
              color: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onRefresh: () async {
                await notifier
                    .refreshCurrentPage(); // or refreshAllAndReset() if you have it
              },
              child: state.isLoading && state.response == null
                  ? CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(20.0),
                          sliver: _buildGhostSliver(),
                        ),
                      ],
                    )
                  : state.error != null && state.response == null
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: CustomErrorRefreshPlaceholder(
                          details: state.error,
                          onRetry: () => notifier.refreshCurrentPage(),
                        ),
                      ),
                    )
                  : state.response?.certificates.isEmpty ?? true
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: CustomErrorRefreshPlaceholder(
                          message: 'No certificates found',
                          icon: Icons.search_off,
                          color: Theme.of(context).colorScheme.onSurface,
                          details: state.response?.message,
                          onRetry: () => notifier.refreshCurrentPage(),
                        ),
                      ),
                    )
                  : _buildCertificateList(state, viewMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return DateRangeFilter(
      initialStart: _startDate!,
      initialEnd: _endDate!,
      compact: Responsive.isMobile(context),
      labelPrefix: "Showing For:",
      onRangeSelected: (start, end) {
        setState(() {
          _startDate = start;
          _endDate = end;
        });
        ref
            .read(certificateProvider.notifier)
            .setDateRange(
              start: start.toIso8601String().split('T')[0],
              end: end.toIso8601String().split('T')[0],
            );
      },
    );
  }

  Widget _buildPaginationControls(
    CertificateState state,
    CertificateNotifier notifier,
  ) {
    final pagination = state.response?.pagination;
    if (pagination == null) return const SizedBox();

    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 10 : 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 140,
            child: CustomDropdown<int>(
              // 'Items per page: ',
              hint: '',
              icon: Icons.format_list_numbered,
              value: state.perPage,
              items: [5, 10, 20, 50, 100].map((v) {
                // return DropdownMenuItem<int>(value: v, child: CustomText('$v'));
                return DropdownMenuItem<int>(
                  value: v,
                  child: Text(v.toString()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) notifier.setPerPage(val);
              },
            ),
          ),

          Row(
            children: [
              CustomText(
                '${pagination.currentPage} of ${pagination.lastPage}',
                type: CustomTextType.paragraph,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: pagination.currentPage > 1
                    ? () => notifier.previousPage()
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: pagination.currentPage < pagination.lastPage
                    ? () => notifier.nextPage()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildCertificateList(CertificateState state) {
  Widget _buildCertificateList(
    CertificateState state,
    ClientViewMode viewMode,
  ) {
    final certs = state.response!.certificates;
    if (viewMode == ClientViewMode.list) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 10 : 20,
        ),
        itemCount: certs.length,
        itemBuilder: (ctx, i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          // child: _buildCertificateCard(certs[i]),
          child: CertificateCard(
            authState: ref.read(authProvider),

            viewMode: viewMode,
            cert: certs[i],
            onTap: () => context.push('/certificate-detail', extra: certs[i]),
          ),
        ),
      );
    } else {
      return MasonryGridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: Responsive.isMobile(context)
            ? 2
            : Responsive.isTablet(context)
            ? 2
            : Responsive.isDesktop(context)
            ? 3
            : 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: certs.length,
        itemBuilder: (ctx, i) => CardAnimationLayout(
          index: i,
          bounce: true,
          child: CertificateCard(
            authState: ref.read(authProvider),

            viewMode: viewMode,
            cert: certs[i],
            onTap: () => context.push('/certificate-detail', extra: certs[i]),
          ),
        ),
      );
    }
  }

  Widget _buildBottomNav(CertificateState state, CertificateNotifier notifier) {
    final pagination = state.response?.pagination;
    if (pagination == null) return const SizedBox();

    return Container(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navBtn(
            "PREV",
            pagination.currentPage > 1 ? notifier.previousPage : null,
          ),
          CustomText(
            "${pagination.currentPage} / ${pagination.lastPage}",
            type: CustomTextType.caption,
          ),
          _navBtn(
            "NEXT",
            pagination.currentPage < pagination.lastPage
                ? notifier.nextPage
                : null,
          ),
        ],
      ),
    );
  }

  Widget _navBtn(String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: onTap == null
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
              : const Color(0xFF00FFB2),
        ),
      ),
    );
  }
}
