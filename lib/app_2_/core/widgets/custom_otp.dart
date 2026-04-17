import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class OTPInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final bool isRequired;
  final TextEditingController? controller;

  const OTPInput({
    Key? key,
    this.length = 6,
    required this.onCompleted,
    this.isRequired = false,
    this.controller,
  }) : super(key: key);

  @override
  _OTPInputState createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<bool> _isEmpty;
  bool _isUpdatingInternally = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(
      widget.length,
      (index) => _createFocusNode(index),
    );
    _isEmpty = List.generate(widget.length, (_) => true);

    widget.controller?.addListener(_handleExternalControllerChange);

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        if (_isUpdatingInternally) return;
        if (!mounted) return;
        setState(() {
          _isEmpty[i] = _controllers[i].text.isEmpty;
        });
        _syncToExternal();

        if (_controllers.every((c) => c.text.isNotEmpty)) {
          String otp = _controllers.map((c) => c.text).join();
          widget.onCompleted(otp);
        }
      });
    }

    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _handleExternalControllerChange();
    }
  }

  void _syncToExternal() {
    if (widget.controller == null) return;
    _isUpdatingInternally = true;
    widget.controller!.text = _controllers.map((c) => c.text).join();
    _isUpdatingInternally = false;
  }

  void _handleExternalControllerChange() {
    if (_isUpdatingInternally) return;
    final externalText = widget.controller?.text ?? "";
    setState(() {
      _isUpdatingInternally = true;
      for (int i = 0; i < widget.length; i++) {
        if (i < externalText.length) {
          _controllers[i].text = externalText[i];
          _isEmpty[i] = false;
        } else {
          _controllers[i].clear();
          _isEmpty[i] = true;
        }
      }
      _isUpdatingInternally = false;
    });
  }

  FocusNode _createFocusNode(int index) {
    final node = FocusNode();
    node.onKeyEvent = (FocusNode node, KeyEvent event) {
      if (event is KeyDownEvent) {
        final isV = event.logicalKey == LogicalKeyboardKey.keyV;
        bool isModifierPressed = false;
        if (kIsWeb) {
          isModifierPressed =
              HardwareKeyboard.instance.isMetaPressed ||
              HardwareKeyboard.instance.isControlPressed;
        } else if (!kIsWeb && Platform.isMacOS) {
          isModifierPressed = HardwareKeyboard.instance.isMetaPressed;
        } else {
          isModifierPressed = HardwareKeyboard.instance.isControlPressed;
        }

        if (isV && isModifierPressed) {
          _handlePasteFromClipboard(index);
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
    return node;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalControllerChange);
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _handlePaste(String pastedText, int startIndex) {
    if (pastedText.isEmpty) return;
    pastedText = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
    int spaceAvailable = widget.length - startIndex;
    if (pastedText.length > spaceAvailable) {
      pastedText = pastedText.substring(0, spaceAvailable);
    }

    _isUpdatingInternally = true;
    for (int i = 0; i < pastedText.length; i++) {
      _controllers[startIndex + i].text = pastedText[i];
      setState(() => _isEmpty[startIndex + i] = false);
    }
    _isUpdatingInternally = false;
    _syncToExternal();

    int nextIndex = startIndex + pastedText.length;
    if (nextIndex < widget.length) {
      _focusNodes[nextIndex].requestFocus();
    } else {
      _focusNodes.last.unfocus();
    }

    // Fire onCompleted if all filled
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      widget.onCompleted(_controllers.map((c) => c.text).join());
    }
  }

  Future<void> _handlePasteFromClipboard(int startIndex) async {
    final data = await Clipboard.getData('text/plain');
    if (data != null && data.text != null) {
      _handlePaste(data.text!, startIndex);
    }
  }

  void _onChanged(String value, int index) {
    // ✅ FIX 1: Handle multi-char input (Android context-menu paste & autofill)
    if (value.length > 1) {
      _handlePaste(value, index);
      return;
    }

    if (value.length == 1) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 2: Wrap in AutofillGroup for SMS autofill coordination
    return AutofillGroup(
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.length, (index) {
            return Container(
              width: 45,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (widget.isRequired && _isEmpty[index])
                      ? Colors.red.withOpacity(0.4)
                      : Colors.white.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                ),
                maxLength: 1,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                // ✅ FIX 3: Tell Android this is a one-time-code field
                autofillHints: const [AutofillHints.oneTimeCode],
                onChanged: (value) => _onChanged(value, index),
                // ✅ Remove FilteringTextInputFormatter — it blocks paste on Android
                // Let _onChanged strip non-digits via _handlePaste instead
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            );
          }),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;

// class OTPInput extends StatefulWidget {
//   final int length;
//   final ValueChanged<String> onCompleted;
//   final bool isRequired;
//   final TextEditingController? controller;

//   const OTPInput({
//     Key? key,
//     this.length = 6,
//     required this.onCompleted,
//     this.isRequired = false,
//     this.controller,
//   }) : super(key: key);

//   @override
//   _OTPInputState createState() => _OTPInputState();
// }

// class _OTPInputState extends State<OTPInput> {
//   late List<TextEditingController> _controllers;
//   late List<FocusNode> _focusNodes;
//   late List<bool> _isEmpty;
//   bool _isUpdatingInternally = false;

//   @override
//   void initState() {
//     super.initState();
//     _controllers = List.generate(widget.length, (_) => TextEditingController());
//     _focusNodes = List.generate(
//       widget.length,
//       (index) => _createFocusNode(index),
//     );
//     _isEmpty = List.generate(widget.length, (_) => true);

//     widget.controller?.addListener(_handleExternalControllerChange);

//     for (int i = 0; i < widget.length; i++) {
//       _controllers[i].addListener(() {
//         if (_isUpdatingInternally) return;

//         if (!mounted) return;
//         setState(() {
//           _isEmpty[i] = _controllers[i].text.isEmpty;
//         });
//         _syncToExternal();

//         if (_controllers.every((c) => c.text.isNotEmpty)) {
//           String otp = _controllers.map((c) => c.text).join();
//           widget.onCompleted(otp);
//         }
//       });
//     }

//     if (widget.controller != null && widget.controller!.text.isNotEmpty) {
//       _handleExternalControllerChange();
//     }
//   }

//   void _syncToExternal() {
//     if (widget.controller == null) return;
//     _isUpdatingInternally = true;
//     widget.controller!.text = _controllers.map((c) => c.text).join();
//     _isUpdatingInternally = false;
//   }

//   void _handleExternalControllerChange() {
//     if (_isUpdatingInternally) return;

//     final externalText = widget.controller?.text ?? "";

//     setState(() {
//       _isUpdatingInternally = true;
//       for (int i = 0; i < widget.length; i++) {
//         if (i < externalText.length) {
//           _controllers[i].text = externalText[i];
//           _isEmpty[i] = false;
//         } else {
//           _controllers[i].clear();
//           _isEmpty[i] = true;
//         }
//       }
//       _isUpdatingInternally = false;
//     });
//   }

//   FocusNode _createFocusNode(int index) {
//     final node = FocusNode();
//     node.onKeyEvent = (FocusNode node, KeyEvent event) {
//       if (event is KeyDownEvent) {
//         final isV = event.logicalKey == LogicalKeyboardKey.keyV;
//         bool isModifierPressed = false;
//         if (kIsWeb) {
//           isModifierPressed =
//               HardwareKeyboard.instance.isMetaPressed ||
//               HardwareKeyboard.instance.isControlPressed;
//         } else if (Platform.isMacOS) {
//           isModifierPressed = HardwareKeyboard.instance.isMetaPressed;
//         } else {
//           isModifierPressed = HardwareKeyboard.instance.isControlPressed;
//         }

//         if (isV && isModifierPressed) {
//           _handlePasteFromClipboard(index);
//           return KeyEventResult.handled;
//         }
//       }
//       return KeyEventResult.ignored;
//     };
//     return node;
//   }

//   @override
//   void dispose() {
//     widget.controller?.removeListener(_handleExternalControllerChange);
//     for (var c in _controllers) c.dispose();
//     for (var f in _focusNodes) f.dispose();
//     super.dispose();
//   }

//   void _handlePaste(String pastedText, int startIndex) {
//     if (pastedText.isEmpty) return;
//     pastedText = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
//     int spaceAvailable = widget.length - startIndex;
//     if (pastedText.length > spaceAvailable) {
//       pastedText = pastedText.substring(0, spaceAvailable);
//     }

//     for (int i = 0; i < pastedText.length; i++) {
//       _controllers[startIndex + i].text = pastedText[i];
//     }

//     int nextIndex = startIndex + pastedText.length;
//     if (nextIndex < widget.length) {
//       _focusNodes[nextIndex].requestFocus();
//     } else {
//       _focusNodes.last.unfocus();
//     }
//   }

//   Future<void> _handlePasteFromClipboard(int startIndex) async {
//     final data = await Clipboard.getData('text/plain');
//     if (data != null && data.text != null) {
//       _handlePaste(data.text!, startIndex);
//     }
//   }

//   void _onChanged(String value, int index) {
//     if (value.length == 1) {
//       if (index < widget.length - 1) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         _focusNodes[index].unfocus();
//       }
//     } else if (value.isEmpty && index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(widget.length, (index) {
//           return Container(
//             width: 45,
//             height: 60,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: (widget.isRequired && _isEmpty[index])
//                     ? Colors.red.withOpacity(0.4)
//                     : Colors.white.withOpacity(0.2),
//               ),
//             ),
//             child: TextField(
//               controller: _controllers[index],
//               focusNode: _focusNodes[index],
//               keyboardType: TextInputType.number,
//               textAlign: TextAlign.center,
//               textAlignVertical: TextAlignVertical.center,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurface,
//                 fontSize: 20,
//               ),
//               maxLength: 1,
//               decoration: const InputDecoration(
//                 counterText: '',
//                 border: InputBorder.none,
//               ),
//               onChanged: (value) => _onChanged(value, index),
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
