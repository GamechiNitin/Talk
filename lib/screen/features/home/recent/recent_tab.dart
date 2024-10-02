import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/screen/features/chat_details/data/chat_model.dart';
import 'package:talk/core/data/common/recent_response.dart';
import 'package:talk/core/data/common/user_model.dart';
import 'package:talk/screen/widget/dialog_boxx.dart';
import 'package:talk/utils/app_colors.dart';
import 'package:talk/utils/app_dimens.dart';
import 'package:talk/utils/helper.dart';
import 'package:talk/utils/routes.dart';

import 'bloc/recent_bloc.dart';

class RecentTab extends StatefulWidget {
  const RecentTab({super.key});

  @override
  State<RecentTab> createState() => _RecentTabState();
}

class _RecentTabState extends State<RecentTab> {
  String? user = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecentBloc()..add(FetchRecentChatEvent()),
      child: BlocConsumer<RecentBloc, RecentState>(
        listenWhen: (previous, current) => current is RecentActionState,
        buildWhen: (previous, current) => current is! RecentActionState,
        listener: (context, state) {
          if (state is RecentChatErrorState) {
            Helper.toast(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is RecentLoadingState && state.loading) {
            return Helper.progress();
          } else if (state.chatList.isEmpty) {
            return const Center(child: Text("No data"));
          } else {
            return GridView.builder(
              itemCount: state.chatList.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimens.p16,
                crossAxisSpacing: AppDimens.p16,
                mainAxisExtent: 160,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (context, index) {
                if (user != null &&
                    user == state.chatList[index].participants?.last) {
                  UserModel? data = state.chatList[index].receiver;
                  return RecentItemViewWidget(
                    image: data?.photoURL ?? "",
                    title: data?.name ?? "",
                    email: data?.email ?? "",
                    onTap2: () {
                      if (data != null) {
                        DialogBoxx.profileView(context, data);
                      }
                    },
                    onTap: () {
                      RecentChatModel recentChatModel = state.chatList[index];
                      ChatModel chatModel = ChatModel(
                        id: recentChatModel.chatID!,
                        chatID: recentChatModel.chatID,
                        email: data?.email,
                        name: data?.name,
                        photoURL: data?.photoURL,
                      );

                      GoRouter.of(context).pushNamed(
                        AppRouteEnum.chat.name,
                        extra: chatModel,
                      );
                    },
                  );
                } else {
                  UserModel? data = state.chatList[index].sender;
                  return RecentItemViewWidget(
                    image: data?.photoURL ?? "",
                    title: data?.name ?? "",
                    email: data?.email ?? "",
                    onTap2: () {
                      if (data != null) {
                        DialogBoxx.profileView(context, data);
                      }
                    },
                    onTap: () {
                      RecentChatModel recentChatModel = state.chatList[index];
                      ChatModel chatModel = ChatModel(
                        id: recentChatModel.chatID!,
                        chatID: recentChatModel.chatID,
                        email: data?.email,
                        name: data?.name,
                        photoURL: data?.photoURL,
                      );

                      GoRouter.of(context).pushNamed(
                        AppRouteEnum.chat.name,
                        extra: chatModel,
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class RecentItemViewWidget extends StatelessWidget {
  const RecentItemViewWidget({
    super.key,
    required this.image,
    required this.title,
    required this.email,
    required this.onTap,
    required this.onTap2,
  });
  final String image;
  final String title;
  final String email;
  final VoidCallback onTap, onTap2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          top: 16,
          right: 4,
          bottom: 16,
        ),
        decoration: const BoxDecoration(
          // color: Color(0xFFEAEAEA),
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap2,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(300)),
                    child: Image.network(
                      image,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 4,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 0.8,
                          color: AppColors.kWhiteColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.kBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
