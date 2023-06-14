import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/writing_controller.dart';
import '../../extensions/widget_extenstions.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class WritingView extends ConsumerWidget {
  const WritingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final controller = ref.read(writingControllerProvider.notifier);

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Hello Mike,\nWhat\'s on your mind today?'],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.all(gap),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(radius - gap),
                ),
                padding: EdgeInsets.all(gap),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: state.text,
                        onChanged: controller.handleTextChange,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        style: context.theme.textTheme.titleLarge!.copyWith(
                          overflow: TextOverflow.visible,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Express your feelings and thoughts',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    CustomListTile(
                      contentPadding: EdgeInsets.zero,
                      title: CheckboxListTile(
                        value: state.isPrivate,
                        enableFeedback: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (bool? value) {
                          controller.updatePrivate(value!);
                        },
                        title: Padding(
                          padding: EdgeInsets.only(left: gap),
                          child: const Text(
                            'Private entry',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: gap),
            Row(
              children: [
                Expanded(
                  child: CustomListTile(
                    backgroundColor: context.theme.colorScheme.surface,
                    titleString: 'Writing time',
                    subtitleString: state.seconds.toString(),
                    responsiveWidth: true,
                  ),
                ),
                if (state.text.isNotEmpty)
                  ...[
                    SizedBox(width: gap),
                    CustomListTile(
                      onTap: () => state.text.isNotEmpty
                          ? controller.handleSaveEntry('testing')
                          : null,
                      titleString: 'New Entry',
                      backgroundColor: state.text.isEmpty
                          ? context.theme.colorScheme.tertiary
                          : null,
                      textColor: state.text.isEmpty
                          ? context.theme.colorScheme.onTertiary
                          : null,
                      responsiveWidth: true,
                    ),
                  ].animateWidgetList(),
              ],
            ),
          ].animateWidgetList(),
        ),
      ).animateSlideInFromTop(),
    );
  }
}