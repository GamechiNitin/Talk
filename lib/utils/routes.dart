import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/screen/features/chat_details/data/chat_model.dart';
import 'package:talk/screen/features/chat_details/ui/chat_screen.dart';
import 'package:talk/screen/features/auth/sign_in/sign_in_screen.dart';
import 'package:talk/screen/features/home/home_screen.dart';
import 'package:talk/screen/features/splash/splash_screen.dart';

enum AppRouteEnum {
  splash,
  login,
  signup,
  home,
  chat,
}

@immutable
abstract class AppRoutes {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteEnum.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/${AppRouteEnum.login.name}',
        name: AppRouteEnum.login.name,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/${AppRouteEnum.chat.name}',
        name: AppRouteEnum.chat.name,
        builder: (context, state) => ChatScreen(
          data: state.extra as ChatModel,
        ),
      ),
      GoRoute(
        path: '/${AppRouteEnum.home.name}',
        name: AppRouteEnum.home.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, animation2, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.5, 0), // Left TO Right
                  end: Offset.zero,
                  // begin: const Offset(-1.0, 0.0),
                  // end: Offset.zero,
                ).chain(
                  CurveTween(curve: Curves.easeIn),
                ),
              ),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}
