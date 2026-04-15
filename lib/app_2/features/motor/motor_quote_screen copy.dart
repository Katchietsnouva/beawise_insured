import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/widgets/custom_card_choice.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/features/motor/motor_save_screen.dart';
import 'package:insured/app_2/features/motor/section/motor_quote_result_screen.dart';
// import 'package:insured/app_2/features/motor/section/motor_quote_result_screen.dart';
import 'package:insured/app_2/features/motor/widgets/left_section.dart';
import 'package:insured/app_2/features/motor/widgets/right_section.dart';
import 'package:insured/app_2/providers/motor_provider.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';
import 'package:go_router/go_router.dart';

class MotorQuoteScreen extends ConsumerStatefulWidget {
  const MotorQuoteScreen({super.key});

  @override
  ConsumerState<MotorQuoteScreen> createState() => _MotorQuoteScreenState();
}

class _MotorQuoteScreenState extends ConsumerState<MotorQuoteScreen> {
  final _formKey = GlobalKey<FormState>();

  final valueController = TextEditingController();
  final yearController = TextEditingController();
  final tonnageController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();

  String? selectedClass;
  String? selectedCoverage;
  String? selectedScope;
  String? selectedCoverPeriod;

  final List<String> vehicleClasses = ['Motor', 'Tuktuk', 'Motorcycle'];
  final List<String> coverPeriods = ['tor', 'annual'];
  final List<String> coverages = ['Private'];
  final List<String> scopes = ['TPO', 'Comprehensive'];

  String? _previousError;

  @override
  void dispose() {
    valueController.dispose();
    yearController.dispose();
    tonnageController.dispose();
    makeController.dispose();
    modelController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      FuturisticToastT.show(
        context: context,
        message: 'Please fill all required fields',
        icon: Icons.error,
        iconColor: Colors.redAccent,
        alignment: Alignment.topCenter,
      );
      return;
    }

    if (selectedCoverPeriod == null ||
        selectedClass == null ||
        selectedCoverage == null ||
        selectedScope == null) {
      FuturisticToastT.show(
        context: context,
        message: 'Please select all dropdown values',
        icon: Icons.error,
        iconColor: Colors.redAccent,
        alignment: Alignment.topCenter,
      );
      return;
    }

    final cache = ref.read(motorSaveCacheProvider);
    cache.put('selectedCoverPeriod', selectedCoverPeriod);
    cache.put('selectedClass', selectedClass);
    cache.put('startDate', '');
    cache.put('endDate', '');
    cache.put('value', valueController.text);
    cache.put('year', yearController.text);
    cache.put('tonnage', tonnageController.text);
    cache.put('make', makeController.text);
    cache.put('model', modelController.text);
    // also store coverage and scope if needed
    cache.put('coverage', selectedCoverage);
    cache.put('scope', selectedScope);

    final request = MotorQuoteRequest(
      value: double.tryParse(valueController.text) ?? 0,
      coverPeriod: selectedCoverPeriod!,
      year: int.parse(yearController.text),
      vehicleClass: selectedClass!,
      coverage: selectedCoverage!,
      scope: selectedScope!,
      subcover: '',
      tonnage: double.tryParse(tonnageController.text) ?? 0,
      make: makeController.text,
      model: modelController.text,
      insurerIds: [],
    );

    var encoder = const JsonEncoder.withIndent('  ');
    print(
      "This is the payload for request:\n${encoder.convert(request.toJson())}",
    );

    final motorProviderNotifier = ref.read(motorProvider.notifier);
    final response = await motorProviderNotifier.getQuote(request);

    if (response != null && mounted) {
      print(
        "This is the motor response:\n${encoder.convert(response.toJson())}",
      );
      // context.push('/motor/quote-result');
    }
  }

  void _showErrorDialog(String message) {
    FuturisticToastT.show(
      context: context,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.redAccent,
      alignment: Alignment.topCenter,
    );
  }

  void motorSaveScreen(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Crucial for text fields & keyboard
      backgroundColor: Colors.transparent, // Allows the glassmorphism to show
      barrierColor: Colors.black.withOpacity(0.5), // Dims the background
      builder: (context) => const MotorSaveScreen(),
    );

    // If the modal returns true, refresh your client list or state
    if (result == true) {
      // ref.refresh(yourClientProvider);
      debugPrint("Client created! Refreshing UI...");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(motorProvider);

    if (state.error != null && state.error != _previousError) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            // color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 32,
          ),
          onPressed: () {
            // Navigator.of(context).pop();
            // context.pop();
            context.go('/dashboard');
          },
        ),

        title: const CustomText(
          'Motor Quote Screen',
          type: CustomTextType.header,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 16 : 2),
            child: Form(
              key: _formKey,
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const CustomText(
                          'Enter Vehicle Details',
                          type: CustomTextType.header,
                        ),
                        const SizedBox(height: 20),

                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: MotorFormLeftSection(
                                      selectedClass: selectedClass,
                                      onClassSelected: (v) =>
                                          setState(() => selectedClass = v),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: MotorFormRightSection(
                                      selectedCoverage: selectedCoverage,
                                      onCoverageChanged: (v) =>
                                          setState(() => selectedCoverage = v),
                                      selectedScope: selectedScope,
                                      onScopeChanged: (v) =>
                                          setState(() => selectedScope = v),
                                      selectedCoverPeriod: selectedCoverPeriod,
                                      onCoverPeriodChanged: (v) => setState(
                                        () => selectedCoverPeriod = v,
                                      ),
                                      valueController: valueController,
                                      yearController: yearController,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  MotorFormLeftSection(
                                    selectedClass: selectedClass,
                                    onClassSelected: (v) =>
                                        setState(() => selectedClass = v),
                                  ),
                                  const SizedBox(height: 24),
                                  MotorFormRightSection(
                                    selectedCoverage: selectedCoverage,
                                    onCoverageChanged: (v) =>
                                        setState(() => selectedCoverage = v),
                                    selectedScope: selectedScope,
                                    onScopeChanged: (v) =>
                                        setState(() => selectedScope = v),
                                    selectedCoverPeriod: selectedCoverPeriod,
                                    onCoverPeriodChanged: (v) =>
                                        setState(() => selectedCoverPeriod = v),
                                    valueController: valueController,
                                    yearController: yearController,
                                  ),
                                ],
                              ),

                        const SizedBox(height: 24),
                        CustomAdvancedButton(
                          loading: state.isLoading,
                          label: state.isLoading
                              ? "Getting Quote..."
                              : 'Get Quote',
                          variant: ButtonVariant.primary,
                          onPressed: state.isLoading ? () {} : _submit,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),

                    if (state.quoteResponse != null && !state.isLoading
                    // && state.error == null
                    )
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: MotorQuoteResultSection(
                          options: state.quoteResponse!.options ?? [],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // FloatingActionButton.extended(
      // floatingActionButton: FloatingActionButton.extended(
      floatingActionButton: FloatingActionButton(
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
    );
  }
}




// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/core/widgets/custom_card_choice.dart';
// import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
// import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
// import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
// import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// import 'package:insured/app_2/core/widgets/glass_card.dart';
// import 'package:insured/app_2/providers/motor_provider.dart';
// import 'package:insured/app_2/data/models/motor_quote.dart';
// import 'package:go_router/go_router.dart';

// class MotorQuoteScreen extends ConsumerStatefulWidget {
//   const MotorQuoteScreen({super.key});

//   @override
//   ConsumerState<MotorQuoteScreen> createState() => _MotorQuoteScreenState();
// }

// class _MotorQuoteScreenState extends ConsumerState<MotorQuoteScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final valueController = TextEditingController();
//   final yearController = TextEditingController();

//   final tonnageController = TextEditingController();
//   final makeController = TextEditingController();
//   final modelController = TextEditingController();

//   String? selectedClass;
//   String? selectedCoverage;
//   String? selectedScope;
//   String? selectedCoverPeriod;

//   final List<String> vehicleClasses = ['Motor', 'Tuktuk', 'Motorcycle'];
//   final List<String> coverPeriods = ['annual', 'tor'];
//   final List<String> coverages = ['Private'];
//   final List<String> scopes = ['TPO', 'Comprehensive'];

//   String? _previousError; // ← helps us detect when error changes

//   // @override
//   // void initState() {
//   //   super.initState();

//   //   ref.listen<MotorState>(motorProvider, (previous, next) {
//   //     if (next.error != null && mounted) {
//   //       showDialog(
//   //         context: context,
//   //         builder: (_) => AlertDialog(
//   //           title: const Text('Error'),
//   //           content: Text(next.error!),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () => Navigator.pop(context),
//   //               child: const Text('OK'),
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //       // FuturisticToastT.show(
//   //       //   context: context,
//   //       //   message: next.error!,
//   //       //   icon: Icons.check_circle,
//   //       //   iconColor: Colors.greenAccent,
//   //       //   alignment: Alignment.topCenter,
//   //       // );
//   //     }
//   //   });
//   // }

//   @override
//   void dispose() {
//     valueController.dispose();
//     yearController.dispose();
//     tonnageController.dispose();
//     makeController.dispose();
//     modelController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     // if (!_formKey.currentState!.validate()) return;

//     if (!_formKey.currentState!.validate()) {
//       FuturisticToastT.show(
//         context: context,
//         message: 'Please fill all required fields',
//         icon: Icons.error,
//         iconColor: Colors.redAccent,
//         alignment: Alignment.topCenter,
//       );
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(
//       //     content: Text('Please fill all required fields'),
//       //     backgroundColor: Colors.redAccent,
//       //     behavior: SnackBarBehavior.floating,
//       //     duration: Duration(seconds: 3),
//       //   ),
//       // );
//       return;
//     }

//     if (selectedCoverPeriod == null ||
//         selectedClass == null ||
//         selectedCoverage == null ||
//         selectedScope == null) {
//       FuturisticToastT.show(
//         context: context,
//         message: 'Please select all dropdown values',
//         icon: Icons.error,
//         iconColor: Colors.redAccent,
//         alignment: Alignment.topCenter,
//       );
//       return;
//     }
//     final request = MotorQuoteRequest(
//       // value: double.parse(valueController.text),
//       value: double.tryParse(valueController.text) ?? 0,
//       coverPeriod: selectedCoverPeriod!,
//       year: int.parse(yearController.text),
//       vehicleClass: selectedClass!,
//       coverage: selectedCoverage!,
//       scope: selectedScope!,
//       subcover: '',
//       tonnage: double.tryParse(tonnageController.text) ?? 0,
//       make: makeController.text,
//       model: modelController.text,
//       insurerIds: [],
//     );
//     // // print(" THis is the payload  for request = MotorQuoteRequest(: $request");
//     // print("This is the payload for request: ${jsonEncode(request.toJson())}");
//     var encoder = JsonEncoder.withIndent('  '); // 2-space indentation
//     print(
//       "This is the payload for request:\n${encoder.convert(request.toJson())}",
//     );

//     final motorProviderNotifier = ref.read(motorProvider.notifier);
//     final response = await motorProviderNotifier.getQuote(request);
//     if (response != null && mounted) {
//       // print("its here that the change route error occurs: $response $mounted ");
//       print(
//         "This is the motor response:\n${encoder.convert(response.toJson())}",
//       );

//       context.push('/motor/quote-result');
//     }
//   }

//   void _showErrorDialog(String message) {
//     FuturisticToastT.show(
//       context: context,
//       // message: next.error!,
//       message: message,
//       // errors: message,
//       icon: Icons.check_circle,
//       iconColor: Colors.redAccent,
//       alignment: Alignment.topCenter,
//     );
//     // showDialog(
//     //   context: context,
//     //   builder: (context) => AlertDialog(
//     //     title: const Text('Error'),
//     //     content: Text(message),
//     //     actions: [
//     //       TextButton(
//     //         onPressed: () => Navigator.of(context).pop(),
//     //         child: const Text('OK'),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(motorProvider);

//     // Show popup when error appears / changes (and only once per error)
//     if (state.error != null && state.error != _previousError) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           _showErrorDialog(state.error!);
//         }
//       });
//       _previousError = state.error;
//     }

//     // Optional: clear error tracking when loading starts again or success
//     if (state.isLoading) {
//       _previousError = null;
//     }

//     // If success → navigate
//     // if (state.quote != null && !state.isLoading && state.error == null) {
//     if (state.quoteResponse != null &&
//         !state.isLoading &&
//         state.error == null) {
//       // if (!state.isLoading && state.error == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           context.push('/motor/quote-result');
//           // Optional: reset provider state here if you want
//           // ref.read(motorProvider.notifier).clearQuote();
//         }
//       });
//     }
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
//           onPressed: () {
//             // Navigator.of(context).pop();
//             // context.pop();
//             context.go('/dashboard');
//           },
//         ),
//         title: const Text('Motor Quote', style: TextStyle(color: Colors.white)),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final isWide = constraints.maxWidth > 700;
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: GlassCard(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Enter Vehicle Details',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     isWide
//                         ? Column(
//                             children: [
//                               // _buildTopCard(),
//                               const SizedBox(height: 16),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(child: _buildLeftColumn(isWide)),
//                                   const SizedBox(width: 20),
//                                   Expanded(child: _buildRightColumn()),
//                                 ],
//                               ),
//                             ],
//                           )
//                         : Column(
//                             children: [
//                               // _buildTopCard(),
//                               // const SizedBox(height: 16),
//                               _buildLeftColumn(isWide),
//                               const SizedBox(height: 16),
//                               _buildRightColumn(),
//                             ],
//                           ),

//                     const SizedBox(height: 24),
//                     // if (state.error != null)
//                     //   Padding(
//                     //     padding: const EdgeInsets.only(bottom: 8),
//                     //     child: Text(
//                     //       state.error!,
//                     //       style: const TextStyle(color: Colors.red),
//                     //     ),
//                     //   ),
//                     CustomAdvancedButton(
//                       loading: state.isLoading,
//                       label: state.isLoading ? "Getting" : 'Get Quote',
//                       variant: ButtonVariant.primary,
//                       onPressed: state.isLoading ? () {} : _submit,
//                     ),
//                     const SizedBox(height: 8),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTopCard(isWide) {
//     return Column(
//       children: [
//         CustomCardChoice<String>(
//           type: 2,
//           columns: isWide ? 3 : 2,
//           options: vehicleClasses.map((v) {
//             return ButtonCardOption(
//               key: v,
//               title: v,
//               icon: v == 'Motor'
//                   ? Icons.directions_car
//                   : v == 'Tuktuk'
//                   ? Icons.electric_rickshaw
//                   : Icons.two_wheeler,
//             );
//           }).toList(),
//           selectedKey: selectedClass,
//           onSelect: (val) => setState(() => selectedClass = val),
//         ),
//       ],
//     );
//   }

//   Widget _buildLeftColumn(isWide) {
//     return Column(
//       children: [
//         Text("Select the vehicle class"),
//         _buildTopCard(isWide),
//         const SizedBox(height: 16),

//         // CustomDropdown<String>(
//         //   hint: 'Vehicle Class',
//         //   icon: Icons.directions_car,
//         //   value: selectedClass,
//         //   items: vehicleClasses
//         //       .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//         //       .toList(),
//         //   onChanged: (val) => setState(() => selectedClass = val),
//         //   isRequired: true,
//         // ),
//         const SizedBox(height: 16),
//         CustomDropdown<String>(
//           hint: 'Coverage',
//           icon: Icons.shield,
//           value: selectedCoverage,
//           items: coverages
//               .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//               .toList(),
//           onChanged: (val) => setState(() => selectedCoverage = val),
//           isRequired: true,
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   Widget _buildRightColumn() {
//     return Column(
//       children: [
//         CustomDropdown<String>(
//           hint: 'Scope',
//           icon: Icons.public,
//           value: selectedScope,
//           items: scopes
//               .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//               .toList(),
//           onChanged: (val) => setState(() => selectedScope = val),
//           isRequired: true,
//         ),
//         const SizedBox(height: 16),

//         // CustomDropdown<String>(
//         //   hint: 'Cover Period',
//         //   icon: Icons.timelapse,
//         //   value: selectedCoverPeriod,
//         //   items: coverPeriods
//         //       .map((p) => DropdownMenuItem(value: p, child: Text(p)))
//         //       .toList(),
//         //   onChanged: (val) => setState(() => selectedCoverPeriod = val),
//         //   isRequired: true,
//         // ),

//         // ....

//         // FormField<String>(
//         //   initialValue: selectedCoverPeriod,
//         //   validator: (value) {
//         //     if (value == null || value.isEmpty) {
//         //       return 'Please select cover period';
//         //     }
//         //     return null;
//         //   },
//         //   builder: (FormFieldState<String> field) {
//         //     return CustomDropdown<String>(
//         //       hint: 'Cover Period',
//         //       icon: Icons.timelapse,
//         //       value: field.value ?? selectedCoverPeriod,
//         //       items: coverPeriods
//         //           .map((p) => DropdownMenuItem(value: p, child: Text(p)))
//         //           .toList(),
//         //       onChanged: (val) {
//         //         field.didChange(
//         //           val,
//         //         ); // ← important: tells FormField the value changed
//         //         setState(() => selectedCoverPeriod = val);
//         //       },
//         //       isRequired: true,
//         //       // Optional: show error from validator
//         //       errorText: field.errorText,
//         //     );
//         //   },
//         // ),
//         CustomDropdown<String>(
//           hint: 'Cover Period',
//           icon: Icons.timelapse,
//           value: selectedCoverPeriod,
//           items: coverPeriods
//               .map((p) => DropdownMenuItem(value: p, child: Text(p)))
//               .toList(),
//           onChanged: (val) => setState(() => selectedCoverPeriod = val),
//           isRequired: true, // automatically adds a "required" validator
//           // optional: add a custom validator if you need more logic
//           // validator: (val) => val == 'invalid' ? 'Not allowed' : null,
//         ),
//         const SizedBox(height: 16),
//         CustomTextField(
//           hint: 'Vehicle Value',
//           hintLabel: 'e.g., 800000',
//           icon: Icons.attach_money,
//           controller: valueController,
//           keyboardType: TextInputType.number,
//           isRequired: true,
//         ),

//         // const SizedBox(height: 16),
//         const SizedBox(height: 16),
//         CustomTextField(
//           hint: 'Year of Manufacture',
//           hintLabel: 'e.g., 2016',
//           icon: Icons.calendar_today,
//           controller: yearController,
//           keyboardType: TextInputType.number,
//           isRequired: true,
//         ),
//         // const SizedBox(height: 16),
//         // CustomTextField(
//         //   hint: 'Make',
//         //   hintLabel: 'e.g., Toyota',
//         //   icon: Icons.build,
//         //   controller: makeController,
//         //   isRequired: true,
//         // ),
//         // const SizedBox(height: 16),
//         // CustomTextField(
//         //   hint: 'Model',
//         //   hintLabel: 'e.g., Land Cruiser',
//         //   icon: Icons.drive_eta,
//         //   controller: modelController,
//         //   isRequired: true,
//         // ),
//         // const SizedBox(height: 16),
//         // CustomTextField(
//         //   hint: 'Tonnage (if applicable)',
//         //   hintLabel: '0',
//         //   icon: Icons.line_weight,
//         //   controller: tonnageController,
//         //   keyboardType: TextInputType.number,
//         // ),
//       ],
//     );
//   }
// }