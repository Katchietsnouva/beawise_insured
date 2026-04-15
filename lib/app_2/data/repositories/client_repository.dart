import 'dart:convert';
import 'package:insured/app_2/data/local/json_helper.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';

class ClientRepository {
  Future<List<Client>> getClients() async {
    final data = await JsonHelper.loadData();
    final clientsJson = data['clients'] as List? ?? [];
    return clientsJson.map((c) => Client.fromJson(c)).toList();
  }

  Future<void> addClient(Client client) async {
    final data = await JsonHelper.loadData();
    final clients = List<Map<String, dynamic>>.from(data['clients'] ?? []);
    clients.add(client.toJson());
    data['clients'] = clients;
    await JsonHelper.saveData(data);
  }

  Future<void> updateClient(Client client) async {
    final data = await JsonHelper.loadData();
    final clients = List<Map<String, dynamic>>.from(data['clients'] ?? []);
    final index = clients.indexWhere((c) => c['client_no'] == client.client_no);
    if (index != -1) {
      clients[index] = client.toJson();
      data['clients'] = clients;
      await JsonHelper.saveData(data);
    }
  }
}
