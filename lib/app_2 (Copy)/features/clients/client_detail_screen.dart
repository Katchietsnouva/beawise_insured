// lib/app_2/features/clients/client_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/features/clients/add_client_screen.dart';

class ClientDetailScreen extends StatelessWidget {
  final Client client;

  const ClientDetailScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    // final client = ModalRoute.of(context)!.settings.arguments as Client;

    final firsthalf = [
      _detailRow('Full Name', client.name),
      // _detailRow('Id', client.id.toString()),
      _detailRow('Client no', client.client_no ?? 'N/A'),
      _detailRow('Phone', client.mobile),
      _detailRow('Email', client.email),
      _detailRow('Client No', client.client_no),
      _detailRow('Phone', client.mobile),
      _detailRow('Email', client.email),
      _detailRow('Date of Birth', formatHumanDate(client.dob ?? '') ?? 'N/A'),
    ];

    final secondhalf = [
      _detailRow('ID Number', client.idno ?? 'N/A'),
      _detailRow('KRA PIN', client.pin ?? 'N/A'),
      _detailRow('Gender', client.gender ?? 'N/A'),
      _detailRow('Occupation', client.occupation ?? 'N/A'),
      _detailRow('Location', client.location ?? 'N/A'),
      _detailRow('Address', client.address ?? 'N/A'),
      _detailRow('Post Code', client.postCode ?? 'N/A'),
      _detailRow('City', client.city ?? 'N/A'),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(client.name, type: CustomTextType.header),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CustomCircularAvatar(
                  user: client.name,
                  radius: 50,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: const CustomText(
                  'Personal Information',
                  type: CustomTextType.header,
                ),
              ),
              const Divider(color: Colors.white30),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = Responsive.isDesktop(context);

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GlassCard(child: Column(children: firsthalf)),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: GlassCard(child: Column(children: secondhalf)),
                        ),
                      ],
                    );
                  }

                  return GlassCard(
                    child: Column(children: [...firsthalf, ...secondhalf]),
                  );
                },
              ),

              // _detailRow('Status', client.status!.toUpperCase()),
              const SizedBox(height: 24),
              Center(
                child: CustomAdvancedButton(
                  width: 400,
                  height: 50,
                  label: 'Edit',
                  variant: ButtonVariant.primary,
                  onPressed: () async {
                    final result =
                        await showModalBottomSheet<
                          (bool, Map<String, dynamic>)
                        >(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AddClientModal(
                            initialData: {
                              'name': client.name,
                              'email': client.email,
                              'phone': client.mobile,
                              'idno': client.idno,
                              'pin': client.pin,
                              'dob': client.dob,
                              // 'client_no': client.client_no,
                              'gender': client.gender,
                              'occupation': client.occupation,
                              'location': client.location,
                              'address': client.address,
                              'postCode': client.postCode,
                              'city': client.city,
                              // 'status': client.status,
                            },
                            clientId: client.id
                                ?.toString(), // bytha pass ID used  for update
                          ),
                        );
                    if (result != null && result.$1) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: 0.4,
            child: CustomText(label, type: CustomTextType.subHeader),
          ),
          CustomText(value, type: CustomTextType.paragraph),
        ],
      ),
    );
  }
}
