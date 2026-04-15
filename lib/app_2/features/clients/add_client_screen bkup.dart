import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/insured_button.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/data/repositories/client_repository.dart';
import 'package:insured/app_2/providers/client_provider.dart';

class AddClientScreen extends ConsumerStatefulWidget {
  const AddClientScreen({super.key});

  @override
  ConsumerState<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  // Document type options
  final List<String> docTypes = [
    'National ID',
    'Passport',
    'Driver\'s License',
    'KCPE Certificate',
    'KCSE Certificate',
    'Other Document',
  ];
  String? selectedDocType;

  // Scanning states
  bool isScanning = false;
  bool scanSuccess = false;

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Simulate OCR result
  void _simulateScan() {
    setState(() {
      isScanning = true;
      scanSuccess = false;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isScanning = false;
          scanSuccess = true;
        });
        // Auto-fill based on selected document type
        _autoFillFields();
      }
    });
  }

  void _autoFillFields() {
    // Mock data – in real app, this would come from OCR
    if (selectedDocType == 'National ID') {
      firstNameController.text = 'PHILIP';
      lastNameController.text = 'ASWA';
      idNumberController.text = '37803209';
      emailController.text = 'philip@example.com';
      phoneController.text = '+254 712 345 678';
      addressController.text = '123 Main Street, Nairobi';
    } else if (selectedDocType == 'Passport') {
      firstNameController.text = 'JOHN';
      lastNameController.text = 'DOE';
      idNumberController.text = 'A1234567';
      emailController.text = 'john.doe@example.com';
      phoneController.text = '+254 700 000 000';
      addressController.text = '456 Avenue, Nairobi';
    } else if (selectedDocType == 'Driver\'s License') {
      firstNameController.text = 'JANE';
      lastNameController.text = 'SMITH';
      idNumberController.text = 'DL987654';
      emailController.text = 'jane.smith@example.com';
      phoneController.text = '+254 711 222 333';
      addressController.text = '789 Road, Mombasa';
    }
    // For other types, leave fields empty or partially filled
  }

  void _createClient() async {
    final client = Client(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${firstNameController.text} ${lastNameController.text}',
      email: emailController.text,
      phone: phoneController.text,
      status: 'active',
      idNumber: idNumberController.text,
    );
    final repo = ref.read(clientRepositoryProvider);
    await repo.addClient(client);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white60),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // Top section – Scan ID Document
                _buildScanSection(),
                const SizedBox(height: 24),
                // Client Details Form
                _buildFormSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanSection() {
    return GlassCard(
      blur: 10,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Client',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 16),
          // Document type dropdown
          DropdownButtonFormField<String>(
            value: selectedDocType,
            decoration: InputDecoration(
              labelText: 'Document Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: docTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) => setState(() => selectedDocType = value),
          ),
          const SizedBox(height: 24),
          // Scan card (dark navy)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1A2F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.scanner, size: 48, color: Colors.white70),
                const SizedBox(height: 8),
                const Text(
                  'Scan ID Document',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Take a photo or upload an ID to auto-fill client details',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 24),
                if (!isScanning && !scanSuccess)
                  // Initial state – buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: selectedDocType == null
                            ? null
                            : _simulateScan,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: selectedDocType == null
                            ? null
                            : _simulateScan,
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (isScanning)
                  Column(
                    children: [
                      const CircularProgressIndicator(color: Colors.amber),
                      const SizedBox(height: 12),
                      Text(
                        'Extracting details...',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                if (scanSuccess)
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 80,
                            color: Colors.white.withOpacity(0.1),
                            child: const Icon(
                              Icons.credit_card,
                              size: 48,
                              color: Colors.white70,
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 40,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            scanSuccess = false;
                          });
                        },
                        child: const Text(
                          'Scan Different ID',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return GlassCard(
      blur: 10,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.person, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Client Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 1: First Name, Last Name
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: ID Number (full width)
          TextField(
            controller: idNumberController,
            decoration: InputDecoration(
              labelText: 'ID Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Row 3: Email
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'john@example.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Row 4: Phone
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '+254 700 000 000',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Row 5: Address
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              hintText: '123 Main Street, Nairobi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _createClient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A1A2F),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create Client'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
