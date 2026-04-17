import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart'
    show QuoteOption;
import 'package:insured/app_2/features/motor/motor_save_screen.dart';
import 'package:insured/app_2/features/motor/widgets/quote_option_card.dart';

class MotorQuoteResultSection extends StatefulWidget {
  final List<dynamic> options;
  final String? selectedCoverage;
  final String? selectedScope;
  final String? selectedCoverPeriod;
  final double vehicleValue;
  final int yom;
  final bool excessProtectorSelected;
  final bool politicalViolenceSelected;

  final ValueChanged<bool?> onExcessProtectorChanged;
  final ValueChanged<bool?> onPoliticalViolenceChanged;
  final VoidCallback? onRegenerate;

  const MotorQuoteResultSection({
    super.key,
    required this.options,
    this.selectedCoverage,
    this.selectedScope,
    this.selectedCoverPeriod,
    this.vehicleValue = 0,
    this.yom = 0,

    required this.excessProtectorSelected,
    required this.politicalViolenceSelected,
    required this.onExcessProtectorChanged,
    required this.onPoliticalViolenceChanged,
    this.onRegenerate,
  });

  @override
  State<MotorQuoteResultSection> createState() =>
      _MotorQuoteResultSectionState();
}

class _MotorQuoteResultSectionState extends State<MotorQuoteResultSection> {
  void motorSaveScreen(BuildContext context, QuoteOption option) async {
    print(
      'here is tje passed  selectedQuote :  ${jsonEncode(option.toJson())}',
    );

    final prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(option.toJson());

    print('here is tje passed  selectedQuote :  ${prettyJson}');

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Crucial for text fields & keyboard
      backgroundColor: Colors.transparent, // Allows the glassmorphism to show
      barrierColor: Colors.black.withOpacity(0.5), // Dims the background
      // builder: (context) => const MotorSaveScreen(option),
      // builder: (context) => MotorSaveScreen(selectedQuote: option),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.98,
        child: MotorSaveScreen(
          selectedQuote: option,
          selectedCoverage: widget.selectedCoverage,
          selectedScope: widget.selectedScope,
          selectedCoverPeriod: widget.selectedCoverPeriod,
          initialVehicleValue: widget.vehicleValue,
          initialYom: widget.yom,
          // excessProtectorSelected: widget.excessProtectorSelected,
          // politicalViolenceSelected: widget.politicalViolenceSelected,
        ),
      ),

      // final quote = state.extra as QuoteOption?;
      // return MotorSaveScreen(selectedQuote: quote);
    );

    // If the modal returns true, refresh your client list or state
    if (result == true) {
      // ref.refresh(yourClientProvider);
      debugPrint("Client created! Refreshing UI...");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CustomText(
            'No quote options available',
            type: CustomTextType.subHeader,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            2,
            2,
            2,
            20,
            // MediaQuery.of(context).size.width < 700 ? 8 : 12,
          ),
          child: Opacity(
            opacity: 0.6,
            child: const CustomText(
              'These are the available quotes:',
              type: CustomTextType.paragraph,
            ),
          ),
        ),

        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;

            if (isWide) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      // options.map((option) {
                      widget.options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        return SizedBox(
                          // child: Padding(
                          // padding: const EdgeInsets.all(4.0),
                          width: (constraints.maxWidth / 3) - 12,
                          child: CardAnimationLayout(
                            index: index,
                            child: QuoteOptionCard(
                              option: option,
                              onSelect: () {
                                motorSaveScreen(context, option);
                              },
                            ),
                          ),
                          // ),
                        );
                      }).toList(),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 4, left: 1, right: 1),
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 1,
                    ),
                    child: CardAnimationLayout(
                      index: index,
                      child: QuoteOptionCard(
                        option: option,
                        onSelect: () => motorSaveScreen(context, option),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),

        if (widget.onRegenerate != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CustomAdvancedButton(
                    label: 'Edit Quote',
                    variant: ButtonVariant.secondary,
                    height: 50,
                    width: 400,
                    icon: Icon(Icons.edit),
                    onPressed: widget.onRegenerate ?? () {},
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// context.push('/motor/save', extra: option); // uncomment when ready

// class MotorQuoteResultSection extends ConsumerWidget {
//   final List options;
//   const MotorQuoteResultSection({super.key, required this.options});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(motorProvider);
//     // final options = state.quoteResponse?.options ?? [];

//     if (state.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//   }
// }
