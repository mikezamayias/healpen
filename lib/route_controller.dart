import 'package:flutter/material.dart' hide PageController;

import 'controllers/page_controller.dart';
import 'models/page_model.dart';
import 'utils/constants.dart';

class RouterController {
//   make it singleton
  static final RouterController _instance = RouterController._internal();

  factory RouterController() => _instance;

  RouterController._internal();

  static ({String route, PageModel pageModel}) onboardingRoute = (
    route: '/onboarding',
    pageModel: PageController().onboarding,
  );
  static ({String route, PageModel pageModel}) authWrapperRoute = (
    route: '/auth-wrapper',
    pageModel: PageController().authWrapper,
  );
  static ({String route, PageModel pageModel}) authViewRoute = (
    route: '/auth-view',
    pageModel: PageController().authView,
  );
  static ({String route, PageModel pageModel}) noteViewRoute = (
    route: '/note-view',
    pageModel: PageController().noteView,
  );
  static ({String route, PageModel pageModel}) healpen = (
    route: '/healpen',
    pageModel: PageController().healpen,
  );

  List<({String route, PageModel pageModel})> routeList = [
    onboardingRoute,
    authWrapperRoute,
    authViewRoute,
    noteViewRoute,
    healpen,
  ];

  //   create a method that will return a map of string and widget based on the
  //   above routes
  Map<String, Widget Function(BuildContext)> get routes => {
        for (var route in routeList)
          route.route: (context) => route.pageModel.widget,
      };

  static ({PageModel pageModel, String route}) getRoute(String routeName) {
    return RouterController().routeList.firstWhere(
          (element) => element.route == routeName,
          orElse: () => RouterController().routeList.first,
        );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name!;
    final builder = PageRouteBuilder(
      settings: settings,
      transitionDuration: emphasizedDuration,
      reverseTransitionDuration: emphasizedDuration,
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return RouterController.getRoute(routeName).pageModel.widget;
      },
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: emphasizedCurve,
          reverseCurve: emphasizedCurve.flipped,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
    return builder;
  }
}
