import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final user = authState.user;
    final bearerToken = authState.bearerToken ?? '';
    final agentKey = user?.agentKey ?? '';

    return Scaffold(
      // backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        // title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            // constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   'My Profile',
                //   style: TextStyle(
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(height: 4),
                CustomText(
                  'Manage your account information',
                  type: CustomTextType.subHeader,
                ),
                const SizedBox(height: 24),
                _buildProfileOverview(user, bearerToken, agentKey),
                const SizedBox(height: 24),
                _buildAccountDetails(user, bearerToken, agentKey),
                const SizedBox(height: 24),
                // _buildActivity(),
                // const SizedBox(height: 24),
                // _buildCredentials(user, bearerToken, agentKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOverview(user, bearerToken, agentKey) {
    final String name = user?.email ?? 'User';
    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.orange,
            child: Text(
              name.length >= 2
                  ? name.substring(0, 2).toUpperCase()
                  : name.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  'Full Name',
                  toTitleCase(user?.name).toString() ?? '-',
                ),

                _buildDetailRow('ID', user?.id.toString() ?? '-'),
                _buildDetailRow('Agent ID', user?.agentId.toString() ?? '-'),
                _buildDetailRow('Phone', user?.phone ?? '-'),
                _buildDetailRow('Company', user?.company ?? '-'),
                _buildDetailRow('Agent Code ', user?.agentCode ?? '-'),

                // _buildDetailRow('Agent Key', user?.agentKey ?? '-'),
                // _buildDetailRow('Bearer Token', bearerToken ?? '-'),
                SizedBox(height: 4),
                Text('User', style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetails(user, bearerToken, agentKey) {
    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.person_outline, color: Colors.orange),
              SizedBox(width: 8),
              CustomText('Account Details', type: CustomTextType.header),
            ],
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          _buildDetailRow('Full Name', 'User'),
          _buildDetailRow('Email', user?.email ?? '-'),
          _buildDetailRow('Role', 'User'),
          _buildDetailRow('Member Since', '–'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? textColor,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: CustomText(
              label,
              // style: const TextStyle(color: Colors.white70),
              type: CustomTextType.paragraph,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: CustomText(
              value,
              type: CustomTextType.paragraph,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity() {
    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Colors.orange),
              SizedBox(width: 8),
              CustomText('Activity', type: CustomTextType.subHeader),
            ],
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatBox('0', 'Clients Added')),
              const SizedBox(width: 16),
              Expanded(child: _buildStatBox('0', 'Quotes Created')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _buildCredentials(user, bearerToken, agentKey) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            maxLines: 2,
            'Agent Key',
            user?.agentKey ?? '-',
            textColor: Colors.orange,
          ),
          _buildDetailRow(
            maxLines: 2,
            'Bearer Token',
            bearerToken ?? '-',
            textColor: Colors.white70,
          ),
        ],
      ),
    );
  }
}
