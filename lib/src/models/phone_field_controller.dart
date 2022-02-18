import 'package:flutter/material.dart';

class PhoneFieldController extends ChangeNotifier {
  late final ValueNotifier<String?> isoCodeController;
  late final TextEditingController nationalController;
  final String defaultIsoCode;

  /// focus node of the national number
  final FocusNode focusNode;

  String? get isoCode => isoCodeController.value;
  String? get national =>
      nationalController.text.isEmpty ? null : nationalController.text;
  set isoCode(String? isoCode) => isoCodeController.value = isoCode;
  set national(String? national) {
    final currentSelectionOffset = nationalController.selection.extentOffset;
    final isCursorAtEnd =
        currentSelectionOffset == nationalController.text.length;
    // when the cursor is at the end we need to preserve that
    // since there is formatting going on we need to explicitely do it
    nationalController.value = TextEditingValue(
      text: national ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: isCursorAtEnd
              ? (national?.length ?? currentSelectionOffset)
              : currentSelectionOffset,
        ),
      ),
    );
  }

  PhoneFieldController({
    required String? national,
    required String? isoCode,
    required this.defaultIsoCode,
    required this.focusNode,
  }) {
    isoCodeController = ValueNotifier(isoCode);
    nationalController = TextEditingController(text: national);
    isoCodeController.addListener(notifyListeners);
    nationalController.addListener(notifyListeners);
  }

  selectNationalNumber() {
    nationalController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: nationalController.value.text.length,
    );
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    isoCodeController.dispose();
    nationalController.dispose();
    super.dispose();
  }
}
