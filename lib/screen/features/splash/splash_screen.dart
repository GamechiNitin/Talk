import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/screen/features/splash/bloc/session_bloc.dart';
import 'package:talk/utils/app_assets.dart';
import 'package:talk/utils/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SessionBloc, SessionState>(
        bloc: SessionBloc()..add(CurrentSessionEvent()),
        listener: (context, state) {
          switch (state) {
            case HomeNavigateState():
              GoRouter.of(context).goNamed(AppRouteEnum.home.name);
              break;
            case LoginNavigateState():
              GoRouter.of(context).goNamed(AppRouteEnum.login.name);
              break;
            case SignUPNavigateState():
              GoRouter.of(context).goNamed(AppRouteEnum.signup.name);
              break;
            case SessionInitial():
              break;
          }
        },
        child: Center(
          child: Image.asset(
            AppAssets.kLogo,
            height: 250,
            width: 250,
          ),
        ),
      ),
    );
  }
}
