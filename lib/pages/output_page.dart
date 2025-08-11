import 'package:flutter/material.dart';
import 'package:groups_v4/components/reactive/r_table.dart';
import 'package:groups_v4/controller.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static Map<Tab, Widget> tabs = {
    const Tab(text: "Gruppenübersicht"):
        RTable(table: viewController.groupOverviewTable),
    const Tab(text: "Zuordnungsergebnis"):
        RTable(table: viewController.assignmentTable),
    const Tab(text: "Zuordnungsanalyse"):
        RTable(table: viewController.analysisTable),
  };

  @override
  void initState() {
    _tabController = TabController(
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
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.keys.toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.values.toList(),
      ),
        ),
      ),
    );
  }
}
