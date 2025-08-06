import 'package:flutter/material.dart';
import 'package:groups_v4/controller.dart';
import 'package:groups_v4/models/input_page/input_card.dart';

class GroupsInputCard extends StatelessWidget {
  const GroupsInputCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InputCard(
      titlePrefix: "Gruppen",
      pasteAction: viewController.importGroupsFromClipboard,
      table: viewController.groupsTable,
      errors: viewController.groupsErrors,
      formatInfo: "eindeutiger Identifikator | optionale Beschreibung | ... | "
          "Kapazität (/ globale Kapazität verwenden)",
    );
  }
}
