import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/app_theming_controller.dart';
import '../enums/app_theming.dart';
import '../models/app_theming_model.dart';

final appearanceProvider = StateProvider<Appearance>(
  (ref) => Appearance.system,
);

final currentAppColorProvider = StateProvider<AppColor>(
  (ref) => AppColor.pastelOcean,
);

final appColorControllerProvider =
    StateNotifierProvider<AppColorController, AppColorModel>(
  (ref) => throw UnimplementedError(),
);

final appearanceControllerProvider =
    StateNotifierProvider<AppearanceController, AppearanceModel>(
  (ref) => throw UnimplementedError(),
);
