import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validated/validated.dart' as validated;

import '../../../extensions/widget_extenstions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';
import '../../blueprint/blueprint_view.dart';

class SettingsAccountView extends ConsumerStatefulWidget {
  const SettingsAccountView({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsAccountView> createState() =>
      _SettingsAccountViewState();
}

class _SettingsAccountViewState extends ConsumerState<SettingsAccountView> {
  final emailController = TextEditingController();
  bool readOnlyEmailTextField = true;

  @override
  Widget build(BuildContext context) {
    final currentUserEmailAddress = FirebaseAuth.instance.currentUser!.email;
    List<Widget> pageWidgets = [
      CustomListTile(
        titleString: 'Name',
        subtitle: TextField(
          decoration: InputDecoration(
            hintText: 'How should we call you?',
            hintStyle: context.theme.textTheme.titleLarge,
          ),
          style: context.theme.textTheme.titleLarge,
          onSubmitted: (String email) {},
        ),
      ),
      CustomListTile(
        titleString: 'Email',
        subtitle: TextFormField(
          enabled: !readOnlyEmailTextField,
          controller: emailController,
          readOnly: readOnlyEmailTextField,
          decoration: InputDecoration(
            fillColor: readOnlyEmailTextField
                ? context.theme.colorScheme.outline
                : Colors.white,
            hintText: currentUserEmailAddress,
            hintStyle: context.theme.textTheme.titleLarge,
            helperText: readOnlyEmailTextField
                ? 'Press the icon to edit your email'
                : 'You are editing your email',
            helperStyle: context.theme.textTheme.bodyMedium!.copyWith(
              color: context.theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: context.theme.textTheme.titleLarge,
          validator: (String? email) => validated.isEmail('$email')
              ? null
              : 'Please enter a valid email address.',
          onChanged: (String email) {
            log(email, name: 'email');
          },
          onFieldSubmitted: (String email) {
            log('$readOnlyEmailTextField', name: 'readOnlyEmailTextField');
            setState(() {
              readOnlyEmailTextField = !readOnlyEmailTextField;
            });
          },
        ),
        // trailingIconData: FontAwesomeIcons.penToSquare,
        textColor: readOnlyEmailTextField
            ? context.theme.colorScheme.outline
            : context.theme.colorScheme.primary,
        trailingOnTap: () {
          HapticFeedback.heavyImpact();
          log('$readOnlyEmailTextField', name: 'readOnlyEmailTextField');
          setState(() {
            readOnlyEmailTextField = !readOnlyEmailTextField;
          });
        },
      ),
      CustomListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: gap * 2,
          vertical: 12,
        ),
        titleString: 'Sign out',
        leadingIconData: FontAwesomeIcons.rightFromBracket,
        onTap: () {
          HapticFeedback.heavyImpact();
          // context.read(authProvider).signOut();
        },
      ),
      CustomListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: gap * 2,
          vertical: 12,
        ),
        titleString: 'Delete Account',
        leadingIconData: FontAwesomeIcons.trash,
        onTap: () {
          HapticFeedback.heavyImpact();
          // context.read(authProvider).signOut();
        },
      ),
    ].animateWidgetList();

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'Account'],
      ),
      body: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (_, int index) => pageWidgets[index],
        separatorBuilder: (_, __) => SizedBox(height: gap),
        itemCount: pageWidgets.length,
      ),
    );
  }
}
