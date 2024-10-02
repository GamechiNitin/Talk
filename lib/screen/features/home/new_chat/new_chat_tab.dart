import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/screen/features/chat_details/data/chat_model.dart';
import 'package:talk/core/data/common/user_model.dart';
import 'package:talk/screen/widget/dialog_boxx.dart';
import 'package:talk/screen/widget/image_widget.dart';
import 'package:talk/screen/widget/textfield_widget.dart';
import 'package:talk/utils/app_colors.dart';
import 'package:talk/utils/helper.dart';
import 'package:talk/utils/routes.dart';

import 'bloc/new_chat_bloc.dart';

class NewTab extends StatelessWidget {
  const NewTab({super.key});

  static TextEditingController controller = TextEditingController();
  static FocusNode focusNode = FocusNode();
  static ChatModel? chatModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewChatBloc()..add(FetchUserEvent()),
      child: BlocConsumer<NewChatBloc, NewChatState>(
        listenWhen: (previous, current) => current is NavigateToChat,
        buildWhen: (previous, current) => current is! NavigateToChat,
        listener: (context, state) {
          if (state is NavigateToChat) {
            // chatModel
            GoRouter.of(context).pushNamed(
              AppRouteEnum.chat.name,
              extra: state.chatModel,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormWidget(
                      controller: controller,
                      focusNode: focusNode,
                      label: "Search by email..",
                      prefixIcon: Icons.search,
                      suffixIcon: Icons.close,
                      onSuffixIxonTap: () {
                        controller.clear();
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      itemCount: state.userList.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemBuilder: (context, index) => NewItemViewWidget(
                          image: state.userList[index].photoURL ??
                              "https://picsum.photos/200/300",
                          title: state.userList[index].name,
                          email: state.userList[index].email,
                          onTap2: () {
                            UserModel data = state.userList[index];
                            DialogBoxx.profileView(context, data);
                          },
                          onTap: () {
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
                                            onPressed: () =>
                                                GoRouter.of(context).pop(),
                                          ),
                                        ),

                                        const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            'Start a new chat?',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.kPrimaryColor),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Start Chat Button
                                        ElevatedButton(
                                          onPressed: () {
                                            String client =
                                                state.userList[index].id ?? "";
                                            String sender = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            BlocProvider.of<NewChatBloc>(
                                                    context)
                                                .add(
                                              CreateChatEvent(client, sender,
                                                  state.userList[index]),
                                            );
                                          },
                                          child: const Text('Start Chat'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          //  GoRouter.of(context).pushNamed(
                          //   AppRouteEnum.chat.name,
                          //   extra: state.userList[index],
                          // ),
                          ),
                    ),
                  ),
                ],
              ),
              if (state is LoadingAuthState && state.loading) Helper.progress()
            ],
          );
        },
      ),
    );
  }
}

class NewItemViewWidget extends StatelessWidget {
  const NewItemViewWidget({
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
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          // color: Color(0xFFEAEAEA),
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Hero(
                  tag: email,
                  child: ImageWidget(
                    image: image,
                    height: 50,
                    width: 50,
                    borderRadius: 8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(email),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
