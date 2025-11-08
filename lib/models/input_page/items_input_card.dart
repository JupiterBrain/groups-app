import 'package:flutter/material.dart';
import 'package:groups_app/controller.dart';
import 'package:groups_app/models/input_page/input_card.dart';

class ItemsInputCard extends StatelessWidget {
  const ItemsInputCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InputCard(
      titlePrefix: "Element",
      pasteAction: viewController.importItemsFromClipboard,
      table: viewController.itemsTable,
      errors: viewController.itemsErrors,
      formatInfo:
          "(insgesamt eindeutige) Identifikation | ... | Wahl 1 | ... | Wahl x",
      anchor: "items-input",
    );
  }
}
