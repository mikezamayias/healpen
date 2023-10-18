import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/small_app_bar.dart';

class AppBar extends ConsumerWidget {
  final List<String> pathNames;
  final bool? automaticallyImplyLeading;
  final void Function()? onBackButtonPressed;

  const AppBar({
    Key? key,
    required this.pathNames,
    this.automaticallyImplyLeading = false,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SmallAppBar();
  }
}
