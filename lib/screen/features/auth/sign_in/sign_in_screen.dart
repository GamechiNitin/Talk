import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/screen/widget/social_widget.dart';
import 'package:talk/utils/app_assets.dart';
import 'package:talk/utils/app_dimens.dart';
import 'package:talk/utils/helper.dart';
import 'package:talk/utils/routes.dart';
import 'bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) => current is AuthActionState,
        buildWhen: (previous, current) => current is! AuthActionState,
        listener: (context, state) {
          if (state is HomeNavigateState) {
            GoRouter.of(context).goNamed(AppRouteEnum.home.name);
          }
          if (state is ErrorAuthState) {
            Helper.toast(context, state.message);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimens.p16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Social Button
                    SocialButtonWidget(
                      label: "Login with Google",
                      assetsPath: AppAssets.kGoogle,
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context).add(LoginEvent());
                      },
                    ),
                  ],
                ),
              ),
              if (state is LoadingAuthState && state.loading) Helper.progress()
            ],
          );
        },
      ),
    );
  }
}
