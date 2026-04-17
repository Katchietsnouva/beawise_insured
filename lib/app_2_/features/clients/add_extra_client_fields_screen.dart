import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';

class AddExtraClientFieldsModal extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddExtraClientFieldsModal({super.key, this.initialData});

  @override
  State<AddExtraClientFieldsModal> createState() =>
      _AddExtraClientFieldsModalState();
}

class _AddExtraClientFieldsModalState extends State<AddExtraClientFieldsModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _genderController;
  late TextEditingController _occupationController;
  late TextEditingController _locationController;
  late TextEditingController _addressController;
  late TextEditingController _postCodeController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialData ?? {};
    _genderController = TextEditingController(text: initial['gender'] ?? '');
    _occupationController = TextEditingController(
      text: initial['occupation'] ?? '',
    );
    _locationController = TextEditingController(
      text: initial['location'] ?? '',
    );
    _addressController = TextEditingController(text: initial['address'] ?? '');
    _postCodeController = TextEditingController(
      text: initial['post_code'] ?? '',
    );
    _cityController = TextEditingController(text: initial['city'] ?? '');
  }

  @override
  void dispose() {
    _genderController.dispose();
    _occupationController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _postCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final extraData = {
        'gender': _genderController.text.isEmpty
            ? null
            : _genderController.text,
        'occupation': _occupationController.text.isEmpty
            ? null
            : _occupationController.text,
        'location': _locationController.text.isEmpty
            ? null
            : _locationController.text,
        'address': _addressController.text.isEmpty
            ? null
            : _addressController.text,
        'post_code': _postCodeController.text.isEmpty
            ? null
            : _postCodeController.text,
        'city': _cityController.text.isEmpty ? null : _cityController.text,
      };
      Navigator.pop(context, extraData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Extra Client Details',
                          type: CustomTextType.header,
                        ),
                        CustomText(
                          'Add optional information',
                          type: CustomTextType.caption,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 32),
                GlassCard(
                  child: Column(
                    children: [
                      CustomTextField(
                        hint: 'Gender',
                        icon: Icons.person,
                        controller: _genderController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Occupation',
                        icon: Icons.work,
                        controller: _occupationController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Location',
                        icon: Icons.location_on,
                        controller: _locationController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Address',
                        icon: Icons.home,
                        controller: _addressController,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hint: 'Post Code',
                              icon: Icons.markunread_mailbox,
                              controller: _postCodeController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              hint: 'City',
                              icon: Icons.location_city,
                              controller: _cityController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomAdvancedButton(
                        label: "Cancel",
                        onPressed: () => Navigator.pop(context),
                        variant: ButtonVariant.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomAdvancedButton(
                        label: 'Save Extra Details',
                        onPressed: _save,
                        variant: ButtonVariant.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
