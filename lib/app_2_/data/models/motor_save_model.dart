// Client info
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MotorClient {
  String name;
  String email;
  String phone;
  String idno;
  String pin;
  int? riskManagerId;
  int? salesPersonId;
  int branchId;

  MotorClient({
    required this.name,
    required this.email,
    required this.phone,
    required this.idno,
    required this.pin,
    this.riskManagerId,
    this.salesPersonId,
    required this.branchId,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'idno': idno,
    'pin': pin,
    'risk_manager_id': riskManagerId,
    'sales_person_id': salesPersonId,
    'branch_id': branchId,
  };
}

// Policy details
class MotorPolicy {
  int premiumInstalments;
  String coverPeriod; // "annual" or "tor"
  String startDate;
  String endDate;
  int insurerId;
  String vehicleClass;
  String coverage;
  String scope;
  double totalBasic;
  double taxes;
  double premium;
  double markup;
  double markupValue;

  MotorPolicy({
    required this.premiumInstalments,
    required this.coverPeriod,
    required this.startDate,
    required this.endDate,
    required this.insurerId,
    required this.vehicleClass,
    required this.coverage,
    required this.scope,
    required this.totalBasic,
    required this.taxes,
    required this.premium,
    required this.markup,
    required this.markupValue,
  });

  Map<String, dynamic> toJson() => {
    'premium_instalments': premiumInstalments,
    'cover_period': coverPeriod,
    'start_date': startDate,
    'end_date': endDate,
    'insurer_id': insurerId,
    'class': vehicleClass,
    'coverage': coverage,
    'scope': scope,
    'total_basic': totalBasic,
    'taxes': taxes,
    'premium': premium,
    'markup': markup,
    'markup_value': markupValue,
  };
}

// Tax item in the array
class TaxItem {
  int taxId;
  String rate;
  String amount;

  TaxItem({required this.taxId, required this.rate, required this.amount});

  Map<String, dynamic> toJson() => {
    'tax_id': taxId,
    'rate': rate,
    'amount': amount,
  };
}

// Benefit inside a vehicle
class VehicleBenefit {
  int benefitId;
  double rate;
  double premium;

  VehicleBenefit({
    required this.benefitId,
    required this.rate,
    required this.premium,
  });

  Map<String, dynamic> toJson() => {
    'benefit_id': benefitId,
    'rate': rate,
    'premium': premium,
  };
}

// Vehicle
class Vehicle {
  double rate;
  String coverage;
  String regno;
  String make;
  String model;
  String body;
  String color;
  String chasis;
  String engine;
  int cc;
  int yom;
  int seats;
  double tonnage;
  double value;
  double basicPremium;
  List<VehicleBenefit> benefits;

  Vehicle({
    required this.rate,
    required this.coverage,
    required this.regno,
    required this.make,
    required this.model,
    required this.body,
    required this.color,
    required this.chasis,
    required this.engine,
    required this.cc,
    required this.yom,
    required this.seats,
    required this.tonnage,
    required this.value,
    required this.basicPremium,
    required this.benefits,
  });

  Map<String, dynamic> toJson() => {
    'rate': rate,
    'coverage': coverage,
    'regno': regno,
    'make': make,
    'model': model,
    'body': body,
    'color': color,
    'chasis': chasis,
    'engine': engine,
    'cc': cc,
    'yom': yom,
    'seats': seats,
    'tonnage': tonnage,
    'value': value,
    'basic_premium': basicPremium,
    'benefits': benefits.map((b) => b.toJson()).toList(),
  };
}

// Full save request
class MotorSaveRequest {
  MotorClient client;
  MotorPolicy policy;
  List<TaxItem> taxes;
  List<Vehicle> vehicles;

  MotorSaveRequest({
    required this.client,
    required this.policy,
    required this.taxes,
    required this.vehicles,
  });

  Map<String, dynamic> toJson() => {
    'client': client.toJson(),
    'policy': policy.toJson(),
    'taxes': taxes.map((t) => t.toJson()).toList(),
    'vehicles': vehicles.map((v) => v.toJson()).toList(),
  };
}

// Save response
class MotorSaveResponse {
  final String message;
  final int risknote;
  final int id;
  final String clientNo;
  final String clientKey;

  MotorSaveResponse({
    required this.message,
    required this.risknote,
    required this.id,
    required this.clientNo,
    required this.clientKey,
  });

  factory MotorSaveResponse.fromJson(Map<String, dynamic> json) {
    return MotorSaveResponse(
      message: json['message'],
      risknote: json['risknote'],
      id: json['id'],
      clientNo: json['client_no'],
      clientKey: json['client_key'],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'risknote': risknote,
    'id': id,
    'client_no': clientNo,
    'client_key': clientKey,
  };
}

class MotorSaveResponseToLocalStore {
  final String message;
  final int risknote;
  final int id;
  final String clientNo;
  final String clientKey;
  final DateTime createdAt;

  MotorSaveResponseToLocalStore({
    required this.message,
    required this.risknote,
    required this.id,
    required this.clientNo,
    required this.clientKey,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "message": message,
    "risknote": risknote,
    "id": id,
    "client_no": clientNo,
    "client_key": clientKey,
    "created_at": createdAt.toIso8601String(),
  };

  factory MotorSaveResponseToLocalStore.fromJson(Map<String, dynamic> json) {
    return MotorSaveResponseToLocalStore(
      message: json["message"],
      risknote: json["risknote"],
      id: json["id"],
      clientNo: json["client_no"],
      clientKey: json["client_key"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}

class PolicyMotorSaveResponseToLocalStore {
  static const _key = "saved_policies_response";

  static Future<void> addPolicy(MotorSaveResponseToLocalStore policy) async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getStringList(_key) ?? [];

    existing.add(jsonEncode(policy.toJson()));

    await prefs.setStringList(_key, existing);
  }

  static Future<List<MotorSaveResponseToLocalStore>> getPolicies() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(_key) ?? [];

    return list
        .map((e) => MotorSaveResponseToLocalStore.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
