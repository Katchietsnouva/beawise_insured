import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/error_parser.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart';
import 'package:insured/app_2/core/widgets/custom_label_value_text.dart';
import 'package:insured/app_2/core/widgets/custom_super_tab_bar.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';
import 'package:insured/app_2/features/motor/quoter_benefit_providers.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_provider.dart';
import 'package:insured/app_2/providers/motor_provider.dart';
import 'package:insured/app_2/data/models/motor_save_model.dart';
import 'package:insured/app_2/features/motor/motor_document_upload_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MotorSaveScreen extends ConsumerStatefulWidget {
  final QuoteOption? selectedQuote;
  final String? selectedCoverage;
  final String? selectedScope;
  final String? selectedCoverPeriod;
  final double? initialVehicleValue;
  final int? initialYom;
  // final bool excessProtectorSelected;
  // final bool politicalViolenceSelected;

  const MotorSaveScreen({
    super.key,
    this.selectedQuote,
    this.selectedCoverage,
    this.selectedScope,
    this.selectedCoverPeriod,
    this.initialVehicleValue,
    this.initialYom,
    // required this.excessProtectorSelected,
    // required this.politicalViolenceSelected,
    // this.excessProtectorSelected = false,
    // this.politicalViolenceSelected = false,
  });

  @override
  ConsumerState<MotorSaveScreen> createState() => _MotorSaveScreenState();
}

class _MotorSaveScreenState extends ConsumerState<MotorSaveScreen> {
  //////////////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  double _parseCommaNumber(String? value) {
    if (value == null) return 0.0;
    final cleaned = value.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  bool _isStep1Valid() {
    if (_currentStep != 0) return true; // Only validate on step 1

    if (_clientMode == 0) {
      // Existing client mode: must have a selected client
      return _selectedClient != null;
    } else {
      // New client mode: all required fields must be non-empty
      return firstNameController.text.trim().isNotEmpty &&
          lastNameController.text.trim().isNotEmpty &&
          clientEmailCtrl.text.trim().isNotEmpty &&
          clientPhoneCtrl.text.trim().isNotEmpty &&
          clientIdnoCtrl.text.trim().isNotEmpty &&
          clientPinCtrl.text.trim().isNotEmpty;
    }
  }

  // ─── Central premium calculator ───────────────────────────────────────────────
  ({
    double newBasicPremium,
    double totalTaxes,
    double totalPremium,
    List<TaxItem> computedTaxes,
    List<VehicleBenefit> vehicleBenefits,
  })
  _calculatePremium(QuoteOption quote) {
    double benefitAdd = 0;
    final List<VehicleBenefit> vehicleBenefits = [];

    for (final b in quote.benefits) {
      // "included: true" benefits are always added, no checkbox needed
      if (b.included) {
        vehicleBenefits.add(
          VehicleBenefit(benefitId: b.id, rate: 0, premium: 0),
        );
        // included benefits don't change basicPremium per the spec
        continue;
      }

      final isPVT = b.name.toUpperCase().contains('PVT');
      final isExcess = b.name.toUpperCase().contains('EXCESS');

      // final selected =
      //     (isPVT && widget.politicalViolenceSelected) ||
      //     (isExcess && widget.excessProtectorSelected);

      final excessProtectorSelected = ref.watch(excessProtectorProvider);
      final politicalViolenceSelected = ref.watch(politicalViolenceProvider);

      final selected =
          (isPVT && politicalViolenceSelected) ||
          (isExcess && excessProtectorSelected);

      if (selected) {
        final effectiveAmount = b.amount > 0 ? b.amount : b.minimum;
        benefitAdd += effectiveAmount;
        vehicleBenefits.add(
          VehicleBenefit(
            benefitId: b.id,
            rate: double.tryParse(b.rate) ?? 0,
            premium: effectiveAmount,
          ),
        );
      }
    }

    // // final newBasicPremium = quote.basicPremium + benefitAdd;
    // final newBasicPremium = quote.amount + benefitAdd;

    // final newBasicPremium = quote.benefits.isEmpty
    //     ? quote.amount
    //     : quote.amount + benefitAdd;

    final newBasicPremium = quote.basicPremium + benefitAdd;

    double totalTaxes = 0;
    final List<TaxItem> computedTaxes = [];

    for (final tax in quote.taxes) {
      double amount = 0;
      if (tax.calculations == 'On Basic') {
        // rate is a percentage e.g. "0.25" means 0.25%
        amount = (double.parse(tax.rate) / 100) * newBasicPremium;
      } else if (tax.calculations == 'Duty') {
        amount = double.parse(tax.rate); // fixed amount
      }
      totalTaxes += amount;
      computedTaxes.add(
        TaxItem(
          taxId: tax.id,
          rate: tax.rate,
          amount: amount.toStringAsFixed(0),
        ),
      );
    }

    final totalPremium = newBasicPremium + totalTaxes;

    return (
      newBasicPremium: newBasicPremium,
      totalTaxes: totalTaxes,
      totalPremium: totalPremium,
      computedTaxes: computedTaxes,
      vehicleBenefits: vehicleBenefits,
    );
  }
  //////////////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  bool _showMore = false;
  Map<String, dynamic>? _dmvicResult;
  bool _isCheckingDmvic = false;
  final _formKey = GlobalKey<FormState>();
  // bool _isNewClient = true; // true = new client form, false = select existing
  int _clientMode = 0; // 0 = existing client, 1 = new client

  Client? _selectedClient;
  List<Client> _allClients = [];
  late final MemoryCacheService _motorCache;

  int _currentStep = 0;
  bool _isLoading = false;
  final _searchController = TextEditingController();
  List<Client> _filteredClients = [];
  void _filterClients(String query, List<Client> allClients) {
    if (query.isEmpty) {
      _filteredClients = allClients;
    } else {
      _filteredClients = allClients.where((c) {
        final q = query.toLowerCase();
        return c.name.toLowerCase().contains(q) ||
            c.client_no.toLowerCase().contains(q) ||
            c.email.toLowerCase().contains(q) ||
            c.mobile.toLowerCase().contains(q);
      }).toList();
    }
    setState(() {});
  }

  // Client controllers
  late var firstNameController = TextEditingController();
  late var lastNameController = TextEditingController();

  final clientNameCtrl = TextEditingController();
  final clientEmailCtrl = TextEditingController();
  final clientPhoneCtrl = TextEditingController();
  final clientIdnoCtrl = TextEditingController();
  final clientPinCtrl = TextEditingController();

  // Policy controllers
  String? selectedCoverPeriod;
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final insurerIdCtrl = TextEditingController();
  String? classSaved;
  String? coverageSaved;
  String? scopeSaved;
  String? vehicelValueSaved;
  final subClassCtrl = TextEditingController();
  final totalBasicCtrl = TextEditingController();
  final taxesCtrl = TextEditingController();
  final premiumCtrl = TextEditingController();
  final markupCtrl = TextEditingController();
  final markupValueCtrl = TextEditingController();

  // Vehicle controllers
  final regnoCtrl = TextEditingController();
  final makeCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final chasisCtrl = TextEditingController();
  final engineCtrl = TextEditingController();
  final ccCtrl = TextEditingController();
  final yomCtrl = TextEditingController();
  final seatsCtrl = TextEditingController();
  final tonnageCtrl = TextEditingController();
  final valueCtrl = TextEditingController();
  final basicPremiumCtrl = TextEditingController();
  int? _selectedInstallment; // 1, 2, or 3
  // Taxes – simplified; you can expand later
  List<TaxItem> taxesList = [];

  // Document picks for Comprehensive cover (passed to upload sheet after save)
  List<int>? _logbookBytes;
  List<int>? _kraPinBytes;
  List<int>? _idDocBytes;
  String? _logbookName;
  String? _kraPinName;
  String? _idDocName;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final query = _searchController.text;
      if (query.isNotEmpty && _selectedClient != null) {
        setState(() {
          _selectedClient = null;
        });
      }
      _filterClients(query, _allClients);
    });

    startDateCtrl.addListener(_updateEndDate);
    startDateCtrl.addListener(
      () => _motorCache.put('startDate', startDateCtrl.text),
    );

    // late final MemoryCacheService _motorCache;
    // final motorCache = ref.read(motorSaveCacheProvider);
    _motorCache = ref.read(motorSaveCacheProvider);

    getSaves(_motorCache);
    putSaves(_motorCache);

    if (widget.selectedQuote != null) {
      _applyQuote(widget.selectedQuote!);
      final cachedInstallment = _motorCache.get('premium_installments');
      if (cachedInstallment != null) {
        _selectedInstallment = int.tryParse(cachedInstallment.toString());
      } else {
        _selectedInstallment = 1;
      }
    }
    // ;

    firstNameController.addListener(() => setState(() {}));
    lastNameController.addListener(() => setState(() {}));
    clientEmailCtrl.addListener(() => setState(() {}));
    clientPhoneCtrl.addListener(() => setState(() {}));
    clientIdnoCtrl.addListener(() => setState(() {}));
    clientPinCtrl.addListener(() => setState(() {}));
  }

  void getSaves(MemoryCacheService motorCache) {
    _clientMode = int.tryParse(motorCache.get('clientMode') ?? '0') ?? 0;
    final cachedClientJson = motorCache.get('selectedClientData');
    if (cachedClientJson != null && _clientMode == 0) {
      try {
        final Map<String, dynamic> clientMap = jsonDecode(cachedClientJson);
        _selectedClient = Client.fromJson(clientMap);
        // Note: Ensure your Client model has a fromJson factory!
      } catch (e) {
        debugPrint("Error restoring cached client: $e");
      }
    }
    selectedCoverPeriod =
        // widget.selectedCoverPeriod ??
        motorCache.get('selectedCoverPeriod');
    classSaved = motorCache.get('selectedClass');
    scopeSaved = motorCache.get('scope');
    vehicelValueSaved = motorCache.get('scope');

    final cachedInstallment = motorCache.get('premium_installments');
    if (cachedInstallment != null) {
      _selectedInstallment = int.tryParse(cachedInstallment.toString());
    }
    print(motorCache.getAll());
    print('this is the motorCache: ${motorCache.getAll()}');
    coverageSaved = motorCache.get('coverage');

    firstNameController.text = motorCache.get('firstName') ?? '';
    lastNameController.text = motorCache.get('lastName') ?? '';
    clientEmailCtrl.text = motorCache.get('clientEmail') ?? '';
    clientPhoneCtrl.text = motorCache.get('clientPhone') ?? '';
    clientIdnoCtrl.text = motorCache.get('clientIdno') ?? '';
    clientPinCtrl.text = motorCache.get('clientPin') ?? '';

    // KEEP - UI state listener (not cache related)
    //!!!!!!!!!!!!!!!!!!!!!!!!!!
    regnoCtrl.addListener(() => setState(() {}));
    //!!!!!!!!!!!!!!!!!!!!!!!!!!

    clientNameCtrl.text = motorCache.get('clientName') ?? '';
    // Policy ctrls
    startDateCtrl.text = motorCache.get('startDate') ?? '';
    endDateCtrl.text = motorCache.get('endDate') ?? '';
    // Vehicle ctrls
  }

  bool get isTPO => (scopeSaved ?? '').toUpperCase() == 'TPO';
  bool get isComprehensive =>
      (scopeSaved ?? widget.selectedScope ?? '').toLowerCase() ==
      'comprehensive';

  void putSaves(MemoryCacheService motorCache) {
    regnoCtrl.addListener(() {
      setState(() {});
    });
    endDateCtrl.addListener(() => motorCache.put('endDate', endDateCtrl.text));
    insurerIdCtrl.addListener(
      () => motorCache.put('insurerId', insurerIdCtrl.text),
    );
    totalBasicCtrl.addListener(
      () => motorCache.put('totalBasic', totalBasicCtrl.text),
    );
    // Vehicle Listeners
    regnoCtrl.addListener(() => motorCache.put('regno', regnoCtrl.text));
  }

  Future<void> _checkDoubleInsurance() async {
    if (regnoCtrl.text.trim().isEmpty) {
      FuturisticToastS.show(
        context: context,
        message: 'Please enter Registration Number first',
        icon: Icons.warning,
        alignment: Alignment.topCenter,
      );
      return;
    }

    setState(() => _isCheckingDmvic = true);

    try {
      final authState = ref.read(authProvider);
      final token = authState.bearerToken;
      final response = await ApiService.postDmvicDoubleInsurance(
        token: token!,
        registration: regnoCtrl.text.trim(),
        startDate: startDateCtrl.text,
        expiringDate: endDateCtrl.text,
      );

      setState(() {
        _dmvicResult = response;
      });

      if (response['success'] == true) {
        HapticFeedback.vibrate();
      }

      // FuturisticToastS.show(context: context, message: response., )
    } catch (e) {
      debugPrint("DMVIC Check Error: $e");
    } finally {
      setState(() => _isCheckingDmvic = false);
    }
  }

  void _applyQuote(QuoteOption quote) {
    // Basic insurer info
    insurerIdCtrl.text = quote.insurerId.toString();
    markupCtrl.text = quote.markup.toStringAsFixed(0);
    markupValueCtrl.text = quote.markupValue.toStringAsFixed(0);

    basicPremiumCtrl.text = quote.basicPremium.toStringAsFixed(0);

    // Compute total premium (basic + benefits + taxes)
    double totalBenefits = 0;
    final excessProtectorSelected = ref.read(excessProtectorProvider);
    final politicalViolenceSelected = ref.read(politicalViolenceProvider);

    // final List<VehicleBenefit> benefitList = [];

    for (var b in quote.benefits) {
      // // Assuming each benefit has 'id', 'rate', 'amount'
      // // final amount = (b['amount'] as num?)?.toDouble() ?? 0;
      // final amount = b.amount > 0 ? b.amount : b.minimum;
      // totalBenefits += amount;
      // benefitList.add(
      //   VehicleBenefit(
      //     benefitId: b.id,
      //     // // rate: (b['rate'] as num).toDouble(),
      //     // rate: num.tryParse(b['rate'].toString())?.toDouble() ?? 0,
      //     rate: double.tryParse(b.rate) ?? 0,
      //     premium: amount,
      //   ),
      // );
      bool include = false;
      if (b.name == 'Excess Protector' && excessProtectorSelected)
        include = true;
      else if (b.name == 'PVT' && politicalViolenceSelected)
        include = true;
      else if (b.included)
        include = true;

      if (include) {
        final amount = b.amount > 0 ? b.amount : b.minimum;
        totalBenefits += amount;
      }
    }

    // // Compute taxes based on basic premium and tax rules
    // double totalTaxes = 0;
    // final List<TaxItem> computedTaxes = [];
    // for (var tax in quote.taxes) {
    //   double amount = 0;
    //   if (tax.calculations == 'On Basic') {
    //     amount = (double.parse(tax.rate) / 100) * quote.basicPremium;
    //   } else if (tax.calculations == 'Duty') {
    //     amount = double.parse(tax.rate); // fixed duty
    //   }
    //   totalTaxes += amount;
    //   computedTaxes.add(
    //     TaxItem(
    //       taxId: tax.id,
    //       rate: tax.rate,
    //       amount: amount.toStringAsFixed(0),
    //     ),
    //   );
    // }

    // taxesList = computedTaxes;
    // // You might want to store benefitList in a state variable for later use
    // // (add a field like List<VehicleBenefit> _benefits = [];)

    // // Set premium controller (basic + benefits + taxes)
    // double totalPremium = quote.basicPremium + totalBenefits + totalTaxes;
    // premiumCtrl.text = totalPremium.toStringAsFixed(0);
    final newBasic = quote.basicPremium + totalBenefits;

    // Then calculate taxes on newBasic (not on original basic)
    double totalTaxes = 0;
    for (var tax in quote.taxes) {
      if (tax.calculations == 'On Basic') {
        totalTaxes += (double.parse(tax.rate) / 100) * newBasic;
      } else if (tax.calculations == 'Duty') {
        totalTaxes += double.parse(tax.rate);
      }
    }

    final totalPremium = newBasic + totalTaxes;
    premiumCtrl.text = totalPremium.toStringAsFixed(0);
  }

  @override
  void dispose() {
    clientNameCtrl.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    clientEmailCtrl.dispose();
    clientPhoneCtrl.dispose();
    clientIdnoCtrl.dispose();
    clientPinCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    insurerIdCtrl.dispose();
    subClassCtrl.dispose();
    totalBasicCtrl.dispose();
    taxesCtrl.dispose();
    premiumCtrl.dispose();
    markupCtrl.dispose();
    markupValueCtrl.dispose();
    regnoCtrl.dispose();
    makeCtrl.dispose();
    modelCtrl.dispose();
    bodyCtrl.dispose();
    colorCtrl.dispose();
    chasisCtrl.dispose();
    engineCtrl.dispose();
    ccCtrl.dispose();
    yomCtrl.dispose();
    seatsCtrl.dispose();
    tonnageCtrl.dispose();
    valueCtrl.dispose();
    basicPremiumCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(QuoteOption quote) async {
    // Future<void> _submit() async {
    // if (!(_formKey.currentState?.validate() ?? false)) {
    // if (!_formKey.currentState!.validate()) {

    final _getQuotecache = ref.read(motorFormCacheProvider);

    final vehicleValueStr =
        _getQuotecache.get('motor_vehicle_value') as String?;

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      HapticFeedback.heavyImpact();
      print('Motor save Form not ready, fill req fields');
      return;
    }

    final calc = _calculatePremium(quote);

    setState(() => _isLoading = true);
    try {
      setState(() => _isLoading = true);

      final request = MotorSaveRequest(
        client: MotorClient(
          name: '${firstNameController.text} ${lastNameController.text}'.trim(),
          email: clientEmailCtrl.text,
          phone: clientPhoneCtrl.text,
          idno: clientIdnoCtrl.text,
          pin: clientPinCtrl.text,
          riskManagerId: 1, // placeholder – fetch from API later
          salesPersonId: null,
          branchId: 1, // placeholder
        ),
        policy: MotorPolicy(
          coverPeriod: selectedCoverPeriod ?? ' ',
          startDate: startDateCtrl.text,
          endDate: endDateCtrl.text,
          // insurerId: int.tryParse(insurerIdCtrl.text) ?? 0,
          // insurerId: int.tryParse(quote.insurerId as String) ?? 2,
          insurerId: quote.insurerId,

          vehicleClass: classSaved ?? ' ',

          // subClass: coverageSaved ?? "N/A",
          coverage: coverageSaved ?? " ",

          scope: scopeSaved ?? ' ',
          //  totalBasic: 400,
          totalBasic: calc.newBasicPremium,
          // taxes: double.tryParse(taxesCtrl.text) ?? 0,
          taxes: calc.totalTaxes,
          // premium: quote.basicPremium ?? 0,
          premium: calc.totalPremium,
          markup: quote.markup,
          markupValue: quote.markupValue,
          premiumInstalments: _selectedInstallment ?? 1,
        ),
        // taxes: computedTaxes,
        taxes: calc.computedTaxes,
        vehicles: [
          Vehicle(
            // coverage: widget.selectedCoverage ?? 'Comprehensive',
            coverage: widget.selectedScope ?? 'N/A',
            rate: quote.rate,
            regno: regnoCtrl.text,
            make: makeCtrl.text.isNotEmpty ? makeCtrl.text : 'N/A',
            model: modelCtrl.text.isNotEmpty ? modelCtrl.text : ' ',
            body: bodyCtrl.text.isNotEmpty ? bodyCtrl.text : ' ',
            color: colorCtrl.text.isNotEmpty ? colorCtrl.text : ' ',
            chasis: chasisCtrl.text,
            engine: engineCtrl.text.isNotEmpty ? engineCtrl.text : '1',
            cc: 0,
            yom: (widget.initialYom != null && widget.initialYom! >= 1900)
                ? widget.initialYom!
                : (int.tryParse(yomCtrl.text) ?? 1910),
            seats: int.tryParse(_getQuotecache.get('motor_seats') ?? '0') ?? 0,
            tonnage:
                double.tryParse(_getQuotecache.get('motor_tonnage') ?? '0') ??
                0,

            // tonnage: double.tryParse(tonnageCtrl.text) ?? 4,
            // value: double.tryParse(valueCtrl.text) ?? 100000,
            // value:
            //     widget.initialVehicleValue ??
            //     double.tryParse(valueCtrl.text) ??
            //     0 ,
            // value: _getQuotecache.get('motor_vehicle_value'),
            // value: vehicleValueStr?.numericDouble ?? 0.0,
            value: _parseCommaNumber(vehicleValueStr),
            basicPremium: calc.newBasicPremium,
            benefits: calc.vehicleBenefits,
          ),
        ],
      );
      final notifier = ref.read(motorProvider.notifier);
      final response = await notifier.savePolicy(request);

      print("THis is the policy to be saved: $request");

      print("🚀 Sending MotorSaveRequest:");
      final encoder = const JsonEncoder.withIndent('  ');
      print(encoder.convert(request.toJson()));
      print("✅ Received response:");
      print(encoder.convert(response?.toJson()));

      if (response != null && mounted) {
        final policy = MotorSaveResponseToLocalStore(
          message: response.message,
          risknote: response.risknote,
          id: response.id,
          clientNo: response.clientNo,
          clientKey: response.clientKey,
          createdAt: DateTime.now(),
        );

        await PolicyMotorSaveResponseToLocalStore.addPolicy(policy);

        ref.read(motorSaveCacheProvider).clear();

        final content =
            '${response.message}  Risknote: ${response.risknote}   ';
        FuturisticToastS.show(
          context: context,
          message: content,
          icon: Icons.error_outline,
          alignment: Alignment.topCenter,
          duration: const Duration(seconds: 10),
        );

        if (isComprehensive && mounted) {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.black.withValues(alpha: 0.82),
            builder: (_) => MotorDocumentUploadSheet(
              risknote: response.risknote.toString(),
              clientNo: response.clientNo,
              clientKey: response.clientKey,
              policyId: response.id,
              logbookBytes: _logbookBytes,
              logbookName: _logbookName,
              kraPinBytes: _kraPinBytes,
              kraPinName: _kraPinName,
              idDocBytes: _idDocBytes,
              idDocName: _idDocName,
            ),
          );
          return;
        }

        if (mounted) context.goNamed('quotes', extra: response.id);

        // if (policyResponse != null && mounted) {
        //   showModalBottomSheet(
        //     context: context,
        //     isScrollControlled: true,
        //     backgroundColor: Colors.transparent,
        //     builder: (_) => PolicyDetailsModalFull(response: policyResponse),
        //   );
        // }
      }
    } catch (e) {
      print('oyaaaa');
      // if (mounted) {
      //   // ScaffoldMessenger.of( context, ).showSnackBar(SnackBar(content: Text(e.toString())));
      final error = ErrorParser.fromRaw(e);

      // 2. Pass the results directly to your Toast
      FuturisticToastT.show(
        context: context,
        message: error.message,
        errors: error.errors,
        icon: Icons.warning_amber_rounded,
        alignment: Alignment.topCenter,
      );

      // if (mounted) _showErrorToast(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updateEndDate() {
    if (startDateCtrl.text.isEmpty || selectedCoverPeriod == null) return;

    try {
      DateTime start = DateFormat('yyyy-MM-dd').parse(startDateCtrl.text);
      DateTime end;

      if (selectedCoverPeriod == 'annual') {
        end = DateTime(
          start.year + 1,
          start.month,
          start.day,
        ).subtract(const Duration(days: 1));
      } else if (selectedCoverPeriod == 'tor') {
        end = DateTime(
          start.year,
          start.month + 1,
          start.day,
        ).subtract(const Duration(days: 1));
      } else {
        return;
      }

      final newDate = DateFormat('yyyy-MM-dd').format(end);

      if (endDateCtrl.text != newDate) {
        setState(() {
          endDateCtrl.text = newDate;
        });
      }
    } catch (e) {
      debugPrint("Date parsing error: $e");
    }
  }

  Widget _buildClientFormFields({bool isRequired = true}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final isWide = constraints.maxWidth > 700;
        final isWide = !Responsive.isMobile(context);
        Widget firstName = CustomTextField(
          hint: 'First Name',
          icon: Icons.person,
          controller: firstNameController,
          isRequired: isRequired,
          cache: _motorCache,
          cacheKey: 'firstName',
        );
        Widget lastName = CustomTextField(
          hint: 'Last Name',
          icon: Icons.person_outline,
          controller: lastNameController,
          isRequired: isRequired,
          cache: _motorCache,
          cacheKey: 'lastName',
        );
        Widget restOfColumn = Column(
          children: [
            CustomTextField(
              hint: 'ID Number',
              icon: Icons.badge,
              maxNumberOfCharHL: 10,
              controller: clientIdnoCtrl,
              isRequired: isRequired,
              cache: _motorCache,
              cacheKey: 'clientIdno',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hint: 'PIN',
              isPin: true,
              hintLabel: 'PIN format: A123456789B',
              icon: Icons.lock,
              controller: clientPinCtrl,
              isRequired: isRequired,
              cache: _motorCache,
              cacheKey: 'clientPin',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hint: 'Email',
              isEmail: true,
              icon: Icons.email,
              controller: clientEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              isRequired: isRequired,
              cache: _motorCache,
              cacheKey: 'clientEmail',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hint: 'Phone',
              icon: Icons.phone,
              hintLabel: '07.../01...',
              maxNumberOfCharHL: 10,
              controller: clientPhoneCtrl,
              keyboardType: TextInputType.phone,
              isRequired: isRequired,
              cache: _motorCache,
              cacheKey: 'clientPhone',
            ),
          ],
        );

        return Column(
          children: [
            isWide
                ? Row(
                    children: [
                      Expanded(child: firstName),
                      const SizedBox(width: 16),
                      Expanded(child: lastName),
                    ],
                  )
                : Column(
                    children: [firstName, const SizedBox(height: 12), lastName],
                  ),
            const SizedBox(height: 12),

            restOfColumn,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),

      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 6,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).primaryColor.withOpacity(0.08)
                : Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(height: Responsive.isMobile(context) ? 2 : 20),
                        _buildHeader(),
                        SizedBox(height: Responsive.isMobile(context) ? 8 : 10),
                        _buildHorizontalProgress(),
                        SizedBox(height: Responsive.isMobile(context) ? 2 : 4),
                        Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.1),
                          height: 20,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOutCubic,
                          child: _getStepContent(),
                        ),
                        const SizedBox(height: 20),
                        // _buildBottomActions(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildBottomActions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearClientControllers() {
    firstNameController.clear();
    lastNameController.clear();
    clientEmailCtrl.clear();
    clientPhoneCtrl.clear();
    clientIdnoCtrl.clear();
    clientPinCtrl.clear();
  }

  void _populateClientData(Client client) {
    final nameParts = client.name.trim().split(' ');
    if (nameParts.isNotEmpty) {
      firstNameController.text = nameParts.first;
      if (nameParts.length > 1) {
        lastNameController.text = nameParts.sublist(1).join(' ');
      } else {
        lastNameController.text = '';
      }
    } else {
      firstNameController.text = '';
      lastNameController.text = '';
    }

    clientEmailCtrl.text = client.email;
    clientPhoneCtrl.text = client.mobile;
    clientIdnoCtrl.text = client.idno.toString();
    clientPinCtrl.text = client.pin.toString();
  }

  Widget _buildExistingClientList() {
    return Column(
      children: [
        // if (_selectedClient == null) ...[
        //   CustomTextField(
        //     hint: 'Search by name, ID, email, phone',
        //     icon: Icons.search,
        //     controller: _searchController,
        //   ),
        // ],
        SizedBox(height: Responsive.isMobile(context) ? 8 : 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedClient == null
              ? Column(
                  key: const ValueKey('search_bar'),
                  children: [
                    CustomTextField(
                      hint: 'Search by name/ID/email/phone',
                      icon: Icons.search,
                      controller: _searchController,
                    ),
                    const SizedBox(height: 16),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedClient != null
              ? _buildSelectedClientDetailsCard() // Show details if selected
              : _buildSearchResultsList(), // Otherwise show the list
        ),
      ],
    );
  }

  Widget _buildSearchResultsList() {
    return Consumer(
      builder: (context, ref, child) {
        final clientsAsync = ref.watch(clientsProvider);
        return clientsAsync.when(
          data: (clients) {
            _allClients = clients;
            if (_filteredClients.isEmpty && _searchController.text.isEmpty) {
              _filteredClients = clients;
            }

            if (_filteredClients.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CustomText(
                    'No clients found',
                    type: CustomTextType.paragraph,
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredClients.length,
              itemBuilder: (context, index) {
                final client = _filteredClients[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedClient = client;
                      _populateClientData(client);
                      final motorCache = ref.read(motorSaveCacheProvider);
                      final clientJson = jsonEncode(client.toJson());
                      motorCache.put('selectedClientData', clientJson);
                      _searchController.clear();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(client.name, type: CustomTextType.paragraph),
                        CustomLabelValueText(
                          label: 'ID',
                          value: client.client_no,
                        ),

                        CustomLabelValueText(
                          label: 'Email',
                          value: client.email,
                        ),

                        CustomLabelValueText(
                          label: 'Phone',
                          value: client.mobile,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          error: (err, _) => Text('Error: $err'),
        );
      },
    );
  }

  Widget _buildSelectedClientDetailsCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      key: const ValueKey('selected_client_card'),
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.favColour.withOpacity(0.2)
            : Colors.grey.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.favColour.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Client Selected ✅',
                type: CustomTextType.paragraph,
                // fontWeight: FontWeight.bold,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedClient = null;
                    _clearClientControllers();
                  });
                },
                child: const Text(
                  'Existing Client',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          _buildClientFormFields(),
        ],
      ),
    );
  }

  Widget _buildNewClientList() {
    return Container(
      child: Column(
        children: [
          // const Divider(),
          const SizedBox(height: 16),
          _buildClientFormFields(),
        ],
      ),
    );
  }

  Widget _buildClientTabs() {
    return CustomSuperTabBar(
      mode: SuperTabBarMode.ColorModeB,

      tabs: const [
        SuperTabItem(label: 'Existing Client'),
        SuperTabItem(label: 'New Client'),
      ],
      selectedIndex: _clientMode,
      onTap: (index) {
        setState(() {
          _clientMode = index;
          if (index == 1) {
            _selectedClient = null;
            _clearClientControllers();
          }
        });
        final motorCache = ref.read(motorSaveCacheProvider);
        motorCache.put('clientMode', index.toString());
        if (index == 1) motorCache.remove('selectedClientData');
      },
      // showSelectedShadow: true,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText('Create Motor Policy', type: CustomTextType.subHeader),
            CustomText(
              _currentStep == 0
                  ? 'Step 1: Client Details'
                  : _currentStep == 1
                  ? 'Step 2: Policy Details'
                  : _currentStep == 2
                  ? 'Step 3: Vehicle & Taxes'
                  : 'Step 4: Review & Confirm',
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  Widget _buildHorizontalProgress() {
    return Row(
      children: [
        _progressNode(0, 'Client'),
        _progressLine(0),
        _progressNode(1, 'Policy'),
        _progressLine(1),
        _progressNode(2, 'Vehicle'),
        _progressLine(2),
        _progressNode(3, 'Summary'),
      ],
    );
  }

  Widget _progressNode(int step, String label) {
    bool isActive = _currentStep >= step;
    Color mint = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF00FFB2)
        : Colors.green[700]!;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: Responsive.isMobile(context) ? 24 : 28,
          height: Responsive.isMobile(context) ? 24 : 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? mint.withOpacity(0.2)
                : Theme.of(context).colorScheme.surface.withOpacity(0.3),
            border: Border.all(
              color: isActive
                  ? mint
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: _currentStep > step
                ? Icon(Icons.check, size: 12, color: mint)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive
                          ? mint
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.3),
                      fontSize: 10,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _progressLine(int step) {
    Color mint = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF00FFB2)
        : Colors.green[600]!;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: _currentStep > step
            ? mint.withOpacity(0.5)
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }

  Widget _getStepContent() {
    // bool _showMore = false;
    if (_currentStep == 0) {
      return Column(
        key: const ValueKey(0),
        children: [
          Column(
            key: const ValueKey(0),
            children: [
              _buildClientTabs(),
              SizedBox(height: Responsive.isMobile(context) ? 4 : 16),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _clientMode == 0
                    // ? _existingClientSection()
                    ? _buildExistingClientList()
                    : _buildNewClientList(),
                // : combinedSingleChildScrollView,
              ),
            ],
            // ); },
          ),
        ],
      );
    } else if (_currentStep == 1) {
      return Column(
        key: const ValueKey(1),
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              Widget leftColumn = Column(
                children: [
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: 'Start Date',
                    icon: Icons.calendar_today,
                    controller: startDateCtrl,
                    isDateField: true,
                    isRequired: true,
                    // minDate: DateTime.now(),
                    minDate: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Visibility(
                    visible: !startDateCtrl.text.isEmpty,
                    child: Row(
                      children: [
                        CustomText(
                          "Will expire on: ",
                          type: CustomTextType.paragraph,
                        ),
                        Opacity(
                          opacity: 1,
                          child: CustomText(
                            "${formatHumanDate(endDateCtrl.text)}",
                            type: CustomTextType.caption,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    hint: 'Registration No',
                    forceUppercase: true,
                    icon: Icons.directions_car,
                    controller: regnoCtrl,
                    isRequired: true,
                    // minNumberOfChar: 7,
                    maxNumberOfCharHL: 12,
                    onChanged: (val) {
                      if (_dmvicResult != null)
                        setState(() => _dmvicResult = null);
                    },
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Column(
                      children: [
                        if (_dmvicResult == null) ...[
                          CustomAdvancedButton(
                            width: double.infinity,
                            // isDisabled: regnoCtrl.text.isEmpty,
                            // isDisabled: regnoCtrl.text.trim().isEmpty,
                            isDisabled: regnoCtrl.text.trim().isEmpty,
                            label: _dmvicResult == null
                                ? 'Verify insurance'
                                : 'Re-verify insurance',
                            onPressed: _checkDoubleInsurance,
                            loading: _isCheckingDmvic,
                            variant: _dmvicResult == null
                                ? ButtonVariant.primary
                                : ButtonVariant.secondary,
                          ),
                        ],
                        if (_dmvicResult != null) ...[
                          const SizedBox(height: 12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // Check for success AND if there's actually an insurer (No Records Found case)
                              color:
                                  (_dmvicResult!['success'] == true &&
                                      _dmvicResult!['insurer'] != null)
                                  ? Colors.orange.withOpacity(0.15)
                                  : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    (_dmvicResult!['success'] == true &&
                                        _dmvicResult!['insurer'] != null)
                                    ? Colors.orange
                                    : Colors.green.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  (_dmvicResult!['success'] == true &&
                                          _dmvicResult!['insurer'] != null)
                                      ? Icons.warning_amber_rounded
                                      : Icons.check_circle_outline,
                                  color:
                                      (_dmvicResult!['success'] == true &&
                                          _dmvicResult!['insurer'] != null)
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                const SizedBox(width: 10),

                                // Use Expanded here for WIDTH control
                                Expanded(
                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize.min, // crucial for height
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        (_dmvicResult!['success'] == true &&
                                                _dmvicResult!['insurer'] !=
                                                    null)
                                            ? "Already has coverage with ${_dmvicResult!['insurer']} ending ${_dmvicResult!['CoverEndDate']}. You can't continue."
                                            // : (_dmvicResult!['message'] ?? "No active double insurance found. You're good to go!"),
                                            : "No active insurance found. You're good to go!",
                                        type: CustomTextType.caption,
                                        // fontWeight: FontWeight.bold,
                                      ),

                                      // Only show "View More" if there is actually data to show
                                      if (_dmvicResult!['success'] == true &&
                                          _dmvicResult!['insurer'] != null) ...[
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () => setState(
                                            () => _showMore = !_showMore,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomText(
                                                _showMore
                                                    ? "View less"
                                                    : "View more",
                                                color: Colors.blue,
                                              ),
                                              Icon(
                                                _showMore
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                size: 18,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedCrossFade(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          crossFadeState: _showMore
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                          firstChild: const SizedBox(
                                            width: double.infinity,
                                          ),
                                          secondChild: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 8),
                                              _buildDetailRow(
                                                "End Date",
                                                _dmvicResult!['CoverEndDate'],
                                              ),
                                              _buildDetailRow(
                                                "Cert No",
                                                _dmvicResult!['CertificateNo'],
                                              ),
                                              _buildDetailRow(
                                                "Insurer",
                                                _dmvicResult!['insurer'],
                                              ),
                                              _buildDetailRow(
                                                "Chassis",
                                                _dmvicResult!['chassis'],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );
              Widget rightColumn = const SizedBox.shrink();
              return SingleChildScrollView(
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: leftColumn),
                          const SizedBox(width: 20),
                          Expanded(child: rightColumn),
                        ],
                      )
                    : Column(
                        children: [
                          leftColumn,
                          const SizedBox(height: 16),
                          rightColumn,
                        ],
                      ),
              );
            },
          ),
        ],
      );
    } else if (_currentStep == 2) {
      return Column(
        key: const ValueKey(2),
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              Widget buildInstallmentSection() {
                final maxInstallments =
                    widget.selectedQuote?.premiumInstalments ?? 1;

                // 🔁 Hide the whole section if only 1 installment is available
                if (maxInstallments <= 1) {
                  return const SizedBox.shrink();
                }

                // final maxInstallments =
                //     widget.selectedQuote?.premiumInstalments ?? 1;
                final totalPremium = double.tryParse(premiumCtrl.text) ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Divider(),

                    const CustomText(
                      "Premium Installments",
                      type: CustomTextType.paragraph,
                    ),
                    const SizedBox(height: 4),
                    const CustomText(
                      "Select the number of installments you wish to pay",
                      type: CustomTextType.caption,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(maxInstallments, (index) {
                      print(
                        "the maxInstallments from the api is: $maxInstallments",
                      );
                      final installmentNumber = index + 1;
                      final amountPerInstallment =
                          totalPremium / installmentNumber;
                      return CustomCheckbox(
                        fontSize: 14,
                        value: _selectedInstallment == installmentNumber,
                        label:
                            "$installmentNumber Installment${installmentNumber > 1 ? 's' : ''}  (@ ${ceilCurrency(amountPerInstallment)})",
                        onChanged: (_) {
                          setState(() {
                            _selectedInstallment = installmentNumber;
                          });
                          _motorCache.put(
                            'premium_installments',
                            installmentNumber.toString(),
                          );

                          print(
                            "This is the _selectedInstallment value: $_selectedInstallment , installmentNumber value: $installmentNumber  ",
                          );
                        },
                        // cache: _motorCache,
                        // cacheKey: 'premium_installments',
                      );
                    }),
                    const SizedBox(height: 100),
                  ],
                );
              }

              Widget leftColumn = Column(
                children: [
                  if (!isTPO) ...[
                    CustomTextField(
                      hint: 'Make',
                      icon: Icons.build,
                      controller: makeCtrl,
                      isRequired: !isTPO,
                      cache: _motorCache,
                      cacheKey: 'make',
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Model',
                      icon: Icons.drive_eta,
                      controller: modelCtrl,
                      isRequired: !isTPO,
                      cache: _motorCache,
                      cacheKey: 'model',
                    ),
                    const SizedBox(height: 12),
                  ],
                  CustomTextField(
                    hint: 'Chasis No',
                    icon: Icons.qr_code,
                    controller: chasisCtrl,
                    cache: _motorCache,
                    cacheKey: 'chasis',
                    minNumberOfChar: 4,
                    forceUppercase: true,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),

                  if (!isTPO) ...[
                    CustomTextField(
                      hint: 'Engine No',
                      icon: Icons.engineering,
                      controller: engineCtrl,
                      cache: _motorCache,
                      minNumberOfChar: 4,
                      cacheKey: 'engineNo',
                    ),
                    const SizedBox(height: 12),
                    // CustomTextField(
                    //   hint: 'Color',
                    //   icon: Icons.color_lens,
                    //   controller: colorCtrl,
                    // ),
                    // const SizedBox(height: 8),
                  ],
                  CustomTextField(
                    hint: 'Body',
                    icon: Icons.car_repair,
                    controller: bodyCtrl,
                    cache: _motorCache,
                    cacheKey: 'body',
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                ],
              );
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomText(
                      'Vehicle Details',
                      type: CustomTextType.paragraph,
                    ),
                    const SizedBox(height: 12),
                    // if (isTPO)
                    //   CustomText(
                    //     "Minimal details required for TPO",
                    //     type: CustomTextType.caption,
                    //     color: Theme.of(context).brightness == Brightness.dark
                    //         ? Colors.greenAccent
                    //         : Colors.green[900],
                    //   ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        leftColumn,
                        const SizedBox(height: 16),
                        buildInstallmentSection(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
      // } else if (_currentStep == 3) {
    } else {
      return _buildSummaryStep();
    }
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.9,
            child: CustomText(
              '$label: ',
              type: CustomTextType.caption,
              // fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: CustomText(
              value ?? 'N/A',
              type: CustomTextType.caption,
              color: value == null || value.isEmpty
                  ? Colors
                        .grey // Optional: Grey out empty or null values
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  int _openSectionIndex = 0; // State variable to track which accordion is open

  Widget _buildSummaryStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        // Define the 4 groups
        final sections = [
          _buildSummarySection(
            index: 0,
            title: 'Client Details',
            icon: Icons.person_pin_rounded,
            content: _buildClientSummaryGrid(),
          ),
          _buildSummarySection(
            index: 1,
            title: 'Policy Details',
            icon: Icons.policy_rounded,
            content: _buildPolicySummaryGrid(),
          ),
          _buildSummarySection(
            index: 2,
            title: 'Vehicle Details',
            icon: Icons.directions_car_filled_rounded,
            content: _buildVehicleSummaryGrid(),
          ),
          _buildSummarySection(
            index: 3,
            title: 'Premium & Taxes',
            icon: Icons.payments_rounded,
            content: _buildFinancialSummaryGrid(),
          ),
        ];

        if (isWide) {
          // Desktop: 2 Columns
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    sections[0],
                    const SizedBox(height: 16),
                    sections[1],
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    sections[2],
                    const SizedBox(height: 16),
                    sections[3],
                  ],
                ),
              ),
            ],
          );
        } else {
          // Mobile: 1 Column
          return Column(
            children: [
              CustomText('Confirm Details ', type: CustomTextType.paragraph),
              const SizedBox(height: 12),
              ...sections
                  .expand((s) => [s, const SizedBox(height: 12)])
                  .toList(),
            ],
          );
        }
      },
    );
  }

  Widget _buildSummarySection({
    required int index,
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    bool isOpen = _openSectionIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surface.withOpacity(isOpen ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOpen
              ? AppColors.favColour.withOpacity(1.0)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                setState(() => _openSectionIndex = isOpen ? -1 : index),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isOpen
                        ? Theme.of(context).brightness == Brightness.light
                              ? Colors.green[900]!
                              : Colors.greenAccent
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const SizedBox(width: 12),
                  CustomText(
                    title,
                    type: CustomTextType.paragraph,
                    // fontWeight: FontWeight.bold,
                    color: isOpen
                        ? Theme.of(context).brightness == Brightness.light
                              ? Colors.green[900]!
                              : Colors.greenAccent
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const Spacer(),
                  // Rotating Chevron
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isOpen
                          ? Theme.of(context).brightness == Brightness.light
                                ? Colors.green[900]!
                                : Colors.greenAccent.withOpacity(0.8)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Collapsible Content
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: content,
            ),
            crossFadeState: isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label.toUpperCase(),
          type: CustomTextType.caption,
          color: Colors.grey,
          maxLines: 1,
        ),
        CustomText(
          value.isEmpty ? "N/A" : value,
          type: CustomTextType.paragraph,
          // fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildClientSummaryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: Responsive.isMobile(context) ? 2.5 : 5.0,
      children: [
        _buildInfoItem(
          "Name",
          "${firstNameController.text} ${lastNameController.text}",
        ),
        _buildInfoItem("Email", clientEmailCtrl.text),
        _buildInfoItem("Phone", clientPhoneCtrl.text),
        _buildInfoItem("Id Number", clientIdnoCtrl.text),
        _buildInfoItem("Pin", clientPinCtrl.text),
      ],
    );
  }

  Widget _buildPolicySummaryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: Responsive.isMobile(context) ? 2.5 : 5.0,
      children: [
        // _buildInfoItem("Start Date", startDateCtrl.text),
        // _buildInfoItem("End Date", endDateCtrl.text),
        _buildInfoItem("Start Date", formatHumanDate(startDateCtrl.text)),
        _buildInfoItem("End Date", formatHumanDate(endDateCtrl.text)),
        _buildInfoItem("Class", classSaved ?? "-"),
        _buildInfoItem("Coverage", coverageSaved ?? "-"),
        _buildInfoItem("Scope", scopeSaved ?? "-"),
        _buildInfoItem("Selected Cover Period", selectedCoverPeriod ?? "-"),
      ],
    );
  }

  Widget _buildVehicleSummaryGrid() {
    final _getQuotecache = ref.read(motorFormCacheProvider);
    final vehicleValue = _getQuotecache.get('motor_vehicle_value');

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: Responsive.isMobile(context) ? 2.5 : 5.0,
      children: [
        _buildInfoItem("Reg No", regnoCtrl.text),
        if (!isTPO) ...[
          _buildInfoItem("Make", makeCtrl.text),
          _buildInfoItem("Model", modelCtrl.text),
          _buildInfoItem("Engine", engineCtrl.text),
          _buildInfoItem("Vehicle Value", vehicleValue ?? "-"),
        ],
        _buildInfoItem("Body", bodyCtrl.text),
        _buildInfoItem("Chassis", chasisCtrl.text),
      ],
    );
  }

  Widget _buildFinancialSummaryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: Responsive.isMobile(context) ? 2.5 : 5.0,
      children: [
        _buildInfoItem(
          "Basic Premium",
          // basicPremiumCtrl.text),
          ceilCurrency(double.tryParse(basicPremiumCtrl.text) ?? 0),
        ),

        // _buildInfoItem("Markup", markupCtrl.text),
        // _buildInfoItem("Total Premium", premiumCtrl.text),
        _buildInfoItem(
          "Total Premium",
          ceilCurrency(double.tryParse(premiumCtrl.text) ?? 0),
        ),
        _buildInfoItem(
          "Installments selected",
          _selectedInstallment?.toString() ?? "Not set",
        ),

        _buildInfoItem(
          "Per Installment Amount",
          _selectedInstallment != null && _selectedInstallment! > 0
              ? ceilCurrency(
                  (double.tryParse(premiumCtrl.text) ?? 0) /
                      _selectedInstallment!,
                )
              : "Not set",
        ),

        // final totalPremium = double.tryParse(premiumCtrl.text) ?? 0;
        //       final amountPerInstallment =
        //           totalPremium / installmentNumber;
      ],
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: CustomAdvancedButton(
              height: Responsive.isMobile(context) ? 38 : null,
              customFontSize: Responsive.isMobile(context) ? 14 : null,
              label: "Back",
              onPressed: () => setState(() => _currentStep--),
              variant: ButtonVariant.secondary,
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 16),
        Expanded(
          child: CustomAdvancedButton(
            height: Responsive.isMobile(context) ? 38 : null,
            customFontSize: Responsive.isMobile(context) ? 14 : null,
            loading: _isLoading,
            label: _currentStep < 3 ? 'Next Step' : 'Save Policy',
            // 1. DYNAMIC DISABLE LOGIC
            // isDisabled: _dmvicResult == null || (_dmvicResult != null && ),

            // (_currentStep == 2 && _dmvicResult != null) ||
            // (_currentStep == 3 && widget.selectedQuote == null),
            isDisabled: _currentStep == 0
                ? !_isStep1Valid()
                : (_currentStep == 1 &&
                      (_dmvicResult == null || // Disable if not checked yet
                          (_dmvicResult!['success'] == true &&
                              _dmvicResult!['insurer'] !=
                                  null) // Disable if actual conflict found
                          )),
            onPressed: () {
              if (_currentStep < 3) {
                final form = _formKey.currentState;
                if (form == null || !form.validate()) {
                  HapticFeedback.heavyImpact();
                  return;
                }
                setState(() => _currentStep++);
              } else if (_currentStep == 2 && _dmvicResult == null) {
                FuturisticToastS.show(
                  context: context,
                  message: 'Please verify with DMVIC before proceeding',
                  icon: Icons.security,
                  alignment: Alignment.topCenter,
                );
                return;
              } else {
                // _submit();
                // _submit(widget.selectedQuote!);
                if (widget.selectedQuote == null) {
                  final msg = "No quote selected";
                  print(msg);
                  FuturisticToastT.show(
                    context: context,
                    message: msg,
                    icon: Icons.error_outline,
                    alignment: Alignment.topCenter,
                  );
                  return;
                }

                _submit(widget.selectedQuote!);
              }
            },
            variant: ButtonVariant.primary,
          ),
        ),
      ],
    );
  }
}
