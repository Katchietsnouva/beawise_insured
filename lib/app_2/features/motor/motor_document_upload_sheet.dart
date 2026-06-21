import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

enum _UploadStatus { idle, uploading, success, error }

class _DocState {
  final String name;
  final String label;
  final IconData icon;
  String? filePath;
  String? fileName;
  _UploadStatus status;
  String? error;

  _DocState({
    required this.name,
    required this.label,
    required this.icon,
  }) : status = _UploadStatus.idle;
}

class MotorDocumentUploadSheet extends ConsumerStatefulWidget {
  final String risknote;

  const MotorDocumentUploadSheet({super.key, required this.risknote});

  @override
  ConsumerState<MotorDocumentUploadSheet> createState() =>
      _MotorDocumentUploadSheetState();
}

class _MotorDocumentUploadSheetState
    extends ConsumerState<MotorDocumentUploadSheet> {
  final List<_DocState> _docs = [
    _DocState(name: 'logbook', label: 'Logbook', icon: Icons.book_outlined),
    _DocState(name: 'kra_pin', label: 'KRA PIN', icon: Icons.pin_outlined),
    _DocState(name: 'id', label: 'Copy of ID', icon: Icons.badge_outlined),
  ];

  Future<void> _pickFile(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.path == null) return;
    setState(() {
      _docs[index].filePath = file.path;
      _docs[index].fileName = file.name;
      _docs[index].status = _UploadStatus.idle;
      _docs[index].error = null;
    });
  }

  Future<void> _uploadFile(int index) async {
    final doc = _docs[index];
    if (doc.filePath == null) return;

    setState(() => doc.status = _UploadStatus.uploading);

    try {
      final authState = ref.read(authProvider);
      final token = authState.bearerToken!;
      final user = authState.user!;

      await ApiService.uploadPolicyDocument(
        token: token,
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        documentName: doc.name,
        risknote: widget.risknote,
        filePath: doc.filePath!,
        fileName: doc.fileName!,
      );

      setState(() => doc.status = _UploadStatus.success);
    } catch (e) {
      setState(() {
        doc.status = _UploadStatus.error;
        doc.error = e.toString();
      });
    }
  }

  Color _statusColor(_UploadStatus status) {
    switch (status) {
      case _UploadStatus.success:
        return Colors.green;
      case _UploadStatus.error:
        return Colors.red;
      case _UploadStatus.uploading:
        return Colors.orange;
      case _UploadStatus.idle:
        return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4);
    }
  }

  Widget _buildDocRow(int index) {
    final doc = _docs[index];
    final hasFile = doc.filePath != null;
    final isDone = doc.status == _UploadStatus.success;
    final isUploading = doc.status == _UploadStatus.uploading;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? Colors.green.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        color: isDone
            ? Colors.green.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          Icon(doc.icon, size: 20, color: _statusColor(doc.status)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(doc.label, type: CustomTextType.paragraph),
                if (doc.fileName != null && !isDone)
                  CustomText(
                    doc.fileName!,
                    type: CustomTextType.caption,
                    color: Colors.grey,
                    maxLines: 1,
                  ),
                if (doc.error != null)
                  CustomText(
                    'Upload failed. Tap retry.',
                    type: CustomTextType.caption,
                    color: Colors.red,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isDone)
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22)
          else if (isUploading)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          else ...[
            GestureDetector(
              onTap: () => _pickFile(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: CustomText(
                  hasFile ? 'Change' : 'Pick',
                  type: CustomTextType.caption,
                ),
              ),
            ),
            if (hasFile) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _uploadFile(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.favColour.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 18,
                    color: AppColors.favColour,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDone = _docs.every((d) => d.status == _UploadStatus.success);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
            : Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: CustomText(
                  'Upload Documents',
                  type: CustomTextType.subHeader,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.favColour.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  'Risknote: ${widget.risknote}',
                  type: CustomTextType.caption,
                  color: AppColors.favColour,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Required for Comprehensive cover — PDF, JPG or PNG',
              type: CustomTextType.caption,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          ...List.generate(_docs.length, _buildDocRow),
          const SizedBox(height: 8),
          CustomAdvancedButton(
            label: allDone ? 'Continue' : 'Skip for Now',
            variant: allDone ? ButtonVariant.primary : ButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
