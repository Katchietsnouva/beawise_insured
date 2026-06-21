import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

enum _UploadStatus { idle, uploading, success, error }

class _DocState {
  final String apiName;
  final String label;
  final IconData icon;
  List<int>? bytes;
  String? fileName;
  _UploadStatus status;

  _DocState({
    required this.apiName,
    required this.label,
    required this.icon,
    this.bytes,
    this.fileName,
  }) : status = _UploadStatus.idle;

  bool get hasPick => bytes != null;
  bool get isDone => status == _UploadStatus.success;
  bool get isUploading => status == _UploadStatus.uploading;
  bool get isError => status == _UploadStatus.error;
}

class MotorDocumentUploadSheet extends ConsumerStatefulWidget {
  final String risknote;
  final String clientNo;
  final String clientKey;
  final dynamic policyId;

  // Pre-picked files from Step 1 (optional)
  final List<int>? logbookBytes;
  final String? logbookName;
  final List<int>? kraPinBytes;
  final String? kraPinName;
  final List<int>? idDocBytes;
  final String? idDocName;

  const MotorDocumentUploadSheet({
    super.key,
    required this.risknote,
    required this.clientNo,
    required this.clientKey,
    required this.policyId,
    this.logbookBytes,
    this.logbookName,
    this.kraPinBytes,
    this.kraPinName,
    this.idDocBytes,
    this.idDocName,
  });

  @override
  ConsumerState<MotorDocumentUploadSheet> createState() =>
      _MotorDocumentUploadSheetState();
}

class _MotorDocumentUploadSheetState
    extends ConsumerState<MotorDocumentUploadSheet> {
  late final List<_DocState> _docs;

  @override
  void initState() {
    super.initState();
    _docs = [
      _DocState(
        apiName: 'logbook',
        label: 'Logbook',
        icon: Icons.book_outlined,
        bytes: widget.logbookBytes,
        fileName: widget.logbookName,
      ),
      _DocState(
        apiName: 'kra_pin',
        label: 'KRA PIN',
        icon: Icons.pin_outlined,
        bytes: widget.kraPinBytes,
        fileName: widget.kraPinName,
      ),
      _DocState(
        apiName: 'id',
        label: 'Copy of ID',
        icon: Icons.badge_outlined,
        bytes: widget.idDocBytes,
        fileName: widget.idDocName,
      ),
    ];
  }

  Future<void> _pickFile(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) return;
    setState(() {
      _docs[index].bytes = bytes;
      _docs[index].fileName = file.name;
      _docs[index].status = _UploadStatus.idle;
    });
  }

  Future<void> _uploadFile(int index) async {
    final doc = _docs[index];
    if (doc.bytes == null) return;

    setState(() => doc.status = _UploadStatus.uploading);

    try {
      final authState = ref.read(authProvider);
      print(
        '📤 UPLOAD [${doc.apiName}] file=${doc.fileName} bytes=${doc.bytes!.length} risknote=${widget.risknote} clientNo=${widget.clientNo}',
      );
      final result = await ApiService.uploadPolicyDocument(
        token: authState.bearerToken!,
        agentCode: authState.user!.agentCode,
        agentKey: authState.user!.agentKey,
        documentName: doc.apiName,
        risknote: widget.risknote,
        clientNo: widget.clientNo,
        clientKey: widget.clientKey,
        fileBytes: doc.bytes!,
        fileName: doc.fileName!,
      );
      print('✅ UPLOAD [${doc.apiName}] success: $result');
      setState(() => doc.status = _UploadStatus.success);

      if (mounted) {
        final url = result['url'] as String?;
        final expiresAt = result['expires_at'] as String?;
        FuturisticToastS.show(
          context: context,
          message:
              '${doc.label} uploaded${expiresAt != null ? '\n\nExpires on: ${formatHumanDate(expiresAt)}' : ''}',
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent,
          alignment: Alignment.topCenter,
          duration: const Duration(seconds: 6),
          showCopyButton: url != null,
          showCloseButton: true,
        );
      }
    } catch (e, st) {
      print('❌ UPLOAD [${doc.apiName}] ERROR: $e');
      print('❌ STACKTRACE: $st');
      setState(() => doc.status = _UploadStatus.error);
    }
  }

  Future<void> _uploadAll() async {
    for (int i = 0; i < _docs.length; i++) {
      final doc = _docs[i];
      if (doc.hasPick && !doc.isDone && !doc.isUploading) {
        await _uploadFile(i);
      }
    }
  }

  void _navigateToQuotes() {
    Navigator.of(context).pop();
    context.goNamed('quotes', extra: widget.policyId);
  }

  Color _iconColor(_DocState doc) {
    if (doc.isDone) return Colors.green;
    if (doc.hasPick) return AppColors.favColour;
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4);
  }

  Widget _buildDocRow(int index) {
    final doc = _docs[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: doc.isDone
              ? Colors.green.withValues(alpha: 0.5)
              : doc.isError
              ? Colors.red.withValues(alpha: 0.4)
              : doc.hasPick
              ? AppColors.favColour.withValues(alpha: 0.4)
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        color: doc.isDone
            ? Colors.green.withValues(alpha: 0.05)
            : doc.isError
            ? Colors.red.withValues(alpha: 0.03)
            : doc.hasPick
            ? AppColors.favColour.withValues(alpha: 0.04)
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          Icon(doc.icon, size: 20, color: _iconColor(doc)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(doc.label, type: CustomTextType.paragraph),
                if (doc.fileName != null && !doc.isDone)
                  CustomText(
                    doc.fileName!,
                    type: CustomTextType.caption,
                    color: Colors.grey,
                    maxLines: 1,
                  ),
                if (doc.isError)
                  const CustomText(
                    'Upload failed — tap retry',
                    type: CustomTextType.caption,
                    color: Colors.red,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (doc.isDone)
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 22,
            )
          else if (doc.isUploading)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          else ...[
            GestureDetector(
              onTap: () => _pickFile(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: CustomText(
                  doc.hasPick ? 'Change' : 'Pick',
                  type: CustomTextType.caption,
                ),
              ),
            ),
            // retry button shown only after an error
            if (doc.isError) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _uploadFile(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                    color: Colors.red,
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
    final allDone = _docs.every((d) => d.isDone);
    final anyUploading = _docs.any((d) => d.isUploading);
    final anyPickedNotDone = _docs.any((d) => d.hasPick && !d.isDone);
    final noPicks = _docs.every((d) => !d.hasPick);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          if (anyUploading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  SizedBox(width: 10),
                  CustomText(
                    'Uploading...',
                    type: CustomTextType.caption,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          else if (allDone)
            CustomAdvancedButton(
              label: 'Continue to Quotes',
              variant: ButtonVariant.primary,
              onPressed: _navigateToQuotes,
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: CustomAdvancedButton(
                    label: noPicks ? 'Skip for Now' : 'Skip Upload',
                    variant: ButtonVariant.primary,
                    color1: Colors.redAccent,
                    onPressed: _navigateToQuotes,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomAdvancedButton(
                    label: 'Upload Documents',
                    variant: ButtonVariant.primary,
                    isDisabled: !anyPickedNotDone,
                    onPressed: _uploadAll,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
