import 'package:flutter/cupertino.dart';

import '../blueprint/blueprint_view.dart';

class SimpleUIView extends StatelessWidget {
  const SimpleUIView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlueprintView(
      padBodyHorizontally: false,
      body: Center(
        child: Text('Simple UI'),
      ),
    );
  }
}
