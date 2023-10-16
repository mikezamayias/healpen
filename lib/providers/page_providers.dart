import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/page_controller.dart';
import '../models/page_model.dart';

final StateProvider<PageModel> currentPageProvider = StateProvider<PageModel>(
  (ref) => PageController().pages.first,
);

