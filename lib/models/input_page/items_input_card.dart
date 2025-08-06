import 'package:flutter/material.dart';
import 'package:groups_v4/controller.dart';
import 'package:groups_v4/models/input_page/input_card.dart';

class ItemsInputCard extends StatelessWidget {
  const ItemsInputCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InputCard(
      titlePrefix: "Element",
      pasteAction: viewController.importItemsFromClipboard,
      table: viewController.itemsInput,
      errors: viewController.itemsErrors,
      formatInfo:
          "(insgesamt eindeutige) Identifikation | ... | Wahl 1 | ... | Wahl x",
    );
  }
}
