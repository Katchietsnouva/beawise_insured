import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/dmvic_provider.dart';

class DmvicStockScreen extends ConsumerStatefulWidget {
  const DmvicStockScreen({super.key});

  @override
  ConsumerState<DmvicStockScreen> createState() => _DmvicStockScreenState();
}

class _DmvicStockScreenState extends ConsumerState<DmvicStockScreen> {
  int? _selectedInsurerId;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_selectedInsurerId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an insurer')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authState = ref.read(authProvider);
      final token = authState.bearerToken;
      if (token == null) throw Exception('Not authenticated');

      final response = await ApiService.postDmvicStock(
        token: token,
        insurerId: _selectedInsurerId!,
      );

      ref.read(dmvicStockResultProvider.notifier).state = AsyncValue.data(
        response,
      );
      print('📦 DMVIC Stock Response: $response');
    } catch (e, stack) {
      ref.read(dmvicStockResultProvider.notifier).state = AsyncValue.error(
        e,
        stack,
      );
      print('❌ Error: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final insurersAsync = ref.watch(insurersProvider);
    final result = ref.watch(dmvicStockResultProvider);

    return Scaffold(
      appBar: AppBar(
        // title: const Text('DMVIC Stock', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CustomText(
                      'Check Stock by Insurer',
                      type: CustomTextType.header,
                    ),
                    const SizedBox(height: 20),

                    insurersAsync.when(
                      data: (insurers) {
                        if (insurers.isEmpty) {
                          return const CustomText(
                            'No insurers available',
                            type: CustomTextType.paragraph,
                          );
                        }

                        final items = insurers.map<DropdownMenuItem<int>>((
                          insurer,
                        ) {
                          final displayName =
                              insurer['short_name'] ??
                              insurer['legal_name'] ??
                              'Unknown';
                          final value = insurer['id'] as int?;
                          if (value == null)
                            return const SizedBox.shrink()
                                as DropdownMenuItem<int>;
                          return DropdownMenuItem<int>(
                            value: value,
                            child: CustomText(
                              displayName,
                              type: CustomTextType.paragraph,
                            ),
                          );
                        }).toList();

                        return CustomDropdown<int>(
                          value: _selectedInsurerId,
                          items: items,
                          onChanged: (val) =>
                              setState(() => _selectedInsurerId = val),
                          hint: 'Select Insurer',
                          icon: Icons.arrow_drop_down,
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (err, stack) => Text(
                        'Error loading insurers: $err',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(height: 20),

                    CustomAdvancedButton(
                      variant: ButtonVariant.primary,
                      label: 'Check Stock',
                      onPressed: _submit,
                      // loading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (result != null)
              result.when(
                data: (data) => _buildResultCard(data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Error: $err',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> data) {
    final bool success =
        data['success'] ?? data['status'] == 'success' ?? false;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.warning,
                  color: success ? Colors.green : Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 10),
                CustomText(
                  success
                      ? 'Stock Information Retrieved'
                      : 'Issue with Request',
                  type: CustomTextType.subHeader,
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 30),

            // Display all fields from response
            ...data.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomText(
                        '${entry.key}:',
                        type: CustomTextType.paragraph,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: CustomText(
                        entry.value?.toString() ?? 'null',
                        type: CustomTextType.paragraph,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const Divider(color: Colors.white24, height: 30),
            const Text(
              'Raw Response:',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              data.toString(),
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
