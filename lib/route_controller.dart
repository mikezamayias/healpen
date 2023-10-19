import 'package:flutter/material.dart';

import 'healpen.dart';
import 'views/auth/auth_view.dart';
import 'views/note/note_view.dart';
import 'views/onboarding/onboarding_view.dart';
import 'wrappers/auth_wrapper.dart';

class RouterController {
//   make it singleton
  static final RouterController _instance = RouterController._internal();

  factory RouterController() => _instance;

  RouterController._internal();

  static const ({String route, Widget widget}) onboardingRoute = (
    route: '/onboarding',
    widget: OnboardingView(),
  );
  static const ({String route, Widget widget}) authWrapperRoute = (
    route: '/auth-wrapper',
    widget: AuthWrapper(),
  );
  static const ({String route, Widget widget}) authViewRoute = (
    route: '/auth-view',
    widget: AuthView(),
  );
  static const ({String route, Widget widget}) noteViewRoute = (
    route: '/note-view',
    widget: NoteView(),
  );
  static const ({String route, Widget widget}) healpen = (
    route: '/healpen',
    widget: Healpen(),
  );

  List<({String route, Widget widget})> routeList = [
    onboardingRoute,
    authWrapperRoute,
    authViewRoute,
    noteViewRoute,
    healpen,
  ];

//   create a method that will return a map of string and widget based on the
//   above routes
  Map<String, Widget Function(BuildContext)> get routes => {
        for (var route in routeList) route.route: (context) => route.widget,
      };
}
