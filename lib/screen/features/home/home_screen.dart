// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/screen/features/home/new_chat/new_chat_tab.dart';
import 'package:talk/screen/features/home/recent/recent_tab.dart';
import 'package:talk/screen/widget/image_widget.dart';
import 'package:talk/utils/app_colors.dart';
import 'package:talk/utils/app_dimens.dart';
import 'package:talk/utils/app_strings.dart';
import 'package:talk/utils/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.kTabColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Hey ${FirebaseAuth.instance.currentUser?.displayName?.split(" ").first ?? "Unknown"},",
              style: const TextStyle(
                color: AppColors.kPrimaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        insetPadding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => GoRouter.of(context).pop(),
                                ),
                              ),

                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Are you sure you want \nSign Out?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Start Chat Button
                              ElevatedButton(
                                style: const ButtonStyle().copyWith(
                                  backgroundColor: const WidgetStatePropertyAll(
                                    AppColors.kSecondaryColor,
                                  ),
                                ),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  GoRouter.of(context).pop();
                                  GoRouter.of(context)
                                      .goNamed(AppRouteEnum.splash.name);
                                },
                                child: const Text(
                                  '  Yes  ',
                                  style: TextStyle(
                                    color: AppColors.kWhiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: ImageWidget(
                  image: FirebaseAuth.instance.currentUser?.photoURL ?? "",
                  borderRadius: 300,
                  height: AppDimens.kIcon,
                  width: AppDimens.kIcon,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize:
                Size(MediaQuery.sizeOf(context).width, kToolbarHeight + 16),
            child: Container(
              height: 47,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.kTabColor,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              child: const TabBar(
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.all(Radius.circular(50)),
                labelStyle: TextStyle(
                  color: AppColors.kPrimaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  color: AppColors.kGreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                indicator: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                tabs: [
                  Tab(text: AppStrings.kRecentTalk),
                  Tab(text: AppStrings.kNewTalk),
                ],
              ),
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: TabBarView(
            children: [
              RecentTab(),
              NewTab(),
            ],
          ),
        ),
      ),
    );
  }
}
