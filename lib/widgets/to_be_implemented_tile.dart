import 'package:flutter/material.dart';

import 'custom_list_tile.dart';

class ToBeImplementedTile extends StatelessWidget {
  const ToBeImplementedTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomListTile(
        titleString: 'To be implemented...',
        responsiveWidth: true,
      ),
    );
  }
}
