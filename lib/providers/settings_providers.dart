import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/app_theming.dart';

final appearanceProvider = StateProvider<Appearance>(
  (ref) => Appearance.system,
);

final appColorProvider = StateProvider<AppColor>(
  (ref) => AppColor.pastelOcean,
);
