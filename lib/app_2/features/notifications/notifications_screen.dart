import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/api_log.dart';
import 'package:insured/app_2/features/notifications/widgets/notification_card.dart';
import 'package:insured/app_2/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  late PageController _pageController;
  int _selectedFilterIndex = 0; // 0=All, 1=Success, 2=Error
  late final NotificationNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _notifier = ref.read(notificationProvider.notifier);
  }

  @override
  void dispose() {
    // final notifier = ref.read(notificationProvider.notifier);
    // _notifier.markAllAsRead();

    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);

    // Filter and sort logs
    var filteredLogs = state.logs.where((log) {
      if (state.filter == NotificationFilter.success)
        return log.status == 'success';
      if (state.filter == NotificationFilter.error)
        return log.status == 'error';
      return true;
    }).toList();

    if (state.sort == NotificationSort.newestFirst) {
      filteredLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } else {
      filteredLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    final groupedLogs = _groupLogsByDate(filteredLogs);

    return WillPopScope(
      onWillPop: () async {
        notifier.markAllAsRead();
        return true;
      },

      child: Scaffold(
        appBar: AppBar(
          // title: const Text(
          //   'Notifications',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                state.sort == NotificationSort.newestFirst
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
              ),
              onPressed: () {
                notifier.setSort(
                  state.sort == NotificationSort.newestFirst
                      ? NotificationSort.oldestFirst
                      : NotificationSort.newestFirst,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: notifier.markAllAsRead,
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: notifier.clearLogs,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ToggleButtons(
                      isSelected: [
                        state.filter == NotificationFilter.all,
                        state.filter == NotificationFilter.success,
                        state.filter == NotificationFilter.error,
                      ],
                      onPressed: (index) {
                        final filter = [
                          NotificationFilter.all,
                          NotificationFilter.success,
                          NotificationFilter.error,
                        ][index];
                        notifier.setFilter(filter);
                      },
                      borderRadius: BorderRadius.circular(20),
                      selectedColor: Theme.of(context).colorScheme.onSurface,
                      fillColor: Colors.greenAccent.withOpacity(0.6),
                      selectedBorderColor: Colors.greenAccent,
                      borderColor: Theme.of(context).colorScheme.onSurface,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: CustomText(
                            'All',
                            type: CustomTextType.paragraph,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: CustomText(
                            'Success',
                            type: CustomTextType.paragraph,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: CustomText(
                            'Error',
                            type: CustomTextType.paragraph,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: filteredLogs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 64,
                      color: Colors.white24,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: groupedLogs.keys.length,
                itemBuilder: (context, sectionIndex) {
                  final dateKey = groupedLogs.keys.elementAt(sectionIndex);
                  final logsInSection = groupedLogs[dateKey]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          dateKey,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      ...logsInSection.map(
                        (log) => NotificationCard(
                          log: log,
                          onTap: () => notifier.markAsRead(log.id),
                          onDismissed: () => notifier.markAsRead(log.id),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Map<String, List<ApiLog>> _groupLogsByDate(List<ApiLog> logs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));

    final Map<String, List<ApiLog>> grouped = {};

    for (var log in logs) {
      final logDate = DateTime(
        log.timestamp.year,
        log.timestamp.month,
        log.timestamp.day,
      );
      String key;
      if (logDate == today) {
        key = 'Today';
      } else if (logDate == yesterday) {
        key = 'Yesterday';
      } else if (logDate.isAfter(
        thisWeekStart.subtract(const Duration(days: 1)),
      )) {
        key = 'This Week';
      } else {
        key = '${logDate.day}/${logDate.month}/${logDate.year}';
      }
      grouped.putIfAbsent(key, () => []).add(log);
    }

    // Sort sections by date descending (most recent first)
    final orderedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final order = {'Today': 0, 'Yesterday': 1, 'This Week': 2};
        final aOrder = order[a] ?? 3;
        final bOrder = order[b] ?? 3;
        if (aOrder != bOrder) return aOrder.compareTo(bOrder);
        // If both are custom dates, compare by actual date
        if (aOrder == 3 && bOrder == 3) {
          final dateA = _parseDateKey(a);
          final dateB = _parseDateKey(b);
          return dateB.compareTo(dateA);
        }
        return 0;
      });

    final sortedGrouped = <String, List<ApiLog>>{};
    for (var key in orderedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }
    return sortedGrouped;
  }

  DateTime _parseDateKey(String key) {
    // Assumes format 'dd/MM/yyyy'
    final parts = key.split('/');
    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }
    return DateTime.now(); // fallback
  }
}
