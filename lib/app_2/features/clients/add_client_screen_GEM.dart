import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// Your Project Imports
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/providers/client_provider.dart';

class AddClientScreen extends ConsumerStatefulWidget {
  const AddClientScreen({super.key});

  @override
  ConsumerState<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  // Logic Tools
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  bool _isScanning = false;
  File? _imageFile;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Add this method inside _AddClientScreenState class, after the fields (e.g., after final _phoneController = TextEditingController();)
  void showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    try {
      _textRecognizer.close();
    } catch (e) {
      showErrorDialog(e.toString());
    }
    super.dispose();
  }

  /// THE CORE LOGIC: Capture and Process
  Future<void> _pickAndProcess(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100, // Keep quality high for OCR accuracy
      );

      if (pickedFile == null) return;

      setState(() {
        _imageFile = File(pickedFile.path);
        _isScanning = true;
      });

      try {
        final inputImage = InputImage.fromFilePath(pickedFile.path);
        final RecognizedText recognizedText = await _textRecognizer
            .processImage(inputImage);

        _parseRecognizedText(recognizedText.text);
      } catch (e) {
        debugPrint("OCR Error: $e");
        showErrorDialog(e.toString());
      } finally {
        setState(() => _isScanning = false);
      }
    } catch (e) {
      showErrorDialog(e.toString());
      return;
    }
  }

  /// INDUSTRY LOGIC: Parsing raw text into fields
  void _parseRecognizedText(String rawText) {
    // Convert to uppercase for easier matching
    final String text = rawText.toUpperCase();
    final List<String> lines = text.split('\n');

    debugPrint("RAW SCAN DATA: $text");

    // Simple Regex for ID patterns (e.g., 8 digits)
    final idRegex = RegExp(r'\b\   d{7,9}\b');
    final emailRegex = RegExp(r'[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+');

    setState(() {
      // Find ID Number
      final idMatch = idRegex.firstMatch(text);
      if (idMatch != null) _idNumberController.text = idMatch.group(0)!;

      // Find Email
      final emailMatch = emailRegex.firstMatch(text);
      if (emailMatch != null)
        _emailController.text = emailMatch.group(0)!.toLowerCase();

      // Basic Name Extraction (Usually the first two lines of an ID)
      if (lines.length > 1) {
        _firstNameController.text = lines[0].trim();
        _lastNameController.text = lines[1].trim();
      }
    });
  }

  void _createClient() {
    if (_firstNameController.text.isEmpty) return;

    final client = Client(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${_firstNameController.text} ${_lastNameController.text}',
      email: _emailController.text,
      phone: _phoneController.text,
      status: 'active',
      idNumber: _idNumberController.text,
    );

    // ref.read(clientProvider.notifier).addClient(client);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03080F),
      appBar: AppBar(
        title: const Text(
          "Verify Document",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildScannerUI(),
            const SizedBox(height: 25),
            _buildFormUI(),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerUI() {
    return GlassCard(
      blur: 20,
      child: Column(
        children: [
          // Real-time Viewfinder feel
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: _imageFile != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(_imageFile!, fit: BoxFit.cover),
                        if (_isScanning) _buildScanningAnimation(),
                      ],
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.document_scanner,
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Ready to Scan ID",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ScanButton(
                  label: "Take Photo",
                  icon: Icons.camera_alt,
                  onPressed: () => _pickAndProcess(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScanButton(
                  label: "Upload",
                  icon: Icons.upload_file,
                  onPressed: () => _pickAndProcess(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanningAnimation() {
    return Container(
      color: Colors.black54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blueAccent),
          const SizedBox(height: 15),
          Text(
            "EXTRACTING DATA...",
            style: TextStyle(
              color: Colors.blueAccent[100],
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormUI() {
    return GlassCard(
      blur: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verify Extracted Data",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Divider(color: Colors.white10, height: 30),
          _InputField(controller: _firstNameController, label: "First Name"),
          _InputField(controller: _lastNameController, label: "Last Name"),
          _InputField(controller: _idNumberController, label: "ID Number"),
          _InputField(controller: _emailController, label: "Email"),
          _InputField(controller: _phoneController, label: "Phone"),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _createClient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "SAVE CLIENT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper Widgets
class _ScanButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ScanButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white10,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _InputField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: Colors.black26,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
