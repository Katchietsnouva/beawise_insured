import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/features/policies/policy_list_screen.dart';
import 'package:insured/app_2/providers/view_provideers/policy_view_provider.dart';

class PoliciesScreen extends ConsumerWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PolicyListScreen(
      initialStatus: 1,
      title: "Production",
      onCardTap: (entry) {
        context.push('/production-detail', extra: entry);
      },
      viewModeProvider: policiesViewModeProvider,
    );
  }
}
