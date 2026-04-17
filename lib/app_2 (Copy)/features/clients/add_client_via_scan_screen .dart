import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/data/repositories/client_repository.dart';
import 'package:insured/app_2/providers/client_provider.dart';
import 'package:riverpod/src/framework.dart';

class AddClientScreen extends ConsumerStatefulWidget {
  const AddClientScreen({super.key});

  @override
  ConsumerState<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  // Document types
  final List<String> docTypes = [
    'National ID',
    'Passport',
    "Driver's License",
    // 'KCPE Certificate',
    // 'KCSE Certificate',
    'Other Document',
  ];
  String? selectedDocType;

  // Image picking
  final ImagePicker _picker = ImagePicker();
  File? _capturedImage;

  bool isProcessing = false;
  bool scanSuccess = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  final dobController = TextEditingController();

  ProviderListenable<dynamic>? get clientRepositoryProvider => null;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    idNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    pinController.dispose();
    dobController.dispose();
    super.dispose();
  }

  /// Request camera permission (mobile only)
  Future<bool> _requestCameraPermission() async {
    if (Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS) {
      final status = await Permission.camera.request();
      return status.isGranted;
    }
    return true; // web/desktop assume granted
  }

  /// Pick image from camera
  Future<void> _takePhoto() async {
    // if (!await _requestCameraPermission()) {
    //   _showSnack('Camera permission denied');
    //   return;
    // }
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
          isProcessing = true;
          scanSuccess = false;
        });
        await _performOcr();
      }
    } catch (e) {
      _showSnack('Error taking photo: $e');
    }
  }

  /// Pick image from gallery
  Future<void> _uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
          isProcessing = true;
          scanSuccess = false;
        });
        await _performOcr();
      }
    } catch (e) {
      _showSnack('Error picking image: $e');
    }
  }

  /// Perform OCR using Google ML Kit (mobile) or fallback (web/desktop)
  Future<void> _performOcr() async {
    if (_capturedImage == null) return;

    // On web/desktop, ML Kit is not supported – show a message
    if (Theme.of(context).platform != TargetPlatform.android &&
        Theme.of(context).platform != TargetPlatform.iOS) {
      _showSnack('OCR is only available on mobile devices.\nUsing mock data.');
      await Future.delayed(const Duration(seconds: 1));
      _fillMockData();
      setState(() {
        isProcessing = false;
        scanSuccess = true;
      });
      return;
    }

    try {
      final inputImage = InputImage.fromFile(_capturedImage!);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      await textRecognizer.close();

      // Extract text blocks
      String fullText = recognizedText.text;
      if (fullText.isEmpty) {
        _showSnack('No text found in image. Try again.');
        setState(() {
          isProcessing = false;
          scanSuccess = false;
        });
        return;
      }

      // Parse the extracted text based on document type
      _parseOcrText(fullText);

      setState(() {
        isProcessing = false;
        scanSuccess = true;
      });
    } catch (e) {
      _showSnack('OCR failed: $e');
      setState(() {
        isProcessing = false;
        scanSuccess = false;
      });
    }
  }

  /// Simple parser to extract fields from raw OCR text
  void _parseOcrText(String text) {
    // Normalize text
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // Basic heuristics – you can improve this per document type
    for (String line in lines) {
      // Look for email pattern
      if (emailController.text.isEmpty &&
          line.contains('@') &&
          line.contains('.')) {
        emailController.text = line;
      }
      // Look for phone (starts with + or has 10+ digits)
      else if (phoneController.text.isEmpty &&
          (line.startsWith('+') || RegExp(r'\d{10,}').hasMatch(line))) {
        phoneController.text = line;
      }
      // Look for ID number (alphanumeric, 6+ chars)
      else if (idNumberController.text.isEmpty &&
          line.length > 5 &&
          !line.contains('@') &&
          !line.contains(' ')) {
        idNumberController.text = line;
      }
      // Assume first two non-empty lines are first and last name (fallback)
      if (firstNameController.text.isEmpty && lines.isNotEmpty) {
        firstNameController.text = lines[0];
        if (lines.length > 1) lastNameController.text = lines[1];
      }
    }

    // If still empty, use mock data as fallback
    if (firstNameController.text.isEmpty) {
      _fillMockData();
    }
  }

  void _fillMockData() {
    // Mock data based on document type
    switch (selectedDocType) {
      case 'National ID':
        firstNameController.text = 'PHILIP';
        lastNameController.text = 'ASWA';
        idNumberController.text = '37803209';
        emailController.text = 'philip@example.com';
        phoneController.text = '+254 712 345 678';
        addressController.text = '123 Main Street, Nairobi';
        break;
      case 'Passport':
        firstNameController.text = 'JOHN';
        lastNameController.text = 'DOE';
        idNumberController.text = 'A1234567';
        emailController.text = 'john.doe@example.com';
        phoneController.text = '+254 700 000 000';
        addressController.text = '456 Avenue, Nairobi';
        break;
      case "Driver's License":
        firstNameController.text = 'JANE';
        lastNameController.text = 'SMITH';
        idNumberController.text = 'DL987654';
        emailController.text = 'jane.smith@example.com';
        phoneController.text = '+254 711 222 333';
        addressController.text = '789 Road, Mombasa';
        break;
      default:
        break;
    }
  }

  void _createClient() async {
    final client = Client(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${firstNameController.text} ${lastNameController.text}'.trim(),
      email: emailController.text,
      phone: phoneController.text,
      status: 'active',
      idNumber: idNumberController.text,
    );
    final repo = ref.read(clientRepositoryProvider!);
    await repo.addClient(client);
    if (mounted) Navigator.pop(context);
  }

  void _resetScan() {
    setState(() {
      _capturedImage = null;
      isProcessing = false;
      scanSuccess = false;
      // Optionally clear fields
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Client',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [Color(0xFF0A1A2F), Color(0xFF07111F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    // Step 1: Document Type
                    GlassCard(
                      blur: 10,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Step 1: Select Document',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedDocType,
                            dropdownColor: const Color(0xFF1A2A3A),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Document Type',
                              labelStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                            ),
                            items: docTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedDocType = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Step 2: Capture / Preview
                    GlassCard(
                      blur: 10,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Step 2: Capture Document',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Image preview area
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: _capturedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      _capturedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.credit_card,
                                      size: 64,
                                      color: Colors.white24,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),

                          if (isProcessing)
                            const Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.amber,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Extracting details with OCR...',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            )
                          else if (scanSuccess)
                            Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Document scanned successfully',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: _resetScan,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Scan Another'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.amber,
                                    side: const BorderSide(color: Colors.amber),
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomAdvancedButton(
                                  label: 'Take Photo',
                                  icon: Icons.camera_alt,
                                  variant: ButtonVariant.secondary,
                                  onPressed: selectedDocType == null
                                      ? () => {}
                                      : _takePhoto,
                                  isDisabled: selectedDocType == null,
                                  // isCompact: true,
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: selectedDocType == null
                                      ? null
                                      : _uploadImage,
                                  icon: const Icon(Icons.upload),
                                  label: const Text('Upload'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.white30,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Step 3: Client Details Form
                    GlassCard(
                      blur: 10,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Step 3: Verify & Complete',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: firstNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('First Name'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: lastNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('Last Name'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              'Email Address',
                              hint: 'john@example.com',
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: phoneController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              'Phone Number',
                              hint: '+254 700 000 000',
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: idNumberController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('ID Number'),
                          ),
                          const SizedBox(height: 16),

                          // TextField(
                          //   controller: addressController,
                          //   style: const TextStyle(color: Colors.white),
                          //   decoration: _inputDecoration(
                          //     'Address',
                          //     hint: '123 Main Street',
                          //   ),
                          // ),
                          // const SizedBox(height: 16),
                          TextField(
                            controller: pinController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('pin', hint: '123'),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: dobController,
                            onTap: () => _selectDate(context),
                            style: const TextStyle(color: Colors.white),
                            decoration:
                                _inputDecoration(
                                  'Date of Birth',
                                  hint: '1999-01-01',
                                ).copyWith(
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white70,
                                  ),
                                ),
                          ),
                          const SizedBox(height: 24),

                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: TextField(
                          //         // controller: pinController,
                          //         decoration: InputDecoration(
                          //           labelText: 'PIN',
                          //           border: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 16),
                          //     Expanded(
                          //       child: TextField(
                          //         // controller: dobController,
                          //         decoration: InputDecoration(
                          //           labelText: 'Date of Birth (YYYY-MM-DD)',
                          //           border: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // Action Buttons
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
                                child: CustomAdvancedButton(
                                  label: 'Create Client',
                                  onPressed: _createClient,
                                  variant: ButtonVariant.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
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
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
    );
  }
}
