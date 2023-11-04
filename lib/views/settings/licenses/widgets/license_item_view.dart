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
          'Licenses',
          licenceModel.packageName,
        ],
      ),
      body: ListView.separated(
        itemBuilder: (_, int index) {
          return SelectableText(
            licenceModel.licenceParagraphs[index],
            style: context.theme.textTheme.bodyLarge,
          ).animate().fade(
                curve: standardCurve,
                duration: standardDuration,
              );
        },
        separatorBuilder: (_, int index) => TextDivider(
          'Licence ${index + 1}/${licenceModel.licenceParagraphs.length - 1}',
        ),
        itemCount: licenceModel.licenceParagraphs.length - 1,
      ),
    );
  }
}
