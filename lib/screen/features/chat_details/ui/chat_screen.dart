// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/screen/features/chat_details/bloc/chat_bloc.dart';
import 'package:talk/screen/features/chat_details/data/chat_model.dart';
import 'package:talk/screen/widget/chat_bubble_widget.dart';
import 'package:talk/screen/widget/image_widget.dart';
import 'package:talk/screen/widget/textfield_widget.dart';
import 'package:talk/utils/app_colors.dart';
import 'package:talk/utils/app_dimens.dart';
import 'package:talk/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.data});
  final ChatModel data;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  ValueNotifier<File?> file = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(FetchMessages(widget.data.chatID!)),
      child: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) => current is ChatStateActionState,
        buildWhen: (previous, current) => current is! ChatStateActionState,
        listener: (context, state) {
          if (state is LoadingChatState) {
            valueNotifier.value = state.loading;
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 200),
              child: Container(
                padding: const EdgeInsets.only(
                  left: AppDimens.p20,
                  right: AppDimens.p10,
                  top: AppDimens.p20,
                ),
                decoration: BoxDecoration(gradient: AppGradient.linearGradient),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => GoRouter.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back,
                              size: AppDimens.kIcon,
                              color: AppColors.kWhiteColor,
                            ),
                          ),
                          Text(
                            widget.data.name ?? "",
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.kBlackMediumColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.kWhiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.mail,
                                  size: 14,
                                  color: AppColors.kPrimaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.data.email ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.kBlueTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: widget.data.email ?? "",
                      child: ImageWidget(
                        image: "${widget.data.photoURL}",
                        borderRadius: 300,
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(gradient: AppGradient.linearGradient),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  border: Border.all(color: AppColors.kWhiteColor, width: 0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimens.kSheetBorderRadius),
                    topRight: Radius.circular(AppDimens.kSheetBorderRadius),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            controller: ScrollController(),
                            itemCount: state.chatList.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                              bottom: 100,
                            ),
                            itemBuilder: (context, index) => ChatBubbleWidget(
                              currentUser: state.chatList[index].senderId ==
                                  FirebaseAuth.instance.currentUser?.uid,
                              name: state.chatList[index].name ?? "NA",
                              message: state.chatList[index].message ?? "",
                              image: state.chatList[index].imageUrl ?? "",
                              type: state.chatList[index].type ?? "",
                              time: state.chatList[index].timestamp
                                  ?.toDate()
                                  .chatTimestamp()
                                  .toString(),
                              onTap: () {
                                String? url = state.chatList[index].imageUrl;
                                if (url != null) {
                                  launchUrl(Uri.parse(url));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: valueNotifier,
                      builder: (context, value, child) {
                        if (value) {
                          return Helper.progress();
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              child: TextFormWidget(
                contentPadding: const EdgeInsets.only(left: 16),
                controller: controller,
                focusNode: focusNode,
                label: "Send Message",
                // suffixIcon: Icons.send,
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf', 'doc'],
                        );

                        if (result != null) {
                          File rawFile = File(result.files.single.path!);
                          int fileSizeInBytes = await rawFile.length();

                          double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                          if (fileSizeInMB <= 5) {
                            file.value = rawFile;
                          } else {
                            Helper.toast(context, "File size exceeds 5 MB");
                          }
                        } else {
                          Helper.toast(context, "Failed to pick");
                        }
                      },
                      icon: Icon(
                        Icons.attachment,
                        color: file.value != null
                            ? AppColors.kPrimaryColor
                            : AppColors.kBlackColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<ChatBloc>(context).add(
                          SendMessage(
                            chatId: widget.data.chatID!,
                            senderId:
                                FirebaseAuth.instance.currentUser?.uid ?? "",
                            message: controller.text.trim(),
                            file: file.value,
                          ),
                        );
                        controller.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.kBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
