import 'package:flutter/material.dart';

import '../../insights/widgets/insights_tile.dart';
import '../simple_blueprint_view.dart';
import '../widgets/simple_app_bar.dart';

class SimpleInsightsTile extends StatelessWidget {
  const SimpleInsightsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleBlueprintView(
      simpleAppBar: SimpleAppBar(
        appBarTitleString: 'Insights',
      ),
      body: InsightsTile(),
    );
  }
}
