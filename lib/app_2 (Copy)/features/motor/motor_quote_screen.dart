import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/utils/error_parser.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/features/motor/motor_save_screen.dart';
import 'package:insured/app_2/features/motor/section/motor_quote_result_screen.dart';
// import 'package:insured/app_2/features/motor/section/motor_quote_result_screen.dart';
import 'package:insured/app_2/features/motor/widgets/left_section.dart';
import 'package:insured/app_2/features/motor/widgets/right_section.dart';
import 'package:insured/app_2/providers/motor_provider.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/providers/settings_provider.dart';

class MotorQuoteScreen extends ConsumerStatefulWidget {
  const MotorQuoteScreen({super.key});

  @override
  ConsumerState<MotorQuoteScreen> createState() => _MotorQuoteScreenState();
}

class _MotorQuoteScreenState extends ConsumerState<MotorQuoteScreen> {
  final _formKey = GlobalKey<FormState>();

  final valueController = TextEditingController();
  final yearController = TextEditingController();
  // final tonnageController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();

  // so niliadd izi
  final seatsController = TextEditingController();
  final tonnageController = TextEditingController();

  bool excessProtector = false;
  bool politicalViolence = false;

  String? selectedClass;
  String? selectedCoverage;
  String? selectedScope;
  String? selectedCoverPeriod;
  String? selectedPsvType;
  String? selectedMatatuDays;

  String? _previousError;
  bool _isFormExpanded = true;
  String? _currentQuoteCacheKey;
  // @override
  // void dispose() {
  //   valueController.dispose();
  //   yearController.dispose();
  //   tonnageController.dispose();
  //   makeController.dispose();
  //   modelController.dispose();
  //   super.dispose();
  // }
  @override
  void initState() {
    super.initState();

    // ref.read(motorProvider.notifier).clearError();
    final currentError = ref.read(motorProvider).error;
    _previousError = currentError;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentError != null) {
        ref.read(motorProvider.notifier).clearError();
      }
    });

    // valueController.addListener(_tryAutoFetch);
    // yearController.addListener(_tryAutoFetch);
    // tonnageController.addListener(_tryAutoFetch);
    // makeController.addListener(_tryAutoFetch);
    // modelController.addListener(_tryAutoFetch);

    valueController.addListener(_clearQuote);
    yearController.addListener(_clearQuote);
    tonnageController.addListener(_clearQuote);
    makeController.addListener(_clearQuote);
    modelController.addListener(_clearQuote);
    seatsController.addListener(_clearQuote);
  }

  @override
  void dispose() {
    valueController.removeListener(_clearQuote);
    yearController.removeListener(_clearQuote);
    tonnageController.removeListener(_clearQuote);
    makeController.removeListener(_clearQuote);
    modelController.removeListener(_clearQuote);
    seatsController.removeListener(_clearQuote);
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    _clearQuote();
    if (!_formKey.currentState!.validate()) return;

    if (selectedScope == null) {
      FuturisticToastT.show(
        context: context,
        message: 'Please select all dropdown values',
        icon: Icons.error,
        iconColor: Colors.redAccent,
        alignment: Alignment.topCenter,
      );
      return;
    }

    final request = MotorQuoteRequest(
      // value: double.tryParse(valueController.text) ?? 200,
      coverPeriod: selectedCoverPeriod!,
      year: int.tryParse(yearController.text) ?? 0,
      vehicleClass: selectedClass!,
      coverage: selectedCoverage!,
      scope: selectedScope!,
      subcover: '',
      value: valueController.doubleValue ?? 0,
      // tonnage: double.tryParse(tonnageController.text) ?? 0,
      tonnage: tonnageController.doubleValue ?? 0,

      pll: int.tryParse(seatsController.text) ?? 0, // number of passengers
      make: makeController.text,
      model: modelController.text,
      insurerIds: [],
      // seatsController,
      // tonnageController,
    );

    // final jsonRequest = jsonEncode(request.toJson());
    // print('Motor Quote Request JSON: $jsonRequest');
    const encoder = JsonEncoder.withIndent('  ');
    print('Motor Quote Request:\n${encoder.convert(request.toJson())}');

    final cache = ref.read(motorSaveCacheProvider);

    final cacheKey =
        'motor_quote_${selectedClass}_${selectedCoverage}_${selectedScope}_${selectedCoverPeriod}_${valueController.text}_${yearController.text}_${tonnageController.text}_${makeController.text}_${modelController.text}';

    // ==================== CACHE HIT ====================
    // if (cache.containsKey(cacheKey)) {
    //   final cachedJson = cache.get(cacheKey);
    //   if (cachedJson != null) {
    //     try {
    //       final jsonMap =
    //           jsonDecode(cachedJson as String) as Map<String, dynamic>;
    //       final cachedResponse = MotorQuoteResponse.fromJson(jsonMap);

    //       // Load into provider
    //       ref.read(motorProvider.notifier).state = ref
    //           .read(motorProvider.notifier)
    //           .state
    //           .copyWith(isLoading: false, quoteResponse: cachedResponse);

    //       // 🔥 THIS WAS MISSING — now we lock the key so quotes show again
    //       setState(() {
    //         _currentQuoteCacheKey = cacheKey;
    //         _isFormExpanded = false;
    //       });

    //       const encoder = JsonEncoder.withIndent('  ');
    //       print("🚀 Loaded quote from cache (same parameters): $cacheKey");
    //       print('🚀 Loaded quote from cache:\n${encoder.convert(jsonMap)}');
    //       return;
    //     } catch (e) {
    //       print("Cache corrupted, falling back to API");
    //     }
    //   }
    // }

    // ===================================================

    // Save form data
    cache.put('selectedCoverPeriod', selectedCoverPeriod);
    cache.put('selectedClass', selectedClass);
    cache.put('value', valueController.text);
    cache.put('year', yearController.text);
    cache.put('coverage', selectedCoverage);
    cache.put('scope', selectedScope);
    cache.put('excessProtector', excessProtector.toString());
    cache.put('politicalViolence', politicalViolence.toString());

    try {
      final response = await ref.read(motorProvider.notifier).getQuote(request);

      if (response != null && mounted) {
        setState(() {
          _isFormExpanded = false;
          _currentQuoteCacheKey = cacheKey;
        });

        final jsonStr = jsonEncode(response.toJson());
        cache.put(cacheKey, jsonStr);
        print("💾 Quote cached for future reuse");
      } else if (mounted) {
        FuturisticToastT.show(
          context: context,
          message: 'Ooops! No quotes found for current selection',
          icon: Icons.info_outline,
          iconColor: Colors.orange,
        );
      }
    } catch (e) {
      if (!mounted) return;

      final error = ErrorParser.fromRaw(e);

      FuturisticToastT.show(
        context: context,
        message: error.message,
        errors: error.errors,
        icon: Icons.warning_amber_rounded,
        alignment: Alignment.topCenter,
      );

      print("❌ Error: $e");
    }
  }

  void _showErrorDialog(String message) {
    final error = ErrorParser.fromRaw(message);
    print('Yooo tryign debug: $error.');
    FuturisticToastT.show(
      context: context,
      // message: e.toString(),
      message: error.message,
      errors: error.errors,
      icon: Icons.error_outline,
      alignment: Alignment.topCenter,
    );

    // FuturisticToastT.show(
    //   context: context,
    //   message: message,
    //   icon: Icons.check_circle,
    //   iconColor: Colors.redAccent,
    //   alignment: Alignment.topCenter,
    // );
  }

  void motorSaveScreen(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Crucial for text fields & keyboard
      backgroundColor: Colors.transparent, // Allows the glassmorphism to show
      barrierColor: Colors.black.withOpacity(0.5), // Dims the background
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.98,
        child: const MotorSaveScreen(),
      ),
    );

    // If the modal returns true, refresh your client list or state
    if (result == true) {
      // ref.refresh(yourClientProvider);
      debugPrint("Client created! Refreshing UI...");
    }
  }

  void _clearQuote() {
    //   // Safe: schedule after current frame finishes building
    // Remove the PostFrameCallback. It's causing the race condition.
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      ref.read(motorProvider.notifier).clearQuote();
      setState(() {
        _currentQuoteCacheKey = null;
      });
    }
  }

  Timer? _debounceTimer;
  void _tryAutoFetch() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      final canAutoFetch =
          selectedClass != null &&
          selectedScope != null &&
          selectedCoverPeriod != null &&
          (selectedScope != 'Comprehensive' ||
              (valueController.text.isNotEmpty &&
                  yearController.text.isNotEmpty));

      if (canAutoFetch && !_formKey.currentState!.validate()) {
        // missing required → don't fetch, but still clear old quote
        _clearQuote();
        return;
      }

      if (canAutoFetch) {
        _submit(); // auto fetch
      } else {
        _clearQuote(); // hide old quotes
      }
    });
  }

  void _regenerateQuote() {
    setState(() {
      _isFormExpanded = true;
    });
    _clearQuote();
  }

  void _handleExcessProtectorChanged(bool? v) {
    setState(() {
      excessProtector = v ?? false;
    });
  }

  void _handlePoliticalViolenceChanged(bool? v) {
    setState(() {
      politicalViolence = v ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(motorProvider);

    if (state.error != null &&
        state.error != _previousError &&
        state.quoteResponse == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showErrorDialog(state.error!);
      });
      _previousError = state.error;
    }
    if (state.isLoading) _previousError = null;
    final isLight = Theme.of(context).brightness == Brightness.light;

    // if (state.quoteResponse != null &&
    //     !state.isLoading &&
    //     state.error == null) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (mounted) context.push('/motor/quote-result');
    //   });
    // }
    final themeMode = ref.watch(settingsProvider).themeMode;

    final effectiveIsDark = themeMode == 'System'
        ? MediaQuery.of(context).platformBrightness == Brightness.dark
        : themeMode == 'Dark';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            size: 32,
          ),
          onPressed: () {
            context.go('/dashboard');
          },
        ),

        // title: const CustomText('Generate Quote', type: CustomTextType.header),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText('Generate Quote', type: CustomTextType.header),

            IconButton(
              icon: Icon(
                effectiveIsDark ? Icons.dark_mode : Icons.light_mode,
                color: effectiveIsDark ? const Color(0xFF00FFB2) : Colors.black,
              ),
              onPressed: () {
                final currentMode = ref.read(settingsProvider).themeMode;

                String nextMode;
                if (currentMode == 'System') {
                  final isDarkNow =
                      MediaQuery.of(context).platformBrightness ==
                      Brightness.dark;
                  nextMode = isDarkNow ? 'Light' : 'Dark';
                } else {
                  nextMode = currentMode == 'Dark' ? 'Light' : 'Dark';
                }

                ref.read(settingsProvider.notifier).setThemeMode(nextMode);
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 16 : 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // if (state.quoteResponse == null
                  // // && state.error == null
                  // )
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide
                            ? constraints.maxWidth * 1.00
                            : constraints.maxWidth,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(
                              () => _isFormExpanded = !_isFormExpanded,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    'Quote Details',
                                    type: CustomTextType.paragraph,
                                  ),
                                  AnimatedRotation(
                                    turns: _isFormExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.expand_more,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // const CustomText(
                          //   'Enter Vehicle Details',
                          //   type: CustomTextType.header,
                          // ),
                          // const SizedBox(height: 20),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: _isFormExpanded
                                ? Center(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: isWide
                                            ? constraints.maxWidth * 0.50
                                            : constraints.maxWidth,
                                      ),
                                      child: Column(
                                        children: [
                                          MotorFormLeftSection(
                                            selectedClass: selectedClass,
                                            onClassSelected: (v) {
                                              setState(() => selectedClass = v);
                                              _clearQuote();
                                            },
                                          ),
                                          const SizedBox(height: 24),

                                          if (selectedClass != null)
                                            Column(
                                              children: [
                                                MotorFormRightSection(
                                                  selectedClass: selectedClass,
                                                  selectedCoverage:
                                                      selectedCoverage,
                                                  onCoverageChanged: (v) {
                                                    setState(
                                                      () =>
                                                          selectedCoverage = v,
                                                    );
                                                    _clearQuote();
                                                  },
                                                  selectedScope: selectedScope,
                                                  onScopeChanged: (v) {
                                                    setState(
                                                      () => selectedScope = v,
                                                    );
                                                    _clearQuote();
                                                  },
                                                  selectedCoverPeriod:
                                                      selectedCoverPeriod,
                                                  onCoverPeriodChanged: (v) {
                                                    setState(
                                                      () =>
                                                          selectedCoverPeriod =
                                                              v,
                                                    );
                                                    _clearQuote();
                                                  },
                                                  valueController:
                                                      valueController,
                                                  yearController:
                                                      yearController,

                                                  // excessProtectorSelected: excessProtector,
                                                  // onExcessProtectorChanged: _handleExcessProtectorChanged,
                                                  // politicalViolenceSelected: politicalViolence,
                                                  // onPoliticalViolenceChanged: _handlePoliticalViolenceChanged,
                                                  seatsController:
                                                      seatsController,
                                                  tonnageController:
                                                      tonnageController,
                                                  psvTypeSelected:
                                                      selectedPsvType,
                                                  onPsvTypeChanged: (v) {
                                                    setState(
                                                      () => selectedPsvType = v,
                                                    );
                                                    _clearQuote();
                                                  },
                                                  matatuDaysSelected:
                                                      selectedMatatuDays,
                                                  onMatatuDaysChanged: (v) {
                                                    setState(
                                                      () => selectedMatatuDays =
                                                          v,
                                                    );
                                                    _clearQuote();
                                                  },
                                                ),

                                                const SizedBox(height: 24),
                                                CustomAdvancedButton(
                                                  width: 400,
                                                  loading: state.isLoading,
                                                  label: state.isLoading
                                                      ? "Getting Quote..."
                                                      : 'Get Quote',
                                                  variant:
                                                      ButtonVariant.primary,
                                                  onPressed: state.isLoading
                                                      ? () {}
                                                      : _submit,
                                                  isDisabled:
                                                      _isSubmitDisabled(),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // if (state.quoteResponse != null && !state.isLoading
                  // // && state.error == null
                  // )
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 16),
                  //     child: MotorQuoteResultSection(
                  //       options: state.quoteResponse!.options ?? [],
                  //       selectedCoverage: selectedCoverage,
                  //       selectedScope: selectedScope,
                  //       selectedCoverPeriod: selectedCoverPeriod,
                  //       vehicleValue:
                  //           double.tryParse(valueController.text) ?? 0,
                  //       yom: int.tryParse(yearController.text) ?? 0,
                  //     ),
                  //   ),
                  if (state.quoteResponse != null &&
                      !state.isLoading &&
                      _currentQuoteCacheKey != null &&
                      _currentQuoteCacheKey ==
                          'motor_quote_${selectedClass}_${selectedCoverage}_${selectedScope}_${selectedCoverPeriod}_${valueController.text}_${yearController.text}_${tonnageController.text}_${makeController.text}_${modelController.text}')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: MotorQuoteResultSection(
                        options: state.quoteResponse!.options ?? [],
                        selectedCoverage: selectedCoverage,
                        selectedScope: selectedScope,
                        selectedCoverPeriod: selectedCoverPeriod,
                        vehicleValue:
                            double.tryParse(valueController.text) ?? 0,
                        yom: int.tryParse(yearController.text) ?? 0,
                        excessProtectorSelected: excessProtector,
                        politicalViolenceSelected: politicalViolence,
                        onRegenerate: _regenerateQuote,
                        onExcessProtectorChanged: _handleExcessProtectorChanged,
                        onPoliticalViolenceChanged:
                            _handlePoliticalViolenceChanged,
                      ),
                    )
                  else if (state.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Center(
                        child: Column(
                          children: [
                            // CircularProgressIndicator(
                            //   color: Theme.of(context).primaryColor,
                            // ),
                            const SizedBox(height: 12),
                            CustomText(
                              'Fetching quotes...',
                              type: CustomTextType.paragraph,
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 100, bottom: 100),
                      child: Center(
                        child: Opacity(
                          opacity: 0.05,
                          child: CustomText(
                            // 'No quotes yet — fill the form and get a quote!',
                            'No quotes yet — fill the form and get a quote!',
                            type: CustomTextType.paragraph,
                            color: Colors.grey[600],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),

      // FloatingActionButton.extended(
      // floatingActionButton: FloatingActionButton.extended(
      floatingActionButton: Visibility(
        visible: false,
        child: FloatingActionButton(
          onPressed: () => motorSaveScreen(context),

          // backgroundColor: const Color(0xFF00FFB2).withOpacity(0.1),
          elevation: isLight ? 16 : 20,
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withOpacity(isLight ? 1 : 0.25),
          child: Icon(
            Icons.save,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(1.0),
          ),
        ),
      ),
    );
  }

  bool _isSubmitDisabled() {
    // return selectedClass == null ||
    //     selectedCoverage == null ||
    //     selectedScope == null ||
    //     // Cover period OR matatu days — only one is visible at a time
    //     (selectedPsvType != 'Matatu' && selectedCoverPeriod == null) ||
    //     (selectedPsvType == 'Matatu' && selectedMatatuDays == null) ||
    //     // PSV extras
    //     (selectedCoverage == 'PSV' && selectedPsvType == null) ||
    //     // Seats required for PSV and Commercial
    //     (selectedCoverage == 'PSV' && seatsController.text.trim().isEmpty) ||
    //     (selectedCoverage == 'Commercial' &&
    //         seatsController.text.trim().isEmpty) ||
    //     (selectedCoverage == 'Commercial' &&
    //         tonnageController.text.trim().isEmpty) ||
    //     // Comprehensive extras
    //     (selectedScope == 'Comprehensive' &&
    //         (valueController.text.trim().isEmpty ||
    //             yearController.text.trim().isEmpty));
    // 1. Basic selections
    if (selectedClass == null) return true;
    if (selectedCoverage == null) return true;
    if (selectedScope == null) return true;

    // 2. Cover period / Matatu days
    // if (selectedPsvType != 'Matatu' && selectedCoverPeriod == null) return true;
    // if (selectedPsvType == 'Matatu' && selectedMatatuDays == null) return true;

    // 3. PSV type if coverage is PSV
    final isPSV = selectedCoverage?.toLowerCase().contains('psv') ?? false;
    if (isPSV && seatsController.text.trim().isEmpty) return true;
    // if (isPSV) return true;

    // 4. Seats requirement for PSV and Commercial
    final isCommercial =
        selectedCoverage?.toLowerCase().startsWith('commercial') ?? false;
    final isCommercialInst =
        selectedCoverage?.toLowerCase() == 'commercial institutional vehicles';
    // if ((isPSV || isCommercial) && seatsController.text.trim().isEmpty)
    //   return true;
    if (isPSV && seatsController.text.trim().isEmpty) return true;
    if (isCommercialInst && seatsController.text.trim().isEmpty) return true;

    // 5. Tonnage requirement for Commercial (excluding Commercial Institutional Vehicles)
    // if (isCommercial &&
    //     !isCommercialInst &&
    //     tonnageController.text.trim().isEmpty)
    //   return true;
    if (isCommercial &&
        !isCommercialInst &&
        selectedClass?.toLowerCase() != 'tuktuk' &&
        tonnageController.text.trim().isEmpty)
      return true;

    // 6. Comprehensive extras
    if (selectedScope == 'Comprehensive') {
      if (valueController.text.trim().isEmpty) return true;
      // if (yearController.text.trim().isEmpty) return true;
      final isTuktuk = selectedClass?.toLowerCase() == 'tuktuk';
      if (!isTuktuk && yearController.text.trim().isEmpty) return true;
    }

    return false;
  }
}
