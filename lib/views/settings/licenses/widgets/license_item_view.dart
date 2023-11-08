import 'package:flutter/material.dart' hide PageController, AppBar;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../models/license_model.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/text_divider.dart';
import '../../../blueprint/blueprint_view.dart';

class LicenseItemView extends StatelessWidget {
  final LicenceModel licenceModel;

  const LicenseItemView({
    super.key,
    required this.licenceModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        pathNames: [
          'Settings',
          'About',
          'Open Source Licenses',
          licenceModel.packageName,
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ListView.builder(
          itemCount: licenceModel.licenceParagraphs.length,
          itemBuilder: (_, int index) {
            return Column(
              children: [
                TextDivider(
                    'Licence ${index + 1}/${licenceModel.licenceParagraphs.length}'),
                SelectableText(
                  licenceModel.licenceParagraphs[index],
                  style: context.theme.textTheme.bodyLarge,
                ).animate().fade(
                      curve: standardCurve,
                      duration: standardDuration,
                    ),
                Gap(gap),
              ],
            );
          },
        ),
      ),
    );
  }
}
