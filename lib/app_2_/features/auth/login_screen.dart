import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart';
import 'package:insured/app_2/core/widgets/glass_card_auth.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/constants/app_colors.dart';
import 'package:insured/app_2/core/constants/app_strings.dart';
import 'package:insured/app_2/core/services/api_auth_provider.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/features/onboarding/widgets/three_d_model_viewer.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  bool _rememberMe = true;

  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;
  late final AnimationController _shimmerCtrl;

  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  bool _isHoveringCreateAccount = false;
  bool _isFocused = false;
  bool _isLoggingIn = false;
  final _formKey = GlobalKey<FormState>();

  String? _extraEmail; // store extra email

  @override
  void initState() {
    super.initState();
    final cache = ref.read(loginCacheProvider);

    // Prefer extra over cache
    // final rememberedEmail = cache.get('rememberedEmail') ?? '';

    // _emailCtrl = TextEditingController( text: cache.get('rememberedEmail') ?? '');

    // _emailCtrl = TextEditingController(text: rememberedEmail);
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();

    _emailCtrl.addListener(() => cache.put('rememberedEmail', _emailCtrl.text));

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only read extra once
    final extra = GoRouterState.of(context).extra;
    // if (_extraEmail == null) {
    // if (extra is String && extra.isNotEmpty) {
    if (extra is String && extra.isNotEmpty && extra != _extraEmail) {
      _extraEmail = extra;
      // if (_emailCtrl != null && _emailCtrl.text.isEmpty) {
      _emailCtrl.text = _extraEmail!;
      ref.read(loginCacheProvider).put('rememberedEmail', _extraEmail!);
      // }
      // }
    }
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _floatCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final authState = ref.watch(authProvider);

    return Theme(
      data: AppTheme.darkTheme,

      // Theme(
      //   data: ThemeData.dark().copyWith(
      //     primaryColor: const Color(0xFF00FFB2),
      //     scaffoldBackgroundColor: const Color(0xFF0D1F1C),
      //     textSelectionTheme: TextSelectionThemeData(
      //       selectionColor: Colors.blue.withOpacity(0.4),
      //       cursorColor: Colors.blue,
      //       selectionHandleColor: Colors.blue,
      //     ),
      //     colorScheme: ColorScheme.dark(
      //       background: Color(0xFF0D1F1C),
      //       surface: Color(0xFF132A26),

      //       onSurface: Colors.white70,
      //       onBackground: Colors.white70,

      //       secondary: Color(0xFF00E6A0),
      //       primary: const Color(0xFF0A1A17),
      //     ),
      //   ),
      child: Scaffold(
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
                colors: [
                  Color(0xFF0D1F1C),
                  Color(0xFF0F3D3E),
                  Color(0xFF145A32),
                ],
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

                      Widget modelWidget = AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        // height: size.height,
                        height:
                            size.height *
                            (_isFocused
                                ? 0.15
                                : (Responsive.isMobile(context) ? 0.7 : 0.8)),
                        width: isMobile
                            ? size.width
                            : size.width * (_isFocused ? 0.3 : 0.4),
                        child: Opacity(
                          opacity: isMobile ? 0.2 : 1.0,
                          child: Center(
                            child: isMobile
                                ? Animate(
                                    effects: [
                                      ScaleEffect(
                                        // begin: 1.0,
                                        // end: _isFocused ? 0.5 : 1.0,
                                        begin: const Offset(1.0, 1.0),
                                        end: _isFocused
                                            ? const Offset(0.5, 0.5)
                                            : const Offset(1.0, 1.0),
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      ),
                                    ],
                                    child: ThreeDModelViewer(
                                      rotationY: 1.0,
                                      floatAnim: _floatAnim,
                                      isLogin: true,
                                    ),
                                  )
                                : ThreeDModelViewer(
                                    rotationY: 1.0,
                                    floatAnim: _floatAnim,
                                    isLogin: true,
                                  ),
                          ),
                        ),
                      );

                      Widget formWidget = Center(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: Responsive.isMobile(context)
                                  ? double.infinity
                                  : 500,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: GlassCard(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      const SizedBox(height: 24),
                                      // Email field
                                      CustomTextField(
                                        isEmail: true,
                                        isRequired: true,
                                        hint: 'Email',
                                        icon: Icons.email,
                                        controller: _emailCtrl,

                                        // validator: (value) =>
                                        //     (value == null || value.isEmpty)
                                        //     ? 'Please enter your email'
                                        //     : null,
                                      ),

                                      const SizedBox(height: 12),
                                      // Password field
                                      CustomTextField(
                                        isRequired: true,
                                        hint: 'Password',
                                        icon: Icons.lock,
                                        obscureText: true,
                                        controller: _passwordCtrl,
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomCheckbox(
                                          textColor: Colors.white.withOpacity(
                                            0.8,
                                          ),
                                          value: _rememberMe,
                                          label: 'Remember Me',
                                          onChanged: (val) {
                                            setState(() {
                                              _rememberMe = val;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      CustomAdvancedButton(
                                        label: _isLoggingIn
                                            ? 'Logging In...'
                                            : AppStrings.login,
                                        variant: ButtonVariant.primary,
                                        loading: _isLoggingIn,
                                        // isDisabled: authState.isLoading,
                                        validator: () =>
                                            _emailCtrl.text.trim().isNotEmpty &&
                                            _passwordCtrl.text.isNotEmpty,

                                        // onPressed: authState.isLoading
                                        //     ? () {}
                                        //     : () async {
                                        //         FocusScope.of(context).unfocus();
                                        //         final success = await ref
                                        //             .read(authProvider.notifier)
                                        //             .login(
                                        //               _emailCtrl.text.trim(),
                                        //               _passwordCtrl.text,
                                        //             );
                                        //         if (success && mounted) {
                                        //           // After login, navigate to OTP screen (if email is pending)
                                        //           context.push('/otp');
                                        //         }
                                        //       },
                                        // // onPressed: () {
                                        // //   // TODO: authenticate
                                        // //   context.push('/dashboard');
                                        // // },
                                        // onPressed: !authState.isLoading
                                        onPressed: _isLoggingIn
                                            ? () {}
                                            : () async {
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                  HapticFeedback.heavyImpact();
                                                  return;
                                                }
                                                if (_isLoggingIn) return;
                                                ref
                                                    .read(authProvider.notifier)
                                                    .setRememberMe(_rememberMe);

                                                setState(
                                                  () => _isLoggingIn = true,
                                                );
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();

                                                Map<String, dynamic> errors =
                                                    {};
                                                if (_emailCtrl.text
                                                    .trim()
                                                    .isEmpty) {
                                                  errors['email'] = [
                                                    'The email field is requiredddd.',
                                                  ];
                                                }
                                                if (_passwordCtrl
                                                    .text
                                                    .isEmpty) {
                                                  errors['password'] = [
                                                    'The password field is requiredddd.',
                                                  ];
                                                }
                                                if (errors.isNotEmpty) {
                                                  HapticFeedback.heavyImpact();
                                                  FuturisticToastT.show(
                                                    context: context,
                                                    message:
                                                        'Required fields: fill fields for email and password',
                                                    errors: errors,
                                                    icon:
                                                        Icons.gpp_bad_outlined,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    duration: const Duration(
                                                      seconds: 6,
                                                    ),
                                                  );
                                                  setState(
                                                    () => _isLoggingIn = false,
                                                  );
                                                  return;
                                                }

                                                try {
                                                  // 1️⃣ Get the auth token first
                                                  // final token = await ref
                                                  //     .read(apiAuthProvider)
                                                  //     .getAuthToken();

                                                  final token = await ref
                                                      .read(
                                                        apiAuthProvider
                                                            .notifier,
                                                      )
                                                      .getAuthToken();

                                                  // 2️⃣ Call /agent/login with the token
                                                  final response =
                                                      await ApiService.login(
                                                        _emailCtrl.text.trim(),
                                                        _passwordCtrl.text,
                                                        token,
                                                      );

                                                  // 3️⃣ Check response
                                                  if (response['status'] ==
                                                          'success' &&
                                                      mounted) {
                                                    // Store the email and bearer token in the provider
                                                    ref
                                                        .read(
                                                          authProvider.notifier,
                                                        )
                                                        .setLoginData(
                                                          _emailCtrl.text
                                                              .trim(),
                                                          token, // the token you got from getAuthToken()
                                                        );
                                                    // FuturisticToastS.show(
                                                    //   context: context,
                                                    //   message:
                                                    //       'OTP sent to your email',
                                                    //   icon: Icons.check_circle,
                                                    //   iconColor:
                                                    //       Colors.greenAccent,
                                                    //   alignment:
                                                    //       Alignment.topCenter,
                                                    // );
                                                    // OTP sent, navigate to OTP screen
                                                    context.push('/otp');
                                                  } else {
                                                    FuturisticToastT.show(
                                                      context: context,
                                                      message:
                                                          response['message'] ??
                                                          'Validation Failed',
                                                      errors:
                                                          response['errors'], // <--- Pass the map here!
                                                      icon: Icons
                                                          .gpp_bad_outlined,
                                                      alignment:
                                                          Alignment.topCenter,
                                                      duration: const Duration(
                                                        seconds: 8,
                                                      ), // Give them time to read
                                                    );
                                                  }
                                                } catch (e) {
                                                  // 1. Remove the "Exception: " prefix if it exists
                                                  String errorRaw = e
                                                      .toString()
                                                      .replaceAll(
                                                        'Exception: ',
                                                        '',
                                                      )
                                                      .trim();

                                                  Map<String, dynamic>?
                                                  errorMap;
                                                  String displayMessage =
                                                      errorRaw;

                                                  try {
                                                    // 2. Try to decode the string as JSON
                                                    final decoded = jsonDecode(
                                                      errorRaw,
                                                    );
                                                    if (decoded
                                                        is Map<
                                                          String,
                                                          dynamic
                                                        >) {
                                                      displayMessage =
                                                          decoded['message'] ??
                                                          'Validation Failed';
                                                      errorMap =
                                                          decoded['errors']; // This is your {"email": [...], "password": [...]}
                                                    }
                                                  } catch (_) {
                                                    // If decoding fails (e.g. a real network error), display original text
                                                    displayMessage = e
                                                        .toString();
                                                  }

                                                  // 3. Show the toast with the structured data
                                                  FuturisticToastT.show(
                                                    context: context,
                                                    message: displayMessage,
                                                    errors:
                                                        errorMap, // Now passed correctly as a Map
                                                    icon:
                                                        Icons.gpp_bad_outlined,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    duration: const Duration(
                                                      seconds: 6,
                                                    ),
                                                  );
                                                } finally {
                                                  if (mounted) {
                                                    setState(
                                                      () =>
                                                          _isLoggingIn = false,
                                                    );
                                                  }
                                                }
                                              },
                                      ),
                                      const SizedBox(height: 12),

                                      TextButton(
                                        onPressed: () {
                                          context.push('/forgot-password');
                                        },
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // if (authState.isLoading)
                                      //   const Center(
                                      //     child: CircularProgressIndicator(),
                                      //   ),
                                      TextButton(
                                        onPressed: () {
                                          context.go(
                                            '/register',
                                          ); // Navigate on tap
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Don't have an account? ",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Create Account",
                                                style: TextStyle(
                                                  color: Colors.greenAccent,
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                        context.go(
                          '/onboarding',
                        ); // or '/' if onboarding is root
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
