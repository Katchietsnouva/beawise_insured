import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_auth_provider.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/utils/error_parser.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/offline_action_model.dart';
import 'package:insured/app_2/features/clients/add_extra_client_fields_screen.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/connectivity_provider.dart';
import 'package:insured/app_2/providers/offline_queue_provider.dart';

class AddClientModal extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialData;
  final String? clientId;
  const AddClientModal({super.key, this.initialData, this.clientId});
  // const AddClientModal({super.key});

  @override
  ConsumerState<AddClientModal> createState() => _AddClientModalState();
}

class _AddClientModalState extends ConsumerState<AddClientModal> {
  late var firstNameController = TextEditingController();
  late var lastNameController = TextEditingController();
  late var idNumberController = TextEditingController();
  late var emailController = TextEditingController();
  late var phoneController = TextEditingController();
  late var pinController = TextEditingController();
  late var dobController = TextEditingController();
  Map<String, dynamic>? _extraData;

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final cache = ref.read(clientAddPopupCacheProvider);
    // If initialData is provided, use it; otherwise fallback to cache.
    final initial = widget.initialData;
    // firstNameController = TextEditingController(
    //   text: initial?['firstName'] ?? initial?['name']?.split(' ').first ?? cache.get('first_name') ?? '',
    // );
    // lastNameController = TextEditingController(
    //   text: initial?['lastName'] ?? (initial?['name']?.split(' ').length > 1 ? initial?['name'].split(' ').skip(1).join(' ') : '') ?? cache.get('last_name') ?? '',
    // );

    // 1. Extract and split the name safely
    final String? fullName = initial?['name'];
    final List<String> nameParts = fullName?.trim().split(' ') ?? [];

    // 2. Logic for First Name
    // Priority: firstName key -> first part of full name -> cache -> empty
    final String initialFirstName =
        initial?['firstName'] ??
        (nameParts.isNotEmpty ? nameParts.first : null) ??
        cache.get('first_name') ??
        '';

    // 3. Logic for Last Name
    // Priority: lastName key -> everything after first name -> cache -> empty
    final String initialLastName =
        initial?['lastName'] ??
        (nameParts.length > 1 ? nameParts.skip(1).join(' ') : null) ??
        cache.get('last_name') ??
        '';

    firstNameController = TextEditingController(text: initialFirstName);
    lastNameController = TextEditingController(text: initialLastName);
    idNumberController = TextEditingController(
      text: initial?['idno'] ?? cache.get('id_number') ?? '',
    );
    emailController = TextEditingController(
      text: initial?['email'] ?? cache.get('email') ?? '',
    );
    phoneController = TextEditingController(
      text: initial?['phone'] ?? cache.get('phone') ?? '',
    );
    pinController = TextEditingController(
      text: initial?['pin'] ?? cache.get('pin') ?? '',
    );
    dobController = TextEditingController(
      text: initial?['dob'] ?? cache.get('dob') ?? '',
    );

    // Add listeners for cache (optional)
    firstNameController.addListener(
      () => cache.put('first_name', firstNameController.text),
    );
    lastNameController.addListener(
      () => cache.put('last_name', lastNameController.text),
    );
    idNumberController.addListener(
      () => cache.put('id_number', idNumberController.text),
    );
    emailController.addListener(() => cache.put('email', emailController.text));
    phoneController.addListener(() => cache.put('phone', phoneController.text));
    pinController.addListener(() => cache.put('pin', pinController.text));
    dobController.addListener(() => cache.put('dob', dobController.text));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   final cache = ref.read(clientAddPopupCacheProvider);
  //   firstNameController = TextEditingController(
  //     text: cache.get('first_name') ?? '',
  //   );
  //   lastNameController = TextEditingController(
  //     text: cache.get('last_name') ?? '',
  //   );
  //   idNumberController = TextEditingController(
  //     text: cache.get('id_number') ?? '',
  //   );
  //   emailController = TextEditingController(text: cache.get('email') ?? '');
  //   phoneController = TextEditingController(text: cache.get('phone') ?? '');
  //   pinController = TextEditingController(text: cache.get('pin') ?? '');
  //   dobController = TextEditingController(text: cache.get('dob') ?? '');

  //   firstNameController.addListener(
  //     () => cache.put('first_name', firstNameController.text),
  //   );
  //   lastNameController.addListener(
  //     () => cache.put('last_name', lastNameController.text),
  //   );
  //   idNumberController.addListener(
  //     () => cache.put('id_number', idNumberController.text),
  //   );
  //   emailController.addListener(() => cache.put('email', emailController.text));
  //   phoneController.addListener(() => cache.put('phone', phoneController.text));
  //   pinController.addListener(() => cache.put('pin', pinController.text));
  //   dobController.addListener(() => cache.put('dob', dobController.text));
  // }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    idNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    pinController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _openExtraScreen() async {
    // final result = await Navigator.push<Map<String, dynamic>>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => AddExtraClientFieldsScreen(initialData: _extraData),
    //   ),
    // );
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExtraClientFieldsModal(initialData: _extraData),
    );
    if (result != null) {
      setState(() {
        _extraData = result;
      });
    }
  }

  Future<void> _createClient() async {
    if (_isLoading) return; // Immediate guard clause
    // if (!_formKey.currentState!.validate()) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      HapticFeedback.heavyImpact();
      print('Create client Form not ready, fill req fields');
      return;
    }
    final name = '${firstNameController.text} ${lastNameController.text}'
        .trim();

    final Map<String, dynamic> clientBody = {
      'name': name,
      'email': emailController.text,
      'phone': phoneController.text,
      'idno': idNumberController.text,
      'pin': pinController.text,
      'dob': dobController.text,
    };
    if (_extraData != null) {
      clientBody.addAll(_extraData!);
    }
    final clientDataToUpload = {'client': clientBody};

    final clientData = {
      'client': {
        'name': name,
        'email': emailController.text,
        'phone': phoneController.text,
        'idno': idNumberController.text,
        'pin': pinController.text,
        'dob': dobController.text,
      },
    };

    final isOnline = ref.read(connectivityStreamProvider).value ?? true;
    print('This is the status of network isOnline $isOnline');
    print('This is the clientDataToReturn obj: ${clientDataToUpload}');
    if (!isOnline) {
      _queueClientCreation();
      // Navigator.pop(context, (false, clientDataToReturn));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final token = await ref.read(apiAuthProvider.notifier).getAuthToken();
      final authState = ref.read(authProvider);
      final user = authState.user;

      if (token == null || user == null) throw Exception('Not authenticated');

      // final response = await ApiService.createClient(
      //   clientData: clientData,
      //   agentCode: user.agentCode,
      //   agentKey: user.agentKey,
      //   token: token,
      // );

      late Map<String, dynamic> response;
      if (widget.clientId != null) {
        response = await ApiService.updateClient(
          clientId: widget.clientId!,
          clientData: clientDataToUpload,
          agentCode: user.agentCode,
          agentKey: user.agentKey,
          token: token,
        );
        print("In updateClient option ${response} ");
      } else {
        response = await ApiService.createClient(
          clientData: clientDataToUpload,
          agentCode: user.agentCode,
          agentKey: user.agentKey,
          token: token,
        );
        print("In createClient option  ${response} ");
      }
      print("This is the response form ADD CLIENT  screnn  ${response}");

      if (response['status'] == 'success') {
        FuturisticToastS.show(
          context: context,
          // message: 'Client created successfully',
          message: widget.clientId != null
              ? 'Client updated successfully'
              : 'Client created successfully',
          icon: Icons.check_circle,
          alignment: Alignment.topCenter,
        );
        ref.read(clientAddPopupCacheProvider).clear();

        // Navigator.pop(context, true);
        // Navigator.pop(context, clientDataToReturn);
        // Navigator.pop(context, (true, clientBody));
        if (mounted) {
          // Return the success state and data to the caller
          Navigator.pop(context, (true, clientBody));
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to create client');
      }
    } catch (e) {
      final error = ErrorParser.fromRaw(e);

      FuturisticToastT.show(
        context: context,
        // message: e.toString(),
        message: error.message,
        errors: error.errors,
        icon: Icons.error_outline,
        alignment: Alignment.topCenter,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _queueClientCreation() {
    final clientDataToReturn = {
      'name': '${firstNameController.text} ${lastNameController.text}'.trim(),
      'email': emailController.text,
      'phone': phoneController.text,
      'idno': idNumberController.text,
      'pin': pinController.text,
      'dob': dobController.text,
    };
    final action = OfflineAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OfflineActionType.createClient,
      data: clientDataToReturn,
      createdAt: DateTime.now(),
    );
    ref.read(offlineQueueNotifierProvider.notifier).add(action);
    FuturisticToastS.show(
      context: context,
      message: 'Client saved offline. You can upload later.',
      icon: Icons.save,
      alignment: Alignment.topCenter,
    );
    // Navigator.pop(context, true);
    Navigator.pop(context, (true, clientDataToReturn));
  }

  @override
  Widget build(BuildContext context) {
    final isWide = !Responsive.isMobile(context);
    Widget firstName = CustomTextField(
      hint: 'First Name',
      icon: Icons.person,
      controller: firstNameController,
      isRequired: true,
    );
    Widget lastName = CustomTextField(
      hint: 'Last Name',
      icon: Icons.person_outline,
      controller: lastNameController,
      isRequired: true,
    );

    Widget idNumberField = CustomTextField(
      hint: 'ID Number',
      maxNumberOfCharHL: 10,
      icon: Icons.badge,
      controller: idNumberController,
      keyboardType: TextInputType.number,
      isRequired: true,
      isNumber: true,
    );

    Widget pinField = CustomTextField(
      hint: 'KRA PIN',
      icon: Icons.lock,
      isPin: true,
      hintLabel: 'PIN format: A123456789B',
      controller: pinController,
      isRequired: true,
    );
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
          // color: const Color(0xFF00FFB2).withOpacity(0.08),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          widget.clientId != null
                              ? 'Update Client'
                              : 'Add New Client',

                          type: CustomTextType.header,
                        ),
                        CustomText(
                          'Enter personal identification details',
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

                isWide
                    ? Row(
                        children: [
                          Expanded(child: firstName),
                          const SizedBox(width: 16),
                          Expanded(child: lastName),
                        ],
                      )
                    : Column(
                        children: [
                          firstName,
                          const SizedBox(height: 12),
                          lastName,
                        ],
                      ),
                const SizedBox(height: 12),

                const SizedBox(height: 16),
                CustomTextField(
                  hint: 'Email Address',
                  icon: Icons.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  isEmail: true,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: 'Phone Number',
                  icon: Icons.phone,
                  hintLabel: '07.../01...',
                  maxNumberOfCharHL: 10,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  isNumber: true,
                ),
                const SizedBox(height: 16),
                isWide
                    ? Row(
                        children: [
                          Expanded(child: idNumberField),
                          const SizedBox(width: 16),
                          Expanded(child: pinField),
                        ],
                      )
                    : Column(
                        children: [
                          idNumberField,
                          const SizedBox(height: 12),
                          pinField,
                        ],
                      ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: "Date of Birth (dd-MM-yyyy)",
                  icon: Icons.calendar_today,
                  controller: dobController,
                  isDateField: true,
                  // isRequired: true,
                  minDate: DateTime(1900),
                  maxDate: DateTime.now(),
                ),

                const SizedBox(height: 16),

                Visibility(
                  visible: widget.clientId != null,
                  child: CustomAdvancedButton(
                    label: _extraData == null
                        ? 'Add Extra Details'
                        : 'Edit Extra Details',
                    icon: Icon(Icons.edit),
                    variant: ButtonVariant.secondary,
                    onPressed: _openExtraScreen,
                  ),
                ),
                const SizedBox(height: 8),
                if (_extraData != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        const CustomText(
                          'Extra details added',
                          type: CustomTextType.caption,
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

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
                        loading: _isLoading,
                        // label: 'Create Client',
                        label: widget.clientId != null
                            ? 'Update Client'
                            : 'Create Client',
                        onPressed: _createClient,
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
