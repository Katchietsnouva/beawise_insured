import 'dart:convert';
import 'list_statement_entry.dart';

class Pagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int from;
  final int to;
  final bool hasMore;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.from,
    required this.to,
    required this.hasMore,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      hasMore: json['has_more'] ?? false,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
  
  
    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "per_page": perPage,
        "total": total,
        "last_page": lastPage,
        "from": from,
        "to": to,
        "has_more": hasMore,
        "next_page_url": nextPageUrl,
        "prev_page_url": prevPageUrl,
      };

}

class StatementResponse {
  final String status;
  final String message;
  final String starting;
  final String ending;
  final List<StatementEntry> sections;
  final StatementTotals totals;
  final Pagination pagination;

  bool get isSuccess => status == 'success';

  StatementResponse({
    required this.status,
    required this.message,
    required this.starting,
    required this.ending,
    required this.sections,
    required this.totals,
    required this.pagination,
  });

  factory StatementResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final sectionsJson = data['sections'] as List? ?? [];
    final totalsJson = data['totals'] as Map<String, dynamic>? ?? {};
    final paginationJson = data['pagination'] as Map<String, dynamic>? ?? {};

    return StatementResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString() ?? '',
      starting: json['starting']?.toString() ?? '',
      ending: json['ending']?.toString() ?? '',
      sections: sectionsJson
          .map((e) => StatementEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: StatementTotals.fromJson(totalsJson),
      pagination: Pagination.fromJson(paginationJson),
    );
  }
  
      Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "starting": starting,
        "ending": ending,
        "data": {
          "sections": sections.map((e) => e.toJson()).toList(),
          "totals": totals.toJson(),
          "pagination": pagination.toJson(),
        }
      };

}
