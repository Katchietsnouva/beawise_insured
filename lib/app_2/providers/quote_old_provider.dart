import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/data/models/quote_old_model.dart';
import 'package:insured/app_2/data/repositories/quote_old_repository.dart';

final quoteRepositoryProvider = Provider<QuoteOldRepository>((ref) {
  return QuoteOldRepository();
});

final quotesProvider = FutureProvider<List<Quote_old>>((ref) async {
  final repo = ref.watch(quoteRepositoryProvider);
  return repo.getQuotes();
});

final quotesByClientProvider = FutureProvider.family<List<Quote_old>, String>((
  ref,
  clientId,
) async {
  final repo = ref.watch(quoteRepositoryProvider);
  return repo.getQuotesByClient(clientId);
});
