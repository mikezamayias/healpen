import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_list_tile.dart';

class UnknownState extends StatelessWidget {
  final AuthState state;

  const UnknownState({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titleString: 'Unknown state',
      subtitleString: '${state.runtimeType}',
    );
  }
}
