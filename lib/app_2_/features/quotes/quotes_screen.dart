import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/features/policies/policy_list_screen.dart';
import 'package:insured/app_2/providers/view_provideers/policy_view_provider.dart';

class QuotesScreen extends ConsumerWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PolicyListScreen(
      initialStatus: 0,
      title: "Quotes",
      onCardTap: (entry) {
        context.push('/quote-detail', extra: entry);
        print('QuotesScreen onCardTap');
      },
      viewModeProvider: policiesViewModeProvider,
    );
  }
}
