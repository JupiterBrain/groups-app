import 'package:flutter/material.dart';
import 'package:groups_app/components/reactive/reactive_wrapper.dart';
import 'package:groups_app/components/table.dart';
import 'package:groups_app/controller.dart';
import 'package:groups_app/utils.dart';
import 'package:groups_app/utils/spreadsheet.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static Map<Tab, Widget> tabs = {
    //TODO add scroll to other tables
    const .new(text: "Gruppenübersicht"): reactiveTable(
      viewController.groupOverviewTable,
    ),
    const .new(text: "Zuordnungsergebnis"): reactiveTable(
      viewController.assignmentTable,
    ),
    const .new(text: "Zuordnungsanalyse"): reactiveTable(
      viewController.analysisTable,
    ),
  };

  @override
  void initState() {
    _tabController = .new(
      length: tabs.length,
      vsync: this,
      initialIndex: ~viewController.outputPageTab,
    );
    _tabController.addListener(updateOutputPageTab);
    super.initState();
  }

  void updateOutputPageTab() =>
      viewController.outputPageTab << _tabController.index;

  @override
  void dispose() {
    _tabController.removeListener(updateOutputPageTab);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ausgabe'),
        bottom: TabBar(controller: _tabController, tabs: tabs.keys.toList()),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.values.toList(),
      ),
      floatingActionButton: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: viewController.copyCurrentResultTableToClipboard,
          label: const Row(
            children: [Text('Kopieren'), SizedBox(width: 4), Icon(Icons.copy)],
          ),
        ),
      ),
    );
  }
}

Widget reactiveTable(RV<Spreadsheet?> rv) => ReactiveWrapper(
  reactiveValues: [rv],
  builder: (context) {
    var table = ~rv;

    if (table == null) return null;

    return SpreadsheetTable(table);
  },
);
