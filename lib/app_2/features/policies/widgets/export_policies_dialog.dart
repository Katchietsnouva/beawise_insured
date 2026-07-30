import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/error_parser.dart';
import 'package:insured/app_2/core/utils/file_download.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/providers/policy_provider.dart';

/// Dialog that lets the user pick export parameters (status, records per page,
/// page) and downloads the resulting Excel spreadsheet.
class ExportPoliciesDialog extends ConsumerStatefulWidget {
  /// Fixed status for this screen (e.g. 1 = Production). When non-null the
  /// status picker is hidden and this value is always used.
  final int? fixedStatus;

  /// Human label used in the dialog title and default file name.
  final String title;

  const ExportPoliciesDialog({
    super.key,
    this.fixedStatus,
    this.title = 'Production',
  });

  @override
  ConsumerState<ExportPoliciesDialog> createState() =>
      _ExportPoliciesDialogState();
}

class _ExportPoliciesDialogState extends ConsumerState<ExportPoliciesDialog> {
  late int _status;
  int _perPage = 100;
  int _page = 1;
  bool _isDownloading = false;

  static const _mimeXlsx =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  @override
  void initState() {
    super.initState();
    _status = widget.fixedStatus ?? ref.read(policyProvider).currentStatus;
    _perPage = ref.read(policyProvider).perPage;
  }

  Future<void> _download() async {
    setState(() => _isDownloading = true);
    try {
      final bytes = await ref
          .read(policyProvider.notifier)
          .exportPolicies(page: _page, perPage: _perPage, status: _status);

      final stamp = DateTime.now()
          .toIso8601String()
          .split('.')
          .first
          .replaceAll(':', '-');
      final fileName =
          '${widget.title.toLowerCase()}_status${_status}_$stamp.xlsx';

      final saved = await saveBytesToDevice(
        bytes: bytes,
        fileName: fileName,
        mimeType: _mimeXlsx,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      if (saved) {
        FuturisticToastT.show(
          context: context,
          message: 'Export ready: $fileName',
          icon: Icons.download_done,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      final parsed = ErrorParser.fromRaw(e);
      FuturisticToastT.show(
        context: context,
        message: parsed.message,
        errors: parsed.errors,
        icon: Icons.error_outline,
        showCopyButton: true,
        duration: const Duration(seconds: 6),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          const Icon(Icons.table_view, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
              'Export ${widget.title} to Excel',
              type: CustomTextType.subHeader,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Choose what to include, then download the spreadsheet.',
            type: CustomTextType.caption,
          ),
          const SizedBox(height: 16),

          if (widget.fixedStatus == null) ...[
            const CustomText('Status', type: CustomTextType.caption),
            const SizedBox(height: 4),
            CustomDropdown<int>(
              hint: 'Status',
              icon: Icons.flag_outlined,
              value: _status,
              items: List.generate(4, (i) => i)
                  .map(
                    (i) => DropdownMenuItem<int>(
                      value: i,
                      child: Text('Status $i'),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _status = val);
              },
            ),
            const SizedBox(height: 12),
          ],

          // const CustomText('Records per page', type: CustomTextType.caption),
          const SizedBox(height: 4),
          CustomDropdown<int>(
            hint: 'Records per page',
            icon: Icons.format_list_numbered,
            value: _perPage,
            items: const [10, 20, 50, 100]
                .map((v) => DropdownMenuItem<int>(value: v, child: Text('$v')))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _perPage = val);
            },
          ),
          const SizedBox(height: 12),

          const CustomText('Export Page', type: CustomTextType.caption),
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _page > 1 ? () => setState(() => _page--) : null,
              ),
              CustomText('$_page', type: CustomTextType.paragraph),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => _page++),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isDownloading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CustomAdvancedButton(
          height: 40,
          width: 160,
          label: _isDownloading ? 'Preparing...' : 'Download Excel',
          variant: ButtonVariant.primary,
          loading: _isDownloading,
          icon: const Icon(Icons.download, size: 18, color: Colors.white),
          onPressed: _isDownloading ? () {} : _download,
        ),
      ],
    );
  }
}
