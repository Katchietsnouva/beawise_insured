import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';

final policiesViewModeProvider = StateProvider<ClientViewMode>(
  (ref) => ClientViewMode.list,
);
final quotesViewModeProvider = StateProvider<ClientViewMode>(
  (ref) => ClientViewMode.list,
);
final productionViewModeProvider = StateProvider<ClientViewMode>(
  (ref) => ClientViewMode.list,
);
final certificatesViewModeProvider = StateProvider<ClientViewMode>(
  (ref) => ClientViewMode.list,
);
final renewalsViewModeProvider = StateProvider<ClientViewMode>(
  (ref) => ClientViewMode.list,
);

final renewalsDashboardViewModeProvider = StateProvider<ClientViewMode>(
  (ref) => ClientViewMode.list,
);
final certificatesDashboardViewModeProvider = StateProvider<ClientViewMode>(
  (ref) => ClientViewMode.list,
);
