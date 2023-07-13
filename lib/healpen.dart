import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/page_providers.dart';
import 'utils/constants.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class Healpen extends ConsumerWidget {
  const Healpen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(currentPageProvider).widget,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: gap),
        child: const CustomBottomNavigationBar(),
      ),
    );
  }
}
