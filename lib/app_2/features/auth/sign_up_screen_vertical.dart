import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:insured/app_2/core/constants/app_strings.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/f_tT_error_message_parser.dart';
import 'package:insured/app_2/core/widgets/futuristic_toast.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/core/widgets/glass_card_auth.dart';
import 'package:insured/app_2/core/widgets/response_display.dart';
import 'package:insured/app_2/features/onboarding/widgets/three_d_model_viewer.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _showValidationErrors = false;
  bool _isHoveringLoginText = false;
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;
  late final AnimationController _shimmerCtrl;

  late final TextEditingController _companyCtrl;
  late final TextEditingController _contactPersonCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _pinCtrl;
  late final TextEditingController _idnoCtrl;
  late final TextEditingController _iraNoCtrl;
  late final TextEditingController _commNewCtrl;
  late final TextEditingController _commRenewalCtrl;
  late final TextEditingController _wtaxCtrl;
  late final TextEditingController _commCalcCtrl;
  late final TextEditingController _branchIdCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmPasswordCtrl;
  bool _isRegistering = false;

  bool _isFocused = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // final cache = ref.read(memoryCacheProvider);
    final cache = ref.read(signUpCacheProvider);

    // _companyCtrl = TextEditingController(text: cache['company'] ?? '');

    _companyCtrl = TextEditingController(text: cache.get('company') ?? '');
    _contactPersonCtrl = TextEditingController(
      text: cache.get('contact_person') ?? '',
    );
    _addressCtrl = TextEditingController(text: cache.get('address') ?? '');
    _phoneCtrl = TextEditingController(text: cache.get('phone') ?? '');
    _emailCtrl = TextEditingController(text: cache.get('email') ?? '');
    _pinCtrl = TextEditingController(text: cache.get('pin') ?? '');
    _idnoCtrl = TextEditingController(text: cache.get('idno') ?? '');
    _iraNoCtrl = TextEditingController(text: cache.get('ira_no') ?? '');
    _commNewCtrl = TextEditingController(
      text: cache.get('comm_new_business')?.toString() ?? '',
    );
    _commRenewalCtrl = TextEditingController(
      text: cache.get('comm_renewal')?.toString() ?? '',
    );
    _wtaxCtrl = TextEditingController(
      text: cache.get('wtax')?.toString() ?? '',
    );
    _commCalcCtrl = TextEditingController(
      text: cache.get('comm_calc')?.toString() ?? '',
    );
    _branchIdCtrl = TextEditingController(
      text: cache.get('branch_id')?.toString() ?? '',
    );
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // ← slow shimmer
    )..repeat();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine));

    // ??????????????????????????????????????????????
    // _companyCtrl.addListener(() => _updateCache('company', _companyCtrl.text));
    _companyCtrl.addListener(() => cache.put('company', _companyCtrl.text));
    _contactPersonCtrl.addListener(
      () => cache.put('contact_person', _contactPersonCtrl.text),
    );
    _addressCtrl.addListener(() => cache.put('address', _addressCtrl.text));
    _phoneCtrl.addListener(() => cache.put('phone', _phoneCtrl.text));
    _emailCtrl.addListener(() => cache.put('email', _emailCtrl.text));
    _pinCtrl.addListener(() => cache.put('pin', _pinCtrl.text));
    _idnoCtrl.addListener(() => cache.put('idno', _idnoCtrl.text));
    _iraNoCtrl.addListener(() => cache.put('ira_no', _iraNoCtrl.text));
    _commNewCtrl.addListener(
      () =>
          cache.put('comm_new_business', int.tryParse(_commNewCtrl.text) ?? 10),
    );
    _commRenewalCtrl.addListener(
      () => cache.put('comm_renewal', int.tryParse(_commRenewalCtrl.text) ?? 5),
    );
    _wtaxCtrl.addListener(
      () => cache.put('wtax', int.tryParse(_wtaxCtrl.text) ?? 5),
    );
    _commCalcCtrl.addListener(
      () => cache.put('comm_calc', int.tryParse(_commCalcCtrl.text) ?? 1),
    );
    _branchIdCtrl.addListener(
      () => cache.put('branch_id', int.tryParse(_branchIdCtrl.text) ?? 1),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _contactPersonCtrl.text.trim().isNotEmpty &&
            _phoneCtrl.text.trim().isNotEmpty &&
            _emailCtrl.text.trim().isNotEmpty;

      case 1:
        return _companyCtrl.text.trim().isNotEmpty &&
            _iraNoCtrl.text.trim().isNotEmpty;

      case 2:
        return _passwordCtrl.text.isNotEmpty &&
            _confirmPasswordCtrl.text.isNotEmpty;

      default:
        return true;
    }
  }

  // void _updateCache(String key, dynamic value) {
  //   ref.read(memoryCacheProvider)[key] = value;
  // }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _floatCtrl.dispose();
    _companyCtrl.dispose();
    _contactPersonCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _pinCtrl.dispose();
    _idnoCtrl.dispose();
    _iraNoCtrl.dispose();
    _commNewCtrl.dispose();
    _commRenewalCtrl.dispose();
    _wtaxCtrl.dispose();
    _commCalcCtrl.dispose();
    _branchIdCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
          if (_isFocused) {
            setState(() => _isFocused = false);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1F1C), Color(0xFF0F3D3E), Color(0xFF145A32)],
            ),
          ),
          child: Stack(
            children: [
              AnimatedOrbs(
                glowColor: AppColors.mint,
                shimmerCtrl: _shimmerCtrl,
              ),
              const GrainOverlay(),

              SafeArea(
                child: Builder(
                  builder: (context) {
                    final bool isMobile = Responsive.isMobile(context);
                    // children: [
                    // 3D model

                    Widget modelWidget = AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      // height:
                      //     size.height *
                      //     (_isFocused
                      //         ? 0.15
                      //         : (Responsive.isMobile(context) ? 0.7 : 0.8)),
                      height: size.height * 0.8,
                      width: isMobile
                          ? size.width
                          // : size.width * (_isFocused ? 0.3 : 0.4),
                          : size.width * (0.4),
                      child: Opacity(
                        opacity: isMobile ? 0.3 : 1.0,
                        child: Center(
                          child: ThreeDModelViewer(
                            rotationY: 1.0,
                            floatAnim: _floatAnim,
                            isLogin: false, // Adjusted for sign-up
                          ),
                        ),
                      ),
                    );

                    // Glass card
                    // Expanded(
                    //   child: SingleChildScrollView(
                    //     padding: EdgeInsets.only(
                    //       bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    //     ),
                    //     child:

                    Widget formWidget = Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: Responsive.isMobile(context)
                              ? double.infinity
                              : 500,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 64,
                          ),
                          child: GlassCard(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Stepper(
                                    // shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    type: StepperType.vertical,
                                    currentStep: _currentStep,
                                    stepIconBuilder: (stepIndex, stepState) {
                                      return const SizedBox.shrink(); // hides numbers
                                    },
                                    stepIconHeight: 24.0,
                                    stepIconWidth: 24.0,
                                    stepIconMargin: EdgeInsets.zero,
                                    onStepContinue: () async {
                                      // if (!_formKey.currentState!.validate()) {
                                      if (!_validateCurrentStep()) {
                                        HapticFeedback.heavyImpact();

                                        setState(() {
                                          _showValidationErrors = true;
                                        });

                                        _formKey.currentState!.validate();
                                        return;
                                      }

                                      if (_currentStep < 2) {
                                        // setState(() => _currentStep++);
                                        setState(() {
                                          _currentStep++;
                                          _showValidationErrors = false;
                                        });
                                      } else if (_currentStep == 2) {
                                        if (_passwordCtrl.text !=
                                            _confirmPasswordCtrl.text) {
                                          // Show error
                                          FuturisticToastT.show(
                                            context: context,
                                            message: 'Passwords do not match',
                                            icon: Icons.error,
                                            iconColor: Colors.redAccent,
                                            alignment: Alignment.topCenter,
                                          );
                                          return;
                                        }
                                        // Collect data
                                        final data = {
                                          "contact_person":
                                              _contactPersonCtrl.text,
                                          "company": _companyCtrl.text,
                                          "pin": _pinCtrl.text,
                                          "idno": _idnoCtrl.text,
                                          "ira_no": _iraNoCtrl.text,
                                          "address": _addressCtrl.text,
                                          "phone": _phoneCtrl.text,
                                          "email": _emailCtrl.text,
                                          "comm_new_business":
                                              int.tryParse(_commNewCtrl.text) ??
                                              10,
                                          "comm_renewal":
                                              int.tryParse(
                                                _commRenewalCtrl.text,
                                              ) ??
                                              5,
                                          "wtax":
                                              int.tryParse(_wtaxCtrl.text) ?? 5,
                                          "comm_calc":
                                              int.tryParse(
                                                _commCalcCtrl.text,
                                              ) ??
                                              1,
                                          "branch_id":
                                              int.tryParse(
                                                _branchIdCtrl.text,
                                              ) ??
                                              1,
                                          "password": _passwordCtrl.text,
                                        };
                                        print(
                                          'Sending registration data: $data',
                                        );
                                        if (_isRegistering) return;
                                        setState(() => _isRegistering = true);

                                        final success = await ref
                                            .read(authProvider.notifier)
                                            .register(data);
                                        setState(() => _isRegistering = false);
                                        if (success) {
                                          ref.read(signUpCacheProvider).clear();

                                          final authState = ref.read(
                                            authProvider,
                                          );
                                          // print('Registration success response: ${authState.data}');
                                          // Success toast
                                          FuturisticToastS.show(
                                            context: context,
                                            message:
                                                'Registration successful! Please login.',
                                            icon: Icons.check_circle,
                                            iconColor: Colors.greenAccent,
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                            alignment: Alignment.topCenter,
                                          );
                                          // Navigate to login
                                          context.go('/login');
                                          // context.go('/dashboard');
                                        } else {
                                          // Error toast with detailed info
                                          final authState = ref.read(
                                            authProvider,
                                          );
                                          print(
                                            'Registration error: ${authState.error}',
                                          );

                                          // FuturisticToastT.show(
                                          //         context: context,
                                          //         message: authState.error['message'] ?? 'Validation Failed',
                                          //         errors: authState.error['errors'], // <--- Pass the map here!
                                          //         icon: Icons.gpp_bad_outlined,
                                          //         alignment: Alignment.topCenter,
                                          //         duration: const Duration(
                                          //           seconds: 8,
                                          //         ), // Give them time to read
                                          //       );

                                          String errorRaw =
                                              authState.error ??
                                              'Validation Failed';

                                          Map<String, dynamic>? errorMap;
                                          String displayMessage = errorRaw;

                                          try {
                                            // If backend already gave structured error
                                            if (authState.errorData != null) {
                                              final decoded =
                                                  authState.errorData;

                                              if (decoded
                                                  is Map<String, dynamic>) {
                                                displayMessage =
                                                    decoded['message'] ??
                                                    'Validation Failed';

                                                errorMap =
                                                    decoded['errors']; // {"email": [...], "password": [...]}
                                              }
                                            } else {
                                              // Fallback: try decoding string (in case backend sends raw JSON string)
                                              final decoded = jsonDecode(
                                                errorRaw,
                                              );

                                              if (decoded
                                                  is Map<String, dynamic>) {
                                                displayMessage =
                                                    decoded['message'] ??
                                                    'Validation Failed';

                                                errorMap = decoded['errors'];
                                              }
                                            }
                                          } catch (_) {
                                            // If decoding fails, just show raw message
                                            displayMessage = errorRaw;
                                          }

                                          // // // //IMPORTANT MIGHT USE IN FUTURE
                                          // FuturisticToastT.show(
                                          //   context: context,
                                          //   message: displayMessage,
                                          //   errors: errorMap,
                                          //   icon: Icons.gpp_bad_outlined,
                                          //   alignment: Alignment.topCenter,
                                          //   duration: const Duration(
                                          //     seconds: 6,
                                          //   ),
                                          // );

                                          // ??????????????????????????????????

                                          print(
                                            'Error data: ${authState.errorData}',
                                          );

                                          // final authState = ref.read(
                                          //   authProvider,
                                          // );

                                          // Map<String, dynamic>? errorMap_2;
                                          // Object displayMessage_2 =
                                          //     authState.errorData ??
                                          //     'Validation Failed';

                                          Map<String, dynamic>? errorMap_2;
                                          String displayMessage_2 =
                                              authState.errorData
                                                  is Map<String, dynamic>
                                              ? (authState.errorData
                                                        as Map<
                                                          String,
                                                          dynamic
                                                        >)['message'] ??
                                                    'Validation Failed'
                                              : 'Validation Failed';

                                          if (authState.errorData != null &&
                                              authState.errorData
                                                  is Map<String, dynamic>) {
                                            final decoded =
                                                authState.errorData
                                                    as Map<String, dynamic>;

                                            displayMessage_2 =
                                                decoded['message'] ??
                                                'Validation Failed';

                                            // Ensure errors are properly typed
                                            if (decoded['errors'] is Map) {
                                              errorMap_2 =
                                                  (decoded['errors'] as Map)
                                                      .map(
                                                        (key, value) =>
                                                            MapEntry(
                                                              key.toString(),
                                                              List<String>.from(
                                                                value ?? [],
                                                              ),
                                                            ),
                                                      );
                                            }
                                          }

                                          // BEST POPUP
                                          final parsedError =
                                              FTErrorMessageParser.parse(
                                                authState.errorData,
                                              );
                                          Map<String, dynamic> parsed =
                                              FTErrorMessageParser.parse(
                                                authState.errorData,
                                              );

                                          FuturisticToastT.show(
                                            context: context,
                                            message: displayMessage_2,
                                            errors: errorMap_2,
                                            // message: parsedError['message'],
                                            // errors: parsedError['errors'],
                                            icon: Icons.gpp_bad_outlined,
                                            alignment: Alignment.topCenter,
                                            duration: const Duration(
                                              seconds: 6,
                                            ),
                                          );

                                          // ???????????

                                          final errorData = authState.errorData;
                                          if (errorData != null) {
                                            // // // //IMPORTANT MIGHT USE IN FUTURE
                                            // final toastContent =
                                            // ResponseDisplay.error(
                                            //   message:
                                            //       errorData['message'] ??
                                            //       'Registration failed',
                                            //   rawData: errorData,
                                            //   // Optionally pass fieldErrors if your ResponseDisplay supports it
                                            // );
                                            // FuturisticToast.showWidget(
                                            //   context: context,
                                            //   child: toastContent,
                                            //   duration: const Duration(
                                            //     seconds: 6,
                                            //   ),
                                            //   alignment:
                                            //       Alignment.topCenter,
                                            // );
                                          } else {
                                            FuturisticToastS.show(
                                              context: context,
                                              message:
                                                  authState.error ??
                                                  'Registration failed',
                                              icon: Icons.error,
                                              iconColor: Colors.redAccent,
                                              alignment: Alignment.topCenter,
                                              duration: const Duration(
                                                seconds: 5,
                                              ),
                                              showCopyButton: true,
                                            );
                                          }
                                        }
                                      }
                                    },
                                    onStepCancel: () {
                                      if (_currentStep > 0) {
                                        // setState(() => _currentStep--);
                                        setState(() {
                                          _currentStep--;
                                          _showValidationErrors = false;
                                        });
                                      }
                                    },
                                    controlsBuilder: (context, details) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            if (details.currentStep > 0)
                                              Expanded(
                                                child: CustomAdvancedButton(
                                                  height: 50,
                                                  label: 'Back',
                                                  variant:
                                                      ButtonVariant.secondary,
                                                  onPressed:
                                                      details.onStepCancel!,
                                                ),
                                              ),
                                            if (details.currentStep > 0)
                                              const SizedBox(width: 8),
                                            Expanded(
                                              child: CustomAdvancedButton(
                                                height: 50,
                                                label: details.currentStep < 2
                                                    ? 'Next'
                                                    : (_isRegistering
                                                          ? 'Signing Up...'
                                                          : 'Sign Up'),

                                                variant: ButtonVariant.primary,
                                                onPressed:
                                                    details.onStepContinue!,
                                                loading: _isRegistering,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    steps: [
                                      Step(
                                        title: const Text(
                                          'Identification',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Column(
                                          children: [
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              isRequired: true,
                                              hint: 'Contact Person',
                                              icon: Icons.person,
                                              controller: _contactPersonCtrl,
                                            ),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              isRequired: true,
                                              hint: 'Phone',
                                              icon: Icons.phone,
                                              controller: _phoneCtrl,
                                              keyboardType: TextInputType.phone,
                                            ),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              isRequired: true,
                                              hint: 'Email',
                                              icon: Icons.email,
                                              controller: _emailCtrl,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                            ),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              hint: 'Address',
                                              icon: Icons.location_on,
                                              controller: _addressCtrl,
                                            ),
                                          ],
                                        ),
                                        isActive: _currentStep >= 0,
                                      ),
                                      Step(
                                        title: const Text(
                                          'Company Details',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Column(
                                          children: [
                                            CustomTextField(
                                              isRequired: true,
                                              hint: 'Company',
                                              icon: Icons.business,
                                              controller: _companyCtrl,
                                            ),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              hint: 'PIN',
                                              icon: Icons.badge,
                                              controller: _pinCtrl,
                                            ),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              hint: 'ID No',
                                              icon: Icons.perm_identity,
                                              controller: _idnoCtrl,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              isRequired: true,
                                              hint: 'IRA No',
                                              icon: Icons.verified_user,
                                              controller: _iraNoCtrl,
                                            ),
                                          ],
                                        ),
                                        isActive: _currentStep >= 1,
                                      ),
                                      Step(
                                        title: const Text(
                                          'Login Credentials',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Column(
                                          children: [
                                            // _buildTextField( 'Comm New Business', Icons.attach_money, controller: _commNewCtrl, keyboardType: TextInputType.number, ),
                                            // _buildTextField('Comm Renewal',Icons.refresh,controller: _commRenewalCtrl,keyboardType:TextInputType.number, ),
                                            // _buildTextField( 'WTax', Icons.percent, controller: _wtaxCtrl, keyboardType: TextInputType.number, ),
                                            // _buildTextField( 'Comm Calc', Icons.calculate, controller: _commCalcCtrl, keyboardType: TextInputType.number,),
                                            // _buildTextField( 'Branch ID', Icons.store, controller: _branchIdCtrl, keyboardType: TextInputType.number,),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              isRequired: true,
                                              hint: 'Password',
                                              icon: Icons.lock,
                                              obscureText: true,
                                              controller: _passwordCtrl,
                                            ),
                                            const SizedBox(height: 9),
                                            CustomTextField(
                                              isRequired: true,
                                              hint: 'Confirm Password',
                                              icon: Icons.lock_outline,
                                              obscureText: true,
                                              controller: _confirmPasswordCtrl,
                                            ),
                                          ],
                                        ),
                                        isActive: _currentStep >= 2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // GestureDetector(
                                  //   onTap: () => context.go('/login'),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       const Text(
                                  //         "Already have an account? ",
                                  //         style: TextStyle(
                                  //           color: Colors.white70,
                                  //         ),
                                  //       ),
                                  //       const Text(
                                  //         "Login",
                                  //         style: TextStyle(
                                  //           color: Colors.blueAccent,
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 16,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  GestureDetector(
                                    onTap: () => context.go('/login'),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Already have an account? ",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),

                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          onEnter: (_) => setState(
                                            () => _isHoveringLoginText = true,
                                          ),
                                          onExit: (_) => setState(
                                            () => _isHoveringLoginText = false,
                                          ),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: _isHoveringLoginText
                                                    ? Colors.greenAccent
                                                          .withOpacity(0.7)
                                                    : Colors.white.withOpacity(
                                                        0.15,
                                                      ),
                                              ),
                                              boxShadow: _isHoveringLoginText
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors
                                                            .greenAccent
                                                            .withOpacity(0.25),
                                                        blurRadius: 15,
                                                        spreadRadius: 1,
                                                      ),
                                                    ]
                                                  : [],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 10,
                                                  sigmaY: 10,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  child: const Text(
                                                    "Login",
                                                    style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );

                    if (isMobile) {
                      return Stack(children: [modelWidget, formWidget]);
                    } else {
                      return Row(
                        children: [
                          modelWidget,
                          Expanded(child: formWidget),
                        ],
                      );
                    }
                    // ),
                    // ),
                    // ],
                  },
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      context.go('/login'); // or '/' if onboarding is root
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// const Text(
  //   'Or Continue With',
  //   style: TextStyle(
  //     fontSize: 14,
  //     fontWeight: FontWeight.bold,
  //     color: Colors.white,
  //   ),
  // ),
  // const SizedBox(height: 8),
  // Row(
  //   children: [
  //     Expanded(
  //       child: CustomAdvancedButton(
  //         height: 14,
  //         label: AppStrings.continueWithApple,
  //         variant: ButtonVariant.apple,
  //         onPressed: () {},
  //       ),
  //     ),
  //     const SizedBox(width: 8),
  //     Expanded(
  //       child: CustomAdvancedButton(
  //         iconRight: true,
  //         height: 10,
  //         label: "Google",
  //         variant: ButtonVariant.google,
  //         onPressed: () {},
  //       ),
  //     ),
  //   ],
  // ),

  
  // Widget _buildTextField(
  //   String hint,
  //   IconData icon, {
  //   bool obscureText = false,
  //   TextInputType? keyboardType,
  //   required TextEditingController controller,
  // }) {
  //   return Container(
  //     height: 36,
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.white.withOpacity(0.2)),
  //     ),
  //     child: TextField(
  //       controller: controller,
  //       obscureText: obscureText,
  //       keyboardType: keyboardType,
  //       style: const TextStyle(color: Colors.white),
  //       decoration: InputDecoration(
  //         hintText: hint,
  //         hintStyle: const TextStyle(color: Colors.white54),
  //         prefixIcon: Icon(icon, color: Colors.white70, size: 20),
  //         border: InputBorder.none,
  //         contentPadding: const EdgeInsets.symmetric(vertical: 12),
  //       ),
  //       onTap: () {
  //         if (Responsive.isMobile(context)) {
  //           setState(() => _isFocused = true);
  //         }
  //       },
  //       onEditingComplete: () {
  //         setState(() => _isFocused = false);
  //         FocusScope.of(context).unfocus();
  //       },
  //     ),
  //   );
  // }