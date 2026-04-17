import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';
import 'package:insured/app_2/providers/client_provider.dart';
import 'package:insured/app_2/providers/motor_provider.dart';
import 'package:insured/app_2/data/models/motor_save_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MotorSaveScreen extends ConsumerStatefulWidget {
  final QuoteOption? selectedQuote;
  const MotorSaveScreen({super.key, this.selectedQuote});

  @override
  ConsumerState<MotorSaveScreen> createState() => _MotorSaveScreenState();
}

class _MotorSaveScreenState extends ConsumerState<MotorSaveScreen> {
  // bool _isNewClient = true; // true = new client form, false = select existing
  int _clientMode = 0; // 0 = existing client, 1 = new client

  Client? _selectedClient;
  List<Client> _allClients = [];

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
  String? selectedClass;
  String? _coverage;
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

  // Taxes – simplified; you can expand later
  List<TaxItem> taxesList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final query = _searchController.text;
      _filterClients(query, _allClients);
    });

    startDateCtrl.addListener(_updateEndDate);

    final motorCache = ref.read(motorSaveCacheProvider);

    // Initializ
    selectedCoverPeriod = motorCache.get('selectedCoverPeriod');
    selectedClass = motorCache.get('selectedClass');
    _coverage = motorCache.get('coverage');

    firstNameController.text = motorCache.get('firstName') ?? '';
    lastNameController.text = motorCache.get('lastName') ?? '';
    clientNameCtrl.text = motorCache.get('clientName') ?? '';
    clientEmailCtrl.text = motorCache.get('clientEmail') ?? '';
    clientPhoneCtrl.text = motorCache.get('clientPhone') ?? '';
    clientIdnoCtrl.text = motorCache.get('clientIdno') ?? '';
    clientPinCtrl.text = motorCache.get('clientPin') ?? '';

    // Policy ctrls

    startDateCtrl.text = motorCache.get('startDate') ?? '';
    endDateCtrl.text = motorCache.get('endDate') ?? '';
    insurerIdCtrl.text = motorCache.get('insurerId') ?? '';
    // selectedClass = motorCache.get('selectedClass');
    subClassCtrl.text = motorCache.get('subClass') ?? '';
    totalBasicCtrl.text = motorCache.get('totalBasic') ?? '';
    taxesCtrl.text = motorCache.get('taxes') ?? '';
    premiumCtrl.text = motorCache.get('premium') ?? '';
    markupCtrl.text = motorCache.get('markup') ?? '';
    markupValueCtrl.text = motorCache.get('markupValue') ?? '';

    // Vehicle ctrls
    regnoCtrl.text = motorCache.get('regno') ?? '';
    makeCtrl.text = motorCache.get('make') ?? '';
    modelCtrl.text = motorCache.get('model') ?? '';
    bodyCtrl.text = motorCache.get('body') ?? '';
    colorCtrl.text = motorCache.get('color') ?? '';
    chasisCtrl.text = motorCache.get('chasis') ?? '';
    engineCtrl.text = motorCache.get('engine') ?? '';
    ccCtrl.text = motorCache.get('cc') ?? '';
    yomCtrl.text = motorCache.get('yom') ?? '';
    seatsCtrl.text = motorCache.get('seats') ?? '';
    tonnageCtrl.text = motorCache.get('tonnage') ?? '';
    valueCtrl.text = motorCache.get('value') ?? '';
    basicPremiumCtrl.text = motorCache.get('basicPremium') ?? '';

    // Save
    firstNameController.addListener(
      () => motorCache.put('firstName', firstNameController.text),
    );
    lastNameController.addListener(
      () => motorCache.put('lastName', lastNameController.text),
    );
    clientEmailCtrl.addListener(
      () => motorCache.put('clientEmail', clientEmailCtrl.text),
    );
    clientPhoneCtrl.addListener(
      () => motorCache.put('clientPhone', clientPhoneCtrl.text),
    );
    clientIdnoCtrl.addListener(
      () => motorCache.put('clientIdno', clientIdnoCtrl.text),
    );
    clientPinCtrl.addListener(
      () => motorCache.put('clientPin', clientPinCtrl.text),
    );

    // valueCtrl.addListener(
    //   () => motorCache.put('selectedCoverPeriod', selectedCoverPeriod),
    // );
    startDateCtrl.addListener(
      () => motorCache.put('startDate', startDateCtrl.text),
    );
    endDateCtrl.addListener(() => motorCache.put('endDate', endDateCtrl.text));
    insurerIdCtrl.addListener(
      () => motorCache.put('insurerId', insurerIdCtrl.text),
    );

    subClassCtrl.addListener(
      () => motorCache.put('subClass', subClassCtrl.text),
    );
    totalBasicCtrl.addListener(
      () => motorCache.put('totalBasic', totalBasicCtrl.text),
    );
    taxesCtrl.addListener(() => motorCache.put('taxes', taxesCtrl.text));
    premiumCtrl.addListener(() => motorCache.put('premium', premiumCtrl.text));

    markupCtrl.addListener(() => motorCache.put('markup', markupCtrl.text));
    markupValueCtrl.addListener(
      () => motorCache.put('markupValue', markupValueCtrl.text),
    );

    // Vehicle Listeners
    regnoCtrl.addListener(() => motorCache.put('regno', regnoCtrl.text));
    makeCtrl.addListener(() => motorCache.put('make', makeCtrl.text));
    modelCtrl.addListener(() => motorCache.put('model', modelCtrl.text));
    valueCtrl.addListener(() => motorCache.put('value', valueCtrl.text));
    //     regnoCtrl.text = motorCache.get('regno') ?? '';
    // makeCtrl.text = motorCache.get('make') ?? '';
    // modelCtrl.text = motorCache.get('model') ?? '';
    bodyCtrl.addListener(() => motorCache.put('body', bodyCtrl.text));
    colorCtrl.addListener(() => motorCache.put('color', colorCtrl.text));
    chasisCtrl.addListener(() => motorCache.put('chasis', chasisCtrl.text));
    engineCtrl.addListener(() => motorCache.put('engine', engineCtrl.text));
    ccCtrl.addListener(() => motorCache.put('cc', ccCtrl.text));
    yomCtrl.addListener(() => motorCache.put('yom', yomCtrl.text));
    seatsCtrl.addListener(() => motorCache.put('seats', seatsCtrl.text));
    tonnageCtrl.addListener(() => motorCache.put('tonnage', tonnageCtrl.text));
    basicPremiumCtrl.addListener(
      () => motorCache.put('basicPremium', basicPremiumCtrl.text),
    );

    if (widget.selectedQuote != null) {
      _applyQuote(widget.selectedQuote!);
    }
  }

  void _applyQuote(QuoteOption quote) {
    // Basic insurer info
    insurerIdCtrl.text = quote.insurerId.toString();
    basicPremiumCtrl.text = quote.basicPremium.toStringAsFixed(0);
    markupCtrl.text = quote.markup.toStringAsFixed(0);
    markupValueCtrl.text = quote.markupValue.toStringAsFixed(0);

    // Compute total premium (basic + benefits + taxes)
    double totalBenefits = 0;
    final List<VehicleBenefit> benefitList = [];
    for (var b in quote.benefits) {
      // Assuming each benefit has 'id', 'rate', 'amount'
      final amount = (b['amount'] as num?)?.toDouble() ?? 0;
      totalBenefits += amount;
      benefitList.add(
        VehicleBenefit(
          benefitId: b['id'],
          // rate: (b['rate'] as num).toDouble(),
          rate: num.tryParse(b['rate'].toString())?.toDouble() ?? 0,
          premium: amount,
        ),
      );
    }

    // Compute taxes based on basic premium and tax rules
    double totalTaxes = 0;
    final List<TaxItem> computedTaxes = [];
    for (var tax in quote.taxes) {
      double amount = 0;
      if (tax.calculations == 'On Basic') {
        amount = (double.parse(tax.rate) / 100) * quote.basicPremium;
      } else if (tax.calculations == 'Duty') {
        amount = double.parse(tax.rate); // fixed duty
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

    taxesList = computedTaxes;
    // You might want to store benefitList in a state variable for later use
    // (add a field like List<VehicleBenefit> _benefits = [];)

    // Set premium controller (basic + benefits + taxes)
    double totalPremium = quote.basicPremium + totalBenefits + totalTaxes;
    premiumCtrl.text = totalPremium.toStringAsFixed(0);
  }

  @override
  void dispose() {
    // Dispose all controllers
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

  Future<void> _submit() async {
    final name = '${firstNameController.text} ${lastNameController.text}'
        .trim();
    if (name.isEmpty ||
        clientEmailCtrl.text.isEmpty ||
        clientPhoneCtrl.text.isEmpty ||
        clientIdnoCtrl.text.isEmpty ||
        clientPinCtrl.text.isEmpty) {
      FuturisticToastT.show(
        context: context,
        message: 'Please fill all required fields',
        icon: Icons.error_outline,
        alignment: Alignment.topCenter,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // final request = MotorSaveRequest(
      //   client: MotorClient(
      //     // name: clientNameCtrl.text,
      //     name: name,
      //     email: clientEmailCtrl.text,
      //     phone: clientPhoneCtrl.text,
      //     idno: clientIdnoCtrl.text,
      //     pin: clientPinCtrl.text,
      //     riskManagerId: 1, // placeholder – fetch from API later
      //     salesPersonId: null,
      //     branchId: 1, // placeholder
      //   ),
      //   policy: MotorPolicy(
      //     coverPeriod: selectedCoverPeriod ?? '',
      //     startDate: startDateCtrl.text,
      //     endDate: endDateCtrl.text,
      //     insurerId: int.tryParse(insurerIdCtrl.text) ?? 0,
      //     vehicleClass: selectedClass ?? '',
      //     subClass: subClassCtrl.text,
      //     totalBasic: double.tryParse(totalBasicCtrl.text) ?? 0,
      //     taxes: double.tryParse(taxesCtrl.text) ?? 0,
      //     premium: double.tryParse(premiumCtrl.text) ?? 0,
      //     markup: double.tryParse(markupCtrl.text) ?? 0,
      //     markupValue: double.tryParse(markupValueCtrl.text) ?? 0,
      //   ),
      //   taxes: taxesList,
      //   vehicles: [
      //     Vehicle(
      //       // coverage: _coverage ?? '',
      //       coverage: 'Comprehensive',

      //       rate: 0, // from quote
      //       // coverage: '', // from quote
      //       // coverage: widget.selectedQuote?.coverage ?? 'comprehensive',
      //       regno: regnoCtrl.text,
      //       make: makeCtrl.text,
      //       model: modelCtrl.text,
      //       body: bodyCtrl.text,
      //       color: colorCtrl.text,
      //       chasis: chasisCtrl.text,
      //       engine: engineCtrl.text,
      //       cc: int.tryParse(ccCtrl.text) ?? 0,
      //       yom: int.tryParse(yomCtrl.text) ?? 0,
      //       seats: int.tryParse(seatsCtrl.text) ?? 0,
      //       tonnage: double.tryParse(tonnageCtrl.text) ?? 0,
      //       value: double.tryParse(valueCtrl.text) ?? 0,
      //       basicPremium: double.tryParse(basicPremiumCtrl.text) ?? 0,
      //       benefits: [], // to be implemented
      //     ),
      //   ],
      // );

      setState(() => _isLoading = true);
      // try {
      final request = MotorSaveRequest(
        client: MotorClient(
          name: name,
          email: clientEmailCtrl.text,
          phone: clientPhoneCtrl.text,
          idno: clientIdnoCtrl.text,
          pin: clientPinCtrl.text,
          riskManagerId: 1, // placeholder – fetch from API later
          salesPersonId: null,
          branchId: 1, // placeholder
        ),
        policy: MotorPolicy(
          coverPeriod: selectedCoverPeriod ?? 'tor', // default to 'tor'
          startDate: startDateCtrl.text,
          endDate: endDateCtrl.text,
          insurerId: int.tryParse(insurerIdCtrl.text) ?? 0,
          vehicleClass: selectedClass ?? 'Motor', // default
          subClass: subClassCtrl.text.isNotEmpty
              ? subClassCtrl.text
              : 'Private', // default
          totalBasic: double.tryParse(totalBasicCtrl.text) ?? 0,
          taxes: double.tryParse(taxesCtrl.text) ?? 0,
          premium: double.tryParse(premiumCtrl.text) ?? 0,
          markup: double.tryParse(markupCtrl.text) ?? 0,
          markupValue: double.tryParse(markupValueCtrl.text) ?? 0,
        ),
        // taxes: taxesList.isNotEmpty
        //     ? taxesList
        //     : [
        //         TaxItem(taxId: 1, rate: "0.25", amount: "1"),
        //         TaxItem(taxId: 2, rate: "0.2", amount: "1"),
        //         TaxItem(taxId: 3, rate: "40", amount: "40"),
        //       ],
        taxes: [
          TaxItem(taxId: 1, rate: "0.25", amount: "1"),
          TaxItem(taxId: 2, rate: "0.2", amount: "1"),
          TaxItem(taxId: 3, rate: "40", amount: "40"),
        ],
        vehicles: [
          Vehicle(
            coverage: 'Comprehensive',
            rate: 6, // use a default positive rate
            regno: regnoCtrl.text,
            make: makeCtrl.text.isNotEmpty ? makeCtrl.text : 'Toyota',
            model: modelCtrl.text.isNotEmpty ? modelCtrl.text : 'Land Cruiser',
            body: bodyCtrl.text.isNotEmpty ? bodyCtrl.text : 'SUV',
            color: colorCtrl.text.isNotEmpty ? colorCtrl.text : 'White',
            chasis: chasisCtrl.text,
            engine: engineCtrl.text.isNotEmpty ? engineCtrl.text : '3000',
            cc:
                int.tryParse(ccCtrl.text) != null &&
                    int.tryParse(ccCtrl.text)! > 0
                ? int.tryParse(ccCtrl.text)!
                : 3000,
            yom:
                int.tryParse(yomCtrl.text) != null &&
                    int.tryParse(yomCtrl.text)! > 1900
                ? int.tryParse(yomCtrl.text)!
                : 2019,
            seats:
                int.tryParse(seatsCtrl.text) != null &&
                    int.tryParse(seatsCtrl.text)! > 0
                ? int.tryParse(seatsCtrl.text)!
                : 5,
            tonnage: double.tryParse(tonnageCtrl.text) ?? 4,
            value: double.tryParse(valueCtrl.text) ?? 100000,
            basicPremium: double.tryParse(basicPremiumCtrl.text) ?? 557,
            benefits: [
              VehicleBenefit(benefitId: 1, rate: 0.25, premium: 2500),
              VehicleBenefit(benefitId: 5, rate: 0.25, premium: 2500),
            ],
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Policy created! Risknote ${response.risknote}'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
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

      // 3. Update the controller
      endDateCtrl.text = DateFormat('yyyy-MM-dd').format(end);
    } catch (e) {
      debugPrint("Date parsing error: $e");
    }
  }

  Widget _buildClientFormFields({bool isRequired = true}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        Widget leftColumn = Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: 'First Name',
                    icon: Icons.person,
                    controller: firstNameController,
                    isRequired: isRequired,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    hint: 'Last Name',
                    icon: Icons.person_outline,
                    controller: lastNameController,
                    isRequired: isRequired,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hint: 'Email',
              icon: Icons.email,
              controller: clientEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              isRequired: isRequired,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hint: 'Phone',
              icon: Icons.phone,
              controller: clientPhoneCtrl,
              keyboardType: TextInputType.phone,
              isRequired: isRequired,
            ),
          ],
        );
        Widget rightColumn = Column(
          children: [
            CustomTextField(
              hint: 'ID Number',
              icon: Icons.badge,
              controller: clientIdnoCtrl,
              isRequired: isRequired,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hint: 'PIN',
              icon: Icons.lock,
              controller: clientPinCtrl,
              isRequired: isRequired,
            ),
          ],
        );
        return isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: leftColumn),
                  const SizedBox(width: 16),
                  Expanded(child: rightColumn),
                ],
              )
            : Column(
                children: [leftColumn, const SizedBox(height: 16), rightColumn],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(motorProvider);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),

      child: Container(
        // appBar: AppBar(
        //   title: const Text('Create Motor Policy'),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF00FFB2).withOpacity(0.08),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 10),
              _buildHorizontalProgress(),
              const Divider(color: Colors.white10, height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    child: _getStepContent(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _existingClientSection() {
    return Column(
      key: const ValueKey('existing'),
      children: [
        CustomTextField(
          hint: 'Search client (name / phone / ID)',
          icon: Icons.search,
          controller: _searchController,
        ),

        const SizedBox(height: 12),

        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "Client results will appear here",
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ),
      ],
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
    // Split full name into first and last (simple split by first space)
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
    clientIdnoCtrl.text =
        client.client_no; // assuming client_no is the ID number
    // PIN might not be available; leave empty
    clientPinCtrl.text = '';
  }

  // Widget _buildExistingClientList() {
  //   return Column(
  //     children: [
  //       // Search field
  //       CustomTextField(
  //         hint: 'Search by name, ID, email, phone',
  //         icon: Icons.search,
  //         controller: _searchController,
  //         // onChanged: (value) {
  //         //   final allClients = _allClients;
  //         //   _filterClients(value, allClients);
  //         // },
  //       ),
  //       const SizedBox(height: 16),
  //       // Client list using FutureProvider
  //       Consumer(
  //         builder: (context, ref, child) {
  //           final clientsAsync = ref.watch(clientsProvider);
  //           return clientsAsync.when(
  //             data: (clients) {
  //               _allClients = clients; // store for filtering
  //               if (_filteredClients.isEmpty &&
  //                   _searchController.text.isEmpty) {
  //                 _filteredClients = clients;
  //               }
  //               if (_filteredClients.isEmpty) {
  //                 return const Center(
  //                   child: Text(
  //                     'No clients found',
  //                     style: TextStyle(color: Colors.white54),
  //                   ),
  //                 );
  //               }
  //               return ListView.builder(
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 itemCount: _filteredClients.length,
  //                 itemBuilder: (context, index) {
  //                   final client = _filteredClients[index];
  //                   final isSelected =
  //                       _selectedClient?.client_no == client.client_no;
  //                   return GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         _selectedClient = client;
  //                         _populateClientData(client);
  //                       });
  //                     },
  //                     child: Container(
  //                       margin: const EdgeInsets.only(bottom: 8),
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: isSelected
  //                             ? const Color(0xFF00FFB2).withOpacity(0.15)
  //                             : Colors.white10,
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(
  //                           color: isSelected
  //                               ? const Color(0xFF00FFB2)
  //                               : Colors.white24,
  //                         ),
  //                       ),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             client.name,
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             'ID: ${client.client_no}',
  //                             style: const TextStyle(color: Colors.white70),
  //                           ),
  //                           Text(
  //                             'Email: ${client.email}',
  //                             style: const TextStyle(color: Colors.white70),
  //                           ),
  //                           Text(
  //                             'Phone: ${client.mobile}',
  //                             style: const TextStyle(color: Colors.white70),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //             loading: () => const Center(
  //               child: CircularProgressIndicator(color: Color(0xFF00FFB2)),
  //             ),
  //             error: (err, stack) => Center(
  //               child: Text(
  //                 'Error loading clients: $err',
  //                 style: const TextStyle(color: Colors.redAccent),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildExistingClientList() {
    return Column(
      children: [
        // Search field
        CustomTextField(
          hint: 'Search by name, ID, email, phone',
          icon: Icons.search,
          controller: _searchController,
        ),
        const SizedBox(height: 16),

        // Pre-filled client details form (only if a client is selected)
        if (_selectedClient != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selected Client Details',
                      style: TextStyle(
                        color: Color(0xFF00FFB2),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedClient = null;
                          _clearClientControllers();
                        });
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10),
                const SizedBox(height: 8),
                _buildClientFormFields(),
              ],
            ),
          ),
        ],
        SizedBox(height: 10),

        // Client list (always visible)
        Consumer(
          builder: (context, ref, child) {
            final clientsAsync = ref.watch(clientsProvider);
            return clientsAsync.when(
              data: (clients) {
                _allClients = clients;
                if (_filteredClients.isEmpty &&
                    _searchController.text.isEmpty) {
                  _filteredClients = clients;
                }
                if (_filteredClients.isEmpty) {
                  return const Center(
                    child: Text(
                      'No clients found',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = _filteredClients[index];
                    final isSelected =
                        _selectedClient?.client_no == client.client_no;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedClient = client;
                          _populateClientData(client);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00FFB2).withOpacity(0.15)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF00FFB2)
                                : Colors.white24,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${client.client_no}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Email: ${client.email}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Phone: ${client.mobile}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF00FFB2)),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Error loading clients: $err',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildClientTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _clientMode = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _clientMode == 0
                      ? const Color(0xFF00FFB2).withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Existing Client",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _clientMode = 1;
                _selectedClient = null;
                _clearClientControllers();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _clientMode == 1
                      ? const Color(0xFF00FFB2).withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "New Client",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Create Motor Policy',
            //   style: TextStyle(
            //     fontSize: 22,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            CustomText('Create Motor Policy', type: CustomTextType.header),
            CustomText(
              _currentStep == 0
                  ? 'Step 1: Client Details'
                  : _currentStep == 1
                  ? 'Step 2: Policy Details'
                  : 'Step 3: Vehicle & Taxes',
              type: CustomTextType.paragraph,
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
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
      ],
    );
  }

  Widget _progressNode(int step, String label) {
    bool isActive = _currentStep >= step;
    Color mint = const Color(0xFF00FFB2);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? mint.withOpacity(0.2) : Colors.white10,
            border: Border.all(
              color: isActive ? mint : Colors.white24,
              width: 2,
            ),
          ),
          child: Center(
            child: _currentStep > step
                ? Icon(Icons.check, size: 14, color: mint)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? mint : Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _progressLine(int step) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: _currentStep > step
            ? const Color(0xFF00FFB2).withOpacity(0.5)
            : Colors.white10,
      ),
    );
  }

  Widget _getStepContent() {
    if (_currentStep == 0) {
      return Column(
        key: const ValueKey(0),
        children: [
          // _buildClientTabs(),
          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              Widget leftColumn = Column(
                children: [
                  // CustomTextField(
                  //   hint: 'Full Name',
                  //   icon: Icons.person,
                  //   controller: clientNameCtrl,
                  //   isRequired: true,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: 'First Name',
                          icon: Icons.person,
                          controller: firstNameController,
                          isRequired: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          hint: 'Last Name',
                          icon: Icons.person_outline,
                          controller: lastNameController,
                          isRequired: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Email',
                    icon: Icons.email,
                    controller: clientEmailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Phone',
                    icon: Icons.phone,
                    controller: clientPhoneCtrl,
                    keyboardType: TextInputType.phone,
                    isRequired: true,
                  ),
                ],
              );
              Widget rightColumn = Column(
                children: [
                  CustomTextField(
                    hint: 'ID Number',
                    icon: Icons.badge,
                    controller: clientIdnoCtrl,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'PIN',
                    icon: Icons.lock,
                    controller: clientPinCtrl,
                    isRequired: true,
                  ),
                ],
              );

              Widget combinedSingleChildScrollView = SingleChildScrollView(
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: leftColumn),
                          const SizedBox(width: 16),
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
              // return combinedSingleChildScrollView;

              return Column(
                key: const ValueKey(0),
                children: [
                  _buildClientTabs(),
                  const SizedBox(height: 20),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _clientMode == 0
                        // ? _existingClientSection()
                        ? _buildExistingClientList()
                        : combinedSingleChildScrollView,
                  ),
                ],
              );
            },
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
                  CustomDropdown<String>(
                    hint: 'Cover Period',
                    icon: Icons.timelapse,
                    value: selectedCoverPeriod,
                    items: const [
                      DropdownMenuItem(value: 'annual', child: Text('Annual')),
                      DropdownMenuItem(value: 'tor', child: Text('TOR')),
                    ],
                    onChanged: (v) {
                      setState(() {
                        selectedCoverPeriod = v;
                      });
                      ref
                          .read(motorSaveCacheProvider)
                          .put('selectedCoverPeriod', v);
                      _updateEndDate();
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),

                  CustomDropdown<String>(
                    hint: 'Coverage',
                    icon: Icons.shield,
                    value: _coverage,
                    items: const [
                      DropdownMenuItem(
                        value: 'Private',
                        child: Text('Private'),
                      ),
                      // DropdownMenuItem(value: 'tor', child: Text('TOR')),
                    ],
                    onChanged: (v) {
                      setState(() {
                        _coverage = v;
                      });
                      ref.read(motorSaveCacheProvider).put('_coverage', v);
                      // _updateEndDate();
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: 'Start Date',
                          icon: Icons.calendar_today,
                          controller: startDateCtrl,
                          isDateField: true,
                          isRequired: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextField(
                          hint: 'End Date',
                          icon: Icons.calendar_today,
                          controller: endDateCtrl,
                          isDateField: false,
                          enabled: false,
                          isRequired: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Insurer ID',
                    icon: Icons.business,
                    controller: insurerIdCtrl,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomDropdown<String>(
                    hint: 'Class',
                    icon: Icons.category,
                    value: selectedClass,
                    items: const [
                      DropdownMenuItem(value: 'Motor', child: Text('Motor')),
                      DropdownMenuItem(value: 'Tuktuk', child: Text('Tuktuk')),
                      DropdownMenuItem(
                        value: 'Motorcycle',
                        child: Text('Motorcycle'),
                      ),
                    ],
                    onChanged: (v) => {
                      setState(() => selectedClass = v),
                      ref.read(motorSaveCacheProvider).put('selectedClass', v),
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Sub Class',
                    icon: Icons.subdirectory_arrow_right,
                    controller: subClassCtrl,
                  ),
                ],
              );
              Widget rightColumn = Column(
                children: [
                  CustomTextField(
                    hint: 'Total Basic',
                    icon: Icons.attach_money,
                    controller: totalBasicCtrl,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Taxes',
                    icon: Icons.receipt,
                    controller: taxesCtrl,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Premium',
                    icon: Icons.money,
                    controller: premiumCtrl,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Markup',
                    icon: Icons.trending_up,
                    controller: markupCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Markup Value',
                    icon: Icons.money_off,
                    controller: markupValueCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ],
              );
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
    } else {
      return Column(
        key: const ValueKey(2),
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              Widget leftColumn = Column(
                children: [
                  CustomTextField(
                    hint: 'Registration No',
                    icon: Icons.confirmation_number,
                    controller: regnoCtrl,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Make',
                    icon: Icons.build,
                    controller: makeCtrl,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Model',
                    icon: Icons.drive_eta,
                    controller: modelCtrl,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Body',
                    icon: Icons.car_repair,
                    controller: bodyCtrl,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Color',
                    icon: Icons.color_lens,
                    controller: colorCtrl,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Chasis No',
                    icon: Icons.qr_code,
                    controller: chasisCtrl,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Engine No',
                    icon: Icons.engineering,
                    controller: engineCtrl,
                  ),
                  // TODO: add UI to manage multiple taxes
                ],
              );
              Widget rightColumn = Column(
                children: [
                  CustomTextField(
                    hint: 'CC',
                    icon: Icons.speed,
                    controller: ccCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Year of Manufacture',
                    icon: Icons.calendar_today,
                    controller: yomCtrl,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Seats',
                    icon: Icons.airline_seat_recline_normal,
                    controller: seatsCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Tonnage',
                    icon: Icons.line_weight,
                    controller: tonnageCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Value',
                    icon: Icons.attach_money,
                    controller: valueCtrl,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Basic Premium',
                    icon: Icons.money,
                    controller: basicPremiumCtrl,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                  ),
                  const Divider(color: Colors.white30),
                  // const Text(
                  //   'Taxes (to be added dynamically)',
                  //   style: TextStyle(color: Colors.white70),
                  // ),
                  // TODO: add UI to manage multiple taxes
                ],
              );
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Vehicle Details',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: leftColumn),
                              const SizedBox(width: 16),
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
                  ],
                ),
              );
            },
          ),
        ],
      );
    }
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: CustomAdvancedButton(
              label: "Back",
              onPressed: () => setState(() => _currentStep--),
              variant: ButtonVariant.secondary,
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 16),
        Expanded(
          child: CustomAdvancedButton(
            loading: _isLoading,
            label: _currentStep < 2 ? 'Next Step' : 'Save Policy',
            onPressed: () {
              if (_currentStep < 2) {
                setState(() => _currentStep++);
              } else {
                _submit();
              }
            },
            variant: ButtonVariant.primary,
          ),
        ),
      ],
    );
  }
}

// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
// // import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
// // import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// // import 'package:insured/app_2/providers/motor_provider.dart';
// // import 'package:insured/app_2/data/models/motor_save.dart';
// // import 'package:go_router/go_router.dart';

// // class MotorSaveScreen extends ConsumerStatefulWidget {
// //   const MotorSaveScreen({super.key});

// //   @override
// //   ConsumerState<MotorSaveScreen> createState() => _MotorSaveScreenState();
// // }

// // class _MotorSaveScreenState extends ConsumerState<MotorSaveScreen> {
// //   int _currentStep = 0;
// //   final ScrollController _scrollController = ScrollController();

// //   // --- CONTROLLERS ---
// //   final clientNameCtrl = TextEditingController();
// //   final clientEmailCtrl = TextEditingController();
// //   final clientPhoneCtrl = TextEditingController();
// //   final clientIdnoCtrl = TextEditingController();
// //   final clientPinCtrl = TextEditingController();

// //   String? selectedCoverPeriod;
// //   final startDateCtrl = TextEditingController();
// //   final endDateCtrl = TextEditingController();
// //   final insurerIdCtrl = TextEditingController();
// //   String? selectedClass;
// //   final subClassCtrl = TextEditingController();
// //   final totalBasicCtrl = TextEditingController();
// //   final taxesCtrl = TextEditingController();
// //   final premiumCtrl = TextEditingController();
// //   final markupCtrl = TextEditingController();
// //   final markupValueCtrl = TextEditingController();

// //   final regnoCtrl = TextEditingController();
// //   final makeCtrl = TextEditingController();
// //   final modelCtrl = TextEditingController();
// //   final bodyCtrl = TextEditingController();
// //   final colorCtrl = TextEditingController();
// //   final chasisCtrl = TextEditingController();
// //   final engineCtrl = TextEditingController();
// //   final ccCtrl = TextEditingController();
// //   final yomCtrl = TextEditingController();
// //   final seatsCtrl = TextEditingController();
// //   final tonnageCtrl = TextEditingController();
// //   final valueCtrl = TextEditingController();
// //   final basicPremiumCtrl = TextEditingController();

// //   List<TaxItem> taxesList = [];

// //   @override
// //   void dispose() {
// //     // Dispose all 20+ controllers to prevent memory leaks
// //     final controllers = [
// //       clientNameCtrl,
// //       clientEmailCtrl,
// //       clientPhoneCtrl,
// //       clientIdnoCtrl,
// //       clientPinCtrl,
// //       startDateCtrl,
// //       endDateCtrl,
// //       insurerIdCtrl,
// //       subClassCtrl,
// //       totalBasicCtrl,
// //       taxesCtrl,
// //       premiumCtrl,
// //       markupCtrl,
// //       markupValueCtrl,
// //       regnoCtrl,
// //       makeCtrl,
// //       modelCtrl,
// //       bodyCtrl,
// //       colorCtrl,
// //       chasisCtrl,
// //       engineCtrl,
// //       ccCtrl,
// //       yomCtrl,
// //       seatsCtrl,
// //       tonnageCtrl,
// //       valueCtrl,
// //       basicPremiumCtrl,
// //     ];
// //     for (var c in controllers) {
// //       c.dispose();
// //     }
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   // --- LOGIC ---
// //   Future<void> _submit() async {
// //     final request = MotorSaveRequest(
// //       client: MotorClient(
// //         name: clientNameCtrl.text,
// //         email: clientEmailCtrl.text,
// //         phone: clientPhoneCtrl.text,
// //         idno: clientIdnoCtrl.text,
// //         pin: clientPinCtrl.text,
// //         riskManagerId: 1,
// //         branchId: 1,
// //       ),
// //       policy: MotorPolicy(
// //         coverPeriod: selectedCoverPeriod ?? '',
// //         startDate: startDateCtrl.text,
// //         endDate: endDateCtrl.text,
// //         insurerId: int.tryParse(insurerIdCtrl.text) ?? 0,
// //         vehicleClass: selectedClass ?? '',
// //         subClass: subClassCtrl.text,
// //         totalBasic: double.tryParse(totalBasicCtrl.text) ?? 0,
// //         taxes: double.tryParse(taxesCtrl.text) ?? 0,
// //         premium: double.tryParse(premiumCtrl.text) ?? 0,
// //         markup: double.tryParse(markupCtrl.text) ?? 0,
// //         markupValue: double.tryParse(markupValueCtrl.text) ?? 0,
// //       ),
// //       taxes: taxesList,
// //       vehicles: [
// //         Vehicle(
// //           rate: 0,
// //           coverage: '',
// //           regno: regnoCtrl.text,
// //           make: makeCtrl.text,
// //           model: modelCtrl.text,
// //           body: bodyCtrl.text,
// //           color: colorCtrl.text,
// //           chasis: chasisCtrl.text,
// //           engine: engineCtrl.text,
// //           cc: int.tryParse(ccCtrl.text) ?? 0,
// //           yom: int.tryParse(yomCtrl.text) ?? 0,
// //           seats: int.tryParse(seatsCtrl.text) ?? 0,
// //           tonnage: double.tryParse(tonnageCtrl.text) ?? 0,
// //           value: double.tryParse(valueCtrl.text) ?? 0,
// //           basicPremium: double.tryParse(basicPremiumCtrl.text) ?? 0,
// //           benefits: [], // to be implemented
// //         ),
// //       ],
// //     );

// //     final response = await ref.read(motorProvider.notifier).savePolicy(request);
// //     if (response != null && mounted) {
// //       context.pop();
// //     }
// //   }

// //   // --- BUILDERS ---

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF07111F), // Deep space theme
// //       appBar: AppBar(
// //         title: const Text(
// //           'New Motor Policy',
// //           style: TextStyle(color: Colors.white, fontSize: 18),
// //         ),
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         centerTitle: true,
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [
// //               const Color(0xFF00FFB2).withOpacity(0.05),
// //               Colors.transparent,
// //             ],
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             _buildHorizontalProgress(),
// //             Expanded(
// //               child: AnimatedSwitcher(
// //                 duration: const Duration(milliseconds: 400),
// //                 switchInCurve: Curves.easeInOutCubic,
// //                 child: SingleChildScrollView(
// //                   key: ValueKey<int>(_currentStep),
// //                   controller: _scrollController,
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 24,
// //                     vertical: 8,
// //                   ),
// //                   child: _getStepWidget(),
// //                 ),
// //               ),
// //             ),
// //             _buildBottomBar(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHorizontalProgress() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
// //       child: Row(
// //         children: [
// //           _progressNode(0, 'Client'),
// //           _progressLine(0),
// //           _progressNode(1, 'Policy'),
// //           _progressLine(1),
// //           _progressNode(2, 'Vehicle'),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _progressNode(int step, String label) {
// //     bool isDone = _currentStep > step;
// //     bool isCurrent = _currentStep == step;
// //     Color activeColor = const Color(0xFF00FFB2);

// //     return Column(
// //       children: [
// //         AnimatedContainer(
// //           duration: const Duration(milliseconds: 300),
// //           width: 36,
// //           height: 36,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: isDone || isCurrent
// //                 ? activeColor.withOpacity(0.1)
// //                 : Colors.white.withOpacity(0.05),
// //             border: Border.all(
// //               color: isDone || isCurrent ? activeColor : Colors.white24,
// //               width: 2,
// //             ),
// //             boxShadow: isCurrent
// //                 ? [
// //                     BoxShadow(
// //                       color: activeColor.withOpacity(0.3),
// //                       blurRadius: 12,
// //                     ),
// //                   ]
// //                 : [],
// //           ),
// //           child: Center(
// //             child: isDone
// //                 ? Icon(Icons.check, size: 18, color: activeColor)
// //                 : Text(
// //                     '${step + 1}',
// //                     style: TextStyle(
// //                       color: isCurrent ? activeColor : Colors.white38,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             color: isCurrent ? Colors.white : Colors.white38,
// //             fontSize: 11,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _progressLine(int step) {
// //     return Expanded(
// //       child: Padding(
// //         padding: const EdgeInsets.only(bottom: 22, left: 8, right: 8),
// //         child: Container(
// //           height: 2,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(2),
// //             color: _currentStep > step
// //                 ? const Color(0xFF00FFB2).withOpacity(0.5)
// //                 : Colors.white10,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _getStepWidget() {
// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         final isWide = constraints.maxWidth > 750;
// //         switch (_currentStep) {
// //           case 0:
// //             return _buildClientStep(isWide);
// //           case 1:
// //             return _buildPolicyStep(isWide);
// //           case 2:
// //             return _buildVehicleStep(isWide);
// //           default:
// //             return const SizedBox();
// //         }
// //       },
// //     );
// //   }

// //   Widget _buildClientStep(bool isWide) {
// //     Widget left = Column(
// //       children: [
// //         CustomTextField(
// //           hint: 'Full Name',
// //           icon: Icons.person,
// //           controller: clientNameCtrl,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Email',
// //           icon: Icons.email,
// //           controller: clientEmailCtrl,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Phone',
// //           icon: Icons.phone,
// //           controller: clientPhoneCtrl,
// //           isRequired: true,
// //         ),
// //       ],
// //     );
// //     Widget right = Column(
// //       children: [
// //         CustomTextField(
// //           hint: 'ID Number',
// //           icon: Icons.badge,
// //           controller: clientIdnoCtrl,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'KRA PIN',
// //           icon: Icons.lock,
// //           controller: clientPinCtrl,
// //           isRequired: true,
// //         ),
// //       ],
// //     );

// //     return isWide
// //         ? Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(child: left),
// //               const SizedBox(width: 24),
// //               Expanded(child: right),
// //             ],
// //           )
// //         : Column(children: [left, const SizedBox(height: 16), right]);
// //   }

// //   Widget _buildPolicyStep(bool isWide) {
// //     Widget left = Column(
// //       children: [
// //         CustomDropdown<String>(
// //           hint: 'Cover Period',
// //           icon: Icons.timelapse,
// //           value: selectedCoverPeriod,
// //           items: const [
// //             DropdownMenuItem(value: 'annual', child: Text('Annual')),
// //             DropdownMenuItem(value: 'tor', child: Text('TOR')),
// //           ],
// //           onChanged: (v) => setState(() => selectedCoverPeriod = v),
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Start Date',
// //           icon: Icons.calendar_today,
// //           controller: startDateCtrl,
// //           isDateField: true,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'End Date',
// //           icon: Icons.calendar_today,
// //           controller: endDateCtrl,
// //           isDateField: true,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomDropdown<String>(
// //           hint: 'Vehicle Class',
// //           icon: Icons.category,
// //           value: selectedClass,
// //           items: const [
// //             DropdownMenuItem(value: 'Motor', child: Text('Motor')),
// //             DropdownMenuItem(value: 'Tuktuk', child: Text('Tuktuk')),
// //           ],
// //           onChanged: (v) => setState(() => selectedClass = v),
// //           isRequired: true,
// //         ),
// //       ],
// //     );
// //     Widget right = Column(
// //       children: [
// //         CustomTextField(
// //           hint: 'Total Basic',
// //           icon: Icons.attach_money,
// //           controller: totalBasicCtrl,
// //           keyboardType: TextInputType.number,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Taxes',
// //           icon: Icons.receipt,
// //           controller: taxesCtrl,
// //           keyboardType: TextInputType.number,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Net Premium',
// //           icon: Icons.money,
// //           controller: premiumCtrl,
// //           keyboardType: TextInputType.number,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Markup Value',
// //           icon: Icons.trending_up,
// //           controller: markupValueCtrl,
// //           keyboardType: TextInputType.number,
// //         ),
// //       ],
// //     );

// //     return isWide
// //         ? Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(child: left),
// //               const SizedBox(width: 24),
// //               Expanded(child: right),
// //             ],
// //           )
// //         : Column(children: [left, const SizedBox(height: 16), right]);
// //   }

// //   Widget _buildVehicleStep(bool isWide) {
// //     Widget left = Column(
// //       children: [
// //         CustomTextField(
// //           hint: 'Reg No',
// //           icon: Icons.qr_code,
// //           controller: regnoCtrl,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Make',
// //           icon: Icons.car_repair,
// //           controller: makeCtrl,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Model',
// //           icon: Icons.drive_eta,
// //           controller: modelCtrl,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Chasis No',
// //           icon: Icons.vpn_key,
// //           controller: chasisCtrl,
// //         ),
// //       ],
// //     );
// //     Widget right = Column(
// //       children: [
// //         CustomTextField(
// //           hint: 'YOM',
// //           icon: Icons.calendar_month,
// //           controller: yomCtrl,
// //           keyboardType: TextInputType.number,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Vehicle Value',
// //           icon: Icons.account_balance_wallet,
// //           controller: valueCtrl,
// //           keyboardType: TextInputType.number,
// //           isRequired: true,
// //         ),
// //         const SizedBox(height: 16),
// //         CustomTextField(
// //           hint: 'Basic Premium',
// //           icon: Icons.payments,
// //           controller: basicPremiumCtrl,
// //           keyboardType: TextInputType.number,
// //           isRequired: true,
// //         ),
// //       ],
// //     );

// //     return isWide
// //         ? Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(child: left),
// //               const SizedBox(width: 24),
// //               Expanded(child: right),
// //             ],
// //           )
// //         : Column(children: [left, const SizedBox(height: 16), right]);
// //   }

// //   Widget _buildBottomBar() {
// //     final state = ref.watch(motorProvider);

// //     return ClipRRect(
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //         child: Container(
// //           padding: const EdgeInsets.all(24),
// //           decoration: BoxDecoration(
// //             color: Colors.white.withOpacity(0.03),
// //             border: Border(
// //               top: BorderSide(color: Colors.white.withOpacity(0.05)),
// //             ),
// //           ),
// //           child: Row(
// //             children: [
// //               if (_currentStep > 0)
// //                 Expanded(
// //                   child: CustomAdvancedButton(
// //                     label: 'Back',
// //                     variant: ButtonVariant.secondary,
// //                     onPressed: () => setState(() => _currentStep--),
// //                   ),
// //                 ),
// //               if (_currentStep > 0) const SizedBox(width: 16),
// //               Expanded(
// //                 child: CustomAdvancedButton(
// //                   loading: state.isLoading,
// //                   label: _currentStep == 2 ? 'Finish & Save' : 'Continue',
// //                   variant: ButtonVariant.primary,
// //                   onPressed: () {
// //                     if (_currentStep < 2) {
// //                       setState(() => _currentStep++);
// //                       _scrollController.animateTo(
// //                         0,
// //                         duration: const Duration(milliseconds: 300),
// //                         curve: Curves.easeIn,
// //                       );
// //                     } else {
// //                       _submit();
// //                     }
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/rendering.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
// // // import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
// // // import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// // // import 'package:insured/app_2/providers/motor_provider.dart';
// // // import 'package:insured/app_2/data/models/motor_save.dart';
// // // import 'package:go_router/go_router.dart';

// // // class MotorSaveScreen extends ConsumerStatefulWidget {
// // //   const MotorSaveScreen({super.key});

// // //   @override
// // //   ConsumerState<MotorSaveScreen> createState() => _MotorSaveScreenState();
// // // }

// // // class _MotorSaveScreenState extends ConsumerState<MotorSaveScreen> {
// // //   int _currentStep = 0;

// // //   // Client controllers
// // //   final clientNameCtrl = TextEditingController();
// // //   final clientEmailCtrl = TextEditingController();
// // //   final clientPhoneCtrl = TextEditingController();
// // //   final clientIdnoCtrl = TextEditingController();
// // //   final clientPinCtrl = TextEditingController();

// // //   // Policy controllers
// // //   String? selectedCoverPeriod;
// // //   final startDateCtrl = TextEditingController();
// // //   final endDateCtrl = TextEditingController();
// // //   final insurerIdCtrl = TextEditingController();
// // //   String? selectedClass;
// // //   final subClassCtrl = TextEditingController();
// // //   final totalBasicCtrl = TextEditingController();
// // //   final taxesCtrl = TextEditingController();
// // //   final premiumCtrl = TextEditingController();
// // //   final markupCtrl = TextEditingController();
// // //   final markupValueCtrl = TextEditingController();

// // //   // Vehicle controllers
// // //   final regnoCtrl = TextEditingController();
// // //   final makeCtrl = TextEditingController();
// // //   final modelCtrl = TextEditingController();
// // //   final bodyCtrl = TextEditingController();
// // //   final colorCtrl = TextEditingController();
// // //   final chasisCtrl = TextEditingController();
// // //   final engineCtrl = TextEditingController();
// // //   final ccCtrl = TextEditingController();
// // //   final yomCtrl = TextEditingController();
// // //   final seatsCtrl = TextEditingController();
// // //   final tonnageCtrl = TextEditingController();
// // //   final valueCtrl = TextEditingController();
// // //   final basicPremiumCtrl = TextEditingController();

// // //   // Taxes – simplified; you can expand later
// // //   List<TaxItem> taxesList = [];

// // //   @override
// // //   void dispose() {
// // //     // Dispose all controllers
// // //     clientNameCtrl.dispose();
// // //     clientEmailCtrl.dispose();
// // //     clientPhoneCtrl.dispose();
// // //     clientIdnoCtrl.dispose();
// // //     clientPinCtrl.dispose();
// // //     startDateCtrl.dispose();
// // //     endDateCtrl.dispose();
// // //     insurerIdCtrl.dispose();
// // //     subClassCtrl.dispose();
// // //     totalBasicCtrl.dispose();
// // //     taxesCtrl.dispose();
// // //     premiumCtrl.dispose();
// // //     markupCtrl.dispose();
// // //     markupValueCtrl.dispose();
// // //     regnoCtrl.dispose();
// // //     makeCtrl.dispose();
// // //     modelCtrl.dispose();
// // //     bodyCtrl.dispose();
// // //     colorCtrl.dispose();
// // //     chasisCtrl.dispose();
// // //     engineCtrl.dispose();
// // //     ccCtrl.dispose();
// // //     yomCtrl.dispose();
// // //     seatsCtrl.dispose();
// // //     tonnageCtrl.dispose();
// // //     valueCtrl.dispose();
// // //     basicPremiumCtrl.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _submit() async {
// // //     final request = MotorSaveRequest(
// // //       client: MotorClient(
// // //         name: clientNameCtrl.text,
// // //         email: clientEmailCtrl.text,
// // //         phone: clientPhoneCtrl.text,
// // //         idno: clientIdnoCtrl.text,
// // //         pin: clientPinCtrl.text,
// // //         riskManagerId: 1, // placeholder – fetch from API later
// // //         salesPersonId: null,
// // //         branchId: 1, // placeholder
// // //       ),
// // //       policy: MotorPolicy(
// // //         coverPeriod: selectedCoverPeriod ?? '',
// // //         startDate: startDateCtrl.text,
// // //         endDate: endDateCtrl.text,
// // //         insurerId: int.tryParse(insurerIdCtrl.text) ?? 0,
// // //         vehicleClass: selectedClass ?? '',
// // //         subClass: subClassCtrl.text,
// // //         totalBasic: double.tryParse(totalBasicCtrl.text) ?? 0,
// // //         taxes: double.tryParse(taxesCtrl.text) ?? 0,
// // //         premium: double.tryParse(premiumCtrl.text) ?? 0,
// // //         markup: double.tryParse(markupCtrl.text) ?? 0,
// // //         markupValue: double.tryParse(markupValueCtrl.text) ?? 0,
// // //       ),
// // //       taxes: taxesList,
// // //       vehicles: [
// // //         Vehicle(
// // //           rate: 0, // from quote
// // //           coverage: '', // from quote
// // //           regno: regnoCtrl.text,
// // //           make: makeCtrl.text,
// // //           model: modelCtrl.text,
// // //           body: bodyCtrl.text,
// // //           color: colorCtrl.text,
// // //           chasis: chasisCtrl.text,
// // //           engine: engineCtrl.text,
// // //           cc: int.tryParse(ccCtrl.text) ?? 0,
// // //           yom: int.tryParse(yomCtrl.text) ?? 0,
// // //           seats: int.tryParse(seatsCtrl.text) ?? 0,
// // //           tonnage: double.tryParse(tonnageCtrl.text) ?? 0,
// // //           value: double.tryParse(valueCtrl.text) ?? 0,
// // //           basicPremium: double.tryParse(basicPremiumCtrl.text) ?? 0,
// // //           benefits: [], // to be implemented
// // //         ),
// // //       ],
// // //     );

// // //     final notifier = ref.read(motorProvider.notifier);
// // //     final response = await notifier.savePolicy(request);
// // //     if (response != null && mounted) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('Policy created! Risknote ${response.risknote}'),
// // //         ),
// // //       );
// // //       context.pop();
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final state = ref.watch(motorProvider);

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Create Motor Policy'),
// // //         backgroundColor: Colors.transparent,
// // //         elevation: 0,
// // //       ),
// // //       body: Stepper(
// // //         type: StepperType.vertical,
// // //         currentStep: _currentStep,
// // //         onStepContinue: () {
// // //           if (_currentStep < 2) {
// // //             setState(() => _currentStep++);
// // //           } else {
// // //             _submit();
// // //           }
// // //         },
// // //         onStepCancel: () {
// // //           if (_currentStep > 0) setState(() => _currentStep--);
// // //         },
// // //         controlsBuilder: (context, details) {
// // //           return Padding(
// // //             padding: const EdgeInsets.only(top: 16),
// // //             child: Row(
// // //               children: [
// // //                 if (_currentStep > 0)
// // //                   Expanded(
// // //                     child: CustomAdvancedButton(
// // //                       label: 'Back',
// // //                       variant: ButtonVariant.secondary,
// // //                       onPressed: details.onStepCancel!,
// // //                     ),
// // //                   ),
// // //                 if (_currentStep > 0) const SizedBox(width: 8),
// // //                 Expanded(
// // //                   child: CustomAdvancedButton(
// // //                     label: _currentStep == 2 ? 'Save Policy' : 'Next',
// // //                     variant: ButtonVariant.primary,
// // //                     onPressed: details.onStepContinue!,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           );
// // //         },
// // //         steps: [
// // //           // Step(
// // //           //   title: const Text(
// // //           //     'Client Details',
// // //           //     style: TextStyle(color: Colors.white),
// // //           //   ),

// // //           //   content: Column(
// // //           //     children: [
// // //           //       CustomTextField(
// // //           //         hint: 'Full Name',
// // //           //         icon: Icons.person,
// // //           //         controller: clientNameCtrl,
// // //           //         isRequired: true,
// // //           //       ),
// // //           //       const SizedBox(height: 8),
// // //           //       CustomTextField(
// // //           //         hint: 'Email',
// // //           //         icon: Icons.email,
// // //           //         controller: clientEmailCtrl,
// // //           //         keyboardType: TextInputType.emailAddress,
// // //           //         isRequired: true,
// // //           //       ),
// // //           //       const SizedBox(height: 8),
// // //           //       CustomTextField(
// // //           //         hint: 'Phone',
// // //           //         icon: Icons.phone,
// // //           //         controller: clientPhoneCtrl,
// // //           //         keyboardType: TextInputType.phone,
// // //           //         isRequired: true,
// // //           //       ),
// // //           //       const SizedBox(height: 8),
// // //           //       CustomTextField(
// // //           //         hint: 'ID Number',
// // //           //         icon: Icons.badge,
// // //           //         controller: clientIdnoCtrl,
// // //           //         isRequired: true,
// // //           //       ),
// // //           //       const SizedBox(height: 8),
// // //           //       CustomTextField(
// // //           //         hint: 'PIN',
// // //           //         icon: Icons.lock,
// // //           //         controller: clientPinCtrl,
// // //           //         isRequired: true,
// // //           //       ),
// // //           //       // TODO: add dropdowns for risk manager, branch once API available
// // //           //     ],
// // //           //   ),
// // //           //   isActive: true,
// // //           // ),
// // //           Step(
// // //             title: const Text(
// // //               'Client Details',
// // //               style: TextStyle(color: Colors.white),
// // //             ),
// // //             content: LayoutBuilder(
// // //               builder: (context, constraints) {
// // //                 final isWide = constraints.maxWidth > 700;

// // //                 Widget leftColumn = Column(
// // //                   children: [
// // //                     CustomTextField(
// // //                       hint: 'Full Name',
// // //                       icon: Icons.person,
// // //                       controller: clientNameCtrl,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Email',
// // //                       icon: Icons.email,
// // //                       controller: clientEmailCtrl,
// // //                       keyboardType: TextInputType.emailAddress,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Phone',
// // //                       icon: Icons.phone,
// // //                       controller: clientPhoneCtrl,
// // //                       keyboardType: TextInputType.phone,
// // //                       isRequired: true,
// // //                     ),
// // //                   ],
// // //                 );

// // //                 Widget rightColumn = Column(
// // //                   children: [
// // //                     CustomTextField(
// // //                       hint: 'ID Number',
// // //                       icon: Icons.badge,
// // //                       controller: clientIdnoCtrl,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'PIN',
// // //                       icon: Icons.lock,
// // //                       controller: clientPinCtrl,
// // //                       isRequired: true,
// // //                     ),
// // //                     // Add more fields here if needed
// // //                   ],
// // //                 );

// // //                 return SingleChildScrollView(
// // //                   child: isWide
// // //                       ? Row(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Expanded(child: leftColumn),
// // //                             const SizedBox(width: 16),
// // //                             Expanded(child: rightColumn),
// // //                           ],
// // //                         )
// // //                       : Column(
// // //                           children: [
// // //                             leftColumn,
// // //                             const SizedBox(height: 16),
// // //                             rightColumn,
// // //                           ],
// // //                         ),
// // //                 );
// // //               },
// // //             ),
// // //             isActive: true,
// // //           ),
// // //           Step(
// // //             title: const Text(
// // //               'Policy Details',
// // //               style: TextStyle(color: Colors.white),
// // //             ),
// // //             content: LayoutBuilder(
// // //               builder: (context, constraints) {
// // //                 final isWide = constraints.maxWidth > 700;
// // //                 Widget leftColumn = Column(
// // //                   children: [
// // //                     CustomDropdown<String>(
// // //                       hint: 'Cover Period',
// // //                       icon: Icons.timelapse,
// // //                       value: selectedCoverPeriod,
// // //                       items: const [
// // //                         DropdownMenuItem(
// // //                           value: 'annual',
// // //                           child: Text('Annual'),
// // //                         ),
// // //                         DropdownMenuItem(value: 'tor', child: Text('TOR')),
// // //                       ],
// // //                       onChanged: (v) => setState(() => selectedCoverPeriod = v),
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Start Date',
// // //                       icon: Icons.calendar_today,
// // //                       controller: startDateCtrl,
// // //                       isDateField: true,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'End Date',
// // //                       icon: Icons.calendar_today,
// // //                       controller: endDateCtrl,
// // //                       isDateField: true,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Insurer ID',
// // //                       icon: Icons.business,
// // //                       controller: insurerIdCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomDropdown<String>(
// // //                       hint: 'Class',
// // //                       icon: Icons.category,
// // //                       value: selectedClass,
// // //                       items: const [
// // //                         DropdownMenuItem(value: 'Motor', child: Text('Motor')),
// // //                         DropdownMenuItem(
// // //                           value: 'Tuktuk',
// // //                           child: Text('Tuktuk'),
// // //                         ),
// // //                         DropdownMenuItem(
// // //                           value: 'Motorcycle',
// // //                           child: Text('Motorcycle'),
// // //                         ),
// // //                       ],
// // //                       onChanged: (v) => setState(() => selectedClass = v),
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Sub Class',
// // //                       icon: Icons.subdirectory_arrow_right,
// // //                       controller: subClassCtrl,
// // //                     ),
// // //                   ],
// // //                 );

// // //                 Widget rightColumn = Column(
// // //                   children: [
// // //                     // const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Total Basic',
// // //                       icon: Icons.attach_money,
// // //                       controller: totalBasicCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Taxes',
// // //                       icon: Icons.receipt,
// // //                       controller: taxesCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Premium',
// // //                       icon: Icons.money,
// // //                       controller: premiumCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Markup',
// // //                       icon: Icons.trending_up,
// // //                       controller: markupCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Markup Value',
// // //                       icon: Icons.money_off,
// // //                       controller: markupValueCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                   ],
// // //                 );

// // //                 return SingleChildScrollView(
// // //                   child: isWide
// // //                       ? Row(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Expanded(child: leftColumn),
// // //                             const SizedBox(width: 20),
// // //                             Expanded(child: rightColumn),
// // //                           ],
// // //                         )
// // //                       : Column(
// // //                           children: [
// // //                             leftColumn,
// // //                             const SizedBox(height: 16),
// // //                             rightColumn,
// // //                           ],
// // //                         ),
// // //                 );
// // //               },
// // //             ),

// // //             isActive: true,
// // //           ),
// // //           Step(
// // //             title: const Text(
// // //               'Vehicle & Taxes',
// // //               style: TextStyle(color: Colors.white),
// // //             ),
// // //             content: LayoutBuilder(
// // //               builder: (context, constraints) {
// // //                 final isWide = constraints.maxWidth > 700;

// // //                 Widget leftColumn = Column(
// // //                   children: [
// // //                     CustomTextField(
// // //                       hint: 'Registration No',
// // //                       icon: Icons.confirmation_number,
// // //                       controller: regnoCtrl,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Make',
// // //                       icon: Icons.build,
// // //                       controller: makeCtrl,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Model',
// // //                       icon: Icons.drive_eta,
// // //                       controller: modelCtrl,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Body',
// // //                       icon: Icons.car_repair,
// // //                       controller: bodyCtrl,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Color',
// // //                       icon: Icons.color_lens,
// // //                       controller: colorCtrl,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Chasis No',
// // //                       icon: Icons.qr_code,
// // //                       controller: chasisCtrl,
// // //                     ),

// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Engine No',
// // //                       icon: Icons.engineering,
// // //                       controller: engineCtrl,
// // //                     ),
// // //                     // TODO: add UI to manage multiple taxes
// // //                   ],
// // //                 );

// // //                 Widget rightColumn = Column(
// // //                   children: [
// // //                     CustomTextField(
// // //                       hint: 'CC',
// // //                       icon: Icons.speed,
// // //                       controller: ccCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                     const SizedBox(height: 8),

// // //                     CustomTextField(
// // //                       hint: 'Year of Manufacture',
// // //                       icon: Icons.calendar_today,
// // //                       controller: yomCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Seats',
// // //                       icon: Icons.airline_seat_recline_normal,
// // //                       controller: seatsCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Tonnage',
// // //                       icon: Icons.line_weight,
// // //                       controller: tonnageCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Value',
// // //                       icon: Icons.attach_money,
// // //                       controller: valueCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                       isRequired: true,
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     CustomTextField(
// // //                       hint: 'Basic Premium',
// // //                       icon: Icons.money,
// // //                       controller: basicPremiumCtrl,
// // //                       keyboardType: TextInputType.number,
// // //                       isRequired: true,
// // //                     ),
// // //                     const Divider(color: Colors.white30),
// // //                     // const Text(
// // //                     //   'Taxes (to be added dynamically)',
// // //                     //   style: TextStyle(color: Colors.white70),
// // //                     // ),
// // //                     // TODO: add UI to manage multiple taxes
// // //                   ],
// // //                 );
// // //                 return SingleChildScrollView(
// // //                   child: Column(
// // //                     children: [
// // //                       const Text(
// // //                         'Vehicle Details',
// // //                         style: TextStyle(color: Colors.white70),
// // //                       ),
// // //                       const SizedBox(height: 8),
// // //                       isWide
// // //                           ? Row(
// // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // //                               children: [
// // //                                 Expanded(child: leftColumn),
// // //                                 const SizedBox(width: 16),
// // //                                 Expanded(child: rightColumn),
// // //                               ],
// // //                             )
// // //                           : Column(
// // //                               children: [
// // //                                 leftColumn,
// // //                                 const SizedBox(height: 16),
// // //                                 rightColumn,
// // //                               ],
// // //                             ),
// // //                     ],
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //             isActive: true,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
