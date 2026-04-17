import 'dart:convert';

class ClientsRequest {
  final int page;
  final int perPage;

  ClientsRequest({this.page = 1, this.perPage = 10});

  Map<String, dynamic> toJson() => {"page": page, "per_page": perPage};
}

class Client {
  final String name;
  final String client_no;
  final String mobile;
  final String email;
  final String? status; // 'active' or 'pending'

  final String? idno;
  final int? id;
  final String? pin;
  final String? dob;
  final String? gender;
  final String? occupation;
  final String? location;
  final String? address;
  final String? postCode;
  final String? city;

  Client({
    required this.name,
    required this.client_no,
    required this.mobile,
    required this.email,
    this.status,

    this.idno,
    this.id,
    this.pin,
    this.dob,
    this.gender,
    this.occupation,
    this.location,
    this.address,
    this.postCode,
    this.city,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'],
      client_no: json['client_no'],
      // mobile: json['mobile'],
      mobile: json['phone'],
      email: json['email'],
      status: json['status'],

      idno: json['idno'],
      id: json['id'],
      pin: json['pin'],
      dob: json['dob'],
      gender: json['gender'],
      occupation: json['occupation'],
      location: json['location'],
      address: json['address'],
      postCode: json['post_code'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'client_no': client_no,
    // 'mobile': mobile,
    'phone': mobile,
    'email': email,
    'status': status,
    'idno': idno,
    'id': id,
    'pin': pin,
    'dob': dob,
    'gender': gender,
    'occupation': occupation,
    'location': location,
    'address': address,
    'post_code': postCode,
    'city': city,
  };
}

ClientsResponse clientsResponseFromJson(String str) =>
    ClientsResponse.fromJson(json.decode(str));

String clientsResponseToJson(ClientsResponse data) =>
    json.encode(data.toJson());

class ClientsResponse {
  final String status;
  final String message;
  final List<Client> clients;
  final Pagination? pagination;

  ClientsResponse({
    required this.status,
    required this.message,
    required this.clients,
    required this.pagination,
  });

  bool get isSuccess => status == "success";

  factory ClientsResponse.fromJson(Map<String, dynamic> json) {
    return ClientsResponse(
      // status: json['status'] ?? '',
      status: json['status']?.toString() ?? 'error',
      // message: json['message'] ?? '',
      message: json['message']?.toString() ?? '',
      // clients: (json['clients'] as List<dynamic>? ?? [])
      //     .map((e) => Client.fromJson(e))
      //     .toList(),
      // pagination: Pagination.fromJson(json['pagination'] ?? {}),
      clients:
          (json['clients'] as List?)
              ?.map((e) => Client.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'clients': clients.map((e) => e.toJson()).toList(),
    'pagination': pagination?.toJson(),
  };
}

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
    'current_page': currentPage,
    'per_page': perPage,
    'total': total,
    'last_page': lastPage,
    'from': from,
    'to': to,
    'has_more': hasMore,
    'next_page_url': nextPageUrl,
    'prev_page_url': prevPageUrl,
  };
}
