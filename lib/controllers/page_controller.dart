import '../models/page_model.dart';

class PageController {
  /// Singleton
  static final PageController _instance = PageController._internal();
  factory PageController() => _instance;
  PageController._internal() {
    // pages = [
    //   // project,
    //   // charts,
    //   dayDashboard,
    //   user,
    //   settings,
    //   about,
    // ];
  }

  // Attributes
  List<PageModel> pages = <PageModel>[];

  // final project = PageModel(
  //   label: 'project',
  //   icon: FontAwesomeIcons.solidFileCode,
  //   widget: const ProjectDashboardView(),
  // );
}
