import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide AppBar, Divider, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../extensions/widget_extensions.dart';
import '../../../models/license_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/logger.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/loading_tile.dart';
import '../../blueprint/blueprint_view.dart';
import '../../simple/simple_blueprint_view.dart';
import '../../simple/widgets/simple_app_bar.dart';
import 'widgets/license_item_view.dart';

class SettingsLicensesView extends ConsumerWidget {
  const SettingsLicensesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget body = CustomLicensePage(
      builder: (context, licenceData) {
        if (licenceData.hasData) {
          List<LicenceModel> licences = [
            ...licenceData.data!.packages.map(
              (e) => LicenceModel(
                packageName: e,
                licenceParagraphs: [
                  for (int i in licenceData.data!.packageLicenseBindings[e]!)
                    licenceData.data!.licenses
                        .elementAt(i)
                        .paragraphs
                        .map((e) => e.text)
                        .join(' ')
                ],
              ),
            ),
          ];
          licences.insert(
            0,
            licences.removeAt(licences.indexWhere(
              (LicenceModel element) => element.packageName == 'healpen',
            )),
          );
          List<Widget> licenceTiles = [
            ...licences.map(
              (LicenceModel licence) {
                return CustomListTile(
                  useSmallerNavigationSetting:
                      !ref.watch(navigationSmallerNavigationElementsProvider),
                  enableExplanationWrapper:
                      !ref.watch(navigationSmallerNavigationElementsProvider),
                  responsiveWidth: true,
                  leadingIconData: licence.packageName == 'healpen'
                      ? FontAwesomeIcons.solidHeart
                      : null,
                  titleString: licence.packageName,
                  onTap: () {
                    logger.i(
                      licence.toString(),
                    );
                    pushWithAnimation(
                      context: context,
                      widget: LicenseItemView(licenceModel: licence),
                      dataCallback: null,
                    );
                  },
                );
              },
            )
          ].animateLicenses();
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: gap,
                runSpacing: gap,
                children: licenceTiles,
              ),
            ),
          );
        } else if (licenceData.hasError) {
          //   display error
          return CustomListTile(
            leadingIconData: Icons.error,
            titleString: 'Error',
            subtitleString: licenceData.error.toString(),
          ).animateSlideInFromLeft();
        } else {
          //   display loading
          return const LoadingTile(
            durationTitle: 'Loading licences...',
          ).animateSlideInFromLeft();
        }
      },
    );
    return ref.watch(navigationSimpleUIProvider)
        ? SimpleBlueprintView(
            simpleAppBar: const SimpleAppBar(
              appBarTitleString: 'Open Source Licenses',
            ),
            body: body,
          )
        : BlueprintView(
            appBar: const AppBar(
              automaticallyImplyLeading: true,
              pathNames: [
                'Settings',
                'About',
                'Open Source Licenses',
              ],
            ),
            body: body,
          );
  }
}

/// A page that shows licenses for software used by the application.
///
/// The licenses shown on the [CustomLicensePage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
class CustomLicensePage extends StatefulWidget {
  const CustomLicensePage({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext, AsyncSnapshot<LicenseData>) builder;

  @override
  CustomLicensePageState createState() => CustomLicensePageState();
}

class CustomLicensePageState extends State<CustomLicensePage> {
  final ValueNotifier<int> selectedId = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LicenseData>(
      future: licenses,
      builder: widget.builder,
    );
  }

  final Future<LicenseData> licenses = LicenseRegistry.licenses
      .fold<LicenseData>(
        LicenseData(),
        (LicenseData prev, LicenseEntry license) => prev..addLicense(license),
      )
      .then((LicenseData licenseData) => licenseData..sortPackages());
}

/// This is a collection of licenses and the packages to which they apply.
/// [packageLicenseBindings] records the m+:n+ relationship between the license
/// and packages as a map of package names to license indexes.
class LicenseData {
  final List<LicenseEntry> licenses = <LicenseEntry>[];
  final Map<String, List<int>> packageLicenseBindings = <String, List<int>>{};
  final List<String> packages = <String>[];

  // Special treatment for the first package since it should be the package
  // for delivered application.
  String? firstPackage;

  void addLicense(LicenseEntry entry) {
    // Before the license can be added, we must first record the packages to
    // which it belongs.
    for (final String package in entry.packages) {
      _addPackage(package);
      // Bind this license to the package using the next index value. This
      // creates a contract that this license must be inserted at this same
      // index value.
      packageLicenseBindings[package]?.add(licenses.length);
    }
    licenses.add(entry); // Completion of the contract above.
  }

  /// Add a package and initialise package license binding. This is a no-op if
  /// the package has been seen before.
  void _addPackage(String package) {
    if (!packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      packages.add(package);
    }
  }

  /// Sort the packages using some comparison method, or by the default manner,
  /// which is to put the application package first, followed by every other
  /// package in case-insensitive alphabetical order.
  void sortPackages() {
    packages.sort((String a, String b) {
      // Based on how LicenseRegistry currently behaves, the first package
      // returned is the end user application license. This should be
      // presented first in the list. So here we make sure that first package
      // remains at the front regardless of alphabetical sorting.
      if (a == firstPackage) {
        return -1;
      }
      if (b == firstPackage) {
        return 1;
      }
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
  }
}
