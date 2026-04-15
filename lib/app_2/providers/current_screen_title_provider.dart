import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/route_observer.dart';

String _titleFromRoute(String route) {
  if (route.startsWith('/dashboard')) return 'Dashboard';
  if (route.startsWith('/clients')) return 'Clients';
  if (route.startsWith('/motor/quote')) return 'Motor Quote';
  if (route.startsWith('/policies')) return 'Policies';
  if (route.startsWith('/dmvic-double-insurance'))
    return 'DMVIC Double Insurance';
  if (route.startsWith('/dmvic-stock')) return 'DMVIC Stock';
  if (route.startsWith('/statement')) return 'Statement';
  if (route.startsWith('/renewals')) return 'Renewals';
  if (route.startsWith('/production')) return 'Production';
  if (route.startsWith('/quotes')) return 'Quotes';
  if (route.startsWith('/settings')) return 'Settings';
  if (route.startsWith('/profile')) return 'My Profile';
  if (route.startsWith('/add-client')) return 'Add Client';
  if (route.startsWith('/notifications')) return 'Notifications';
  if (route.startsWith('/offline-queue')) return 'Offline Queue';
  if (route.startsWith('/certificates')) return 'Certificates';
  return 'Insured';
}

final currentScreenTitleProvider = Provider<String>((ref) {
  final currentRoute = ref.watch(currentRouteProvider);
  return _titleFromRoute(currentRoute);
});
