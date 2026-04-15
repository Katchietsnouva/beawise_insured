import 'dart:convert';
import 'package:insured/app_2/data/local/json_helper.dart';
import 'package:insured/app_2/data/models/quote_old_model.dart';

class QuoteOldRepository {
  Future<List<Quote_old>> getQuotes() async {
    final data = await JsonHelper.loadData();
    final quotesJson = data['quotes'] as List? ?? [];
    return quotesJson.map((q) => Quote_old.fromJson(q)).toList();
  }

  Future<List<Quote_old>> getQuotesByClient(String clientId) async {
    final quotes = await getQuotes();
    return quotes.where((q) => q.clientId == clientId).toList();
  }

  Future<void> addQuote(Quote_old quote) async {
    final data = await JsonHelper.loadData();
    final quotes = List<Map<String, dynamic>>.from(data['quotes'] ?? []);
    quotes.add(quote.toJson());
    data['quotes'] = quotes;
    await JsonHelper.saveData(data);
  }

  Future<void> updateQuote(Quote_old quote) async {
    final data = await JsonHelper.loadData();
    final quotes = List<Map<String, dynamic>>.from(data['quotes'] ?? []);
    final index = quotes.indexWhere((q) => q['id'] == quote.id);
    if (index != -1) {
      quotes[index] = quote.toJson();
      data['quotes'] = quotes;
      await JsonHelper.saveData(data);
    }
  }

  Future<void> deleteQuote(String id) async {
    final data = await JsonHelper.loadData();
    final quotes = List<Map<String, dynamic>>.from(data['quotes'] ?? []);
    quotes.removeWhere((q) => q['id'] == id);
    data['quotes'] = quotes;
    await JsonHelper.saveData(data);
  }
}
