import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:market_ai/models/models.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/services/services.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/styles/styles.dart';

class ChatView extends StatefulWidget {
  // const ChatView({Key? key}) : super(key: key);

// Singleton implementation
  static ChatView? _instance;
  factory ChatView({Key? key}) {
    _instance ??= ChatView._(key: key);
    return _instance!;
  }
  const ChatView._({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool isScrollControllerListenerAdded = false;
  double bottomSizedBoxH = 3.h;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // To run codes after the UI is built
      if (!MainPresenter.to.firstQuestion.value &&
          MainPresenter.to.messages.length > 3) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 20.h,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  void _sendMessage(String message) async {
    MainPresenter.to.messages.add(message);
    PrefsService.to.prefs.setStringList(
        SharedPreferencesConstant.messages, MainPresenter.to.messages);

    MainPresenter.to.isWaitingForReplyNotifier.value =
        true; // Set the flag to true when the SymbolAndName sends a message
    if (MainPresenter.to.firstQuestion.value) {
      MainPresenter.to.firstQuestion.value = false;
      if (MainPresenter.to.messages.length > 2) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 20.h,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 20.h,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    if (!MainPresenter.to.isEnNotifier.value) {
      message += ' (一定要以繁體中文回答)';
    }
    String newsAnalytics =
        await CloudService().getNewsAnalytics(symbolAndName: message);
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.aiResponseTime.value = downloadTime;

    MainPresenter.to.messages.add(newsAnalytics);
    PrefsService.to.prefs.setStringList(
        SharedPreferencesConstant.messages, MainPresenter.to.messages);
    if (MainPresenter.to.messages.length > 2) {
      Timer(const Duration(milliseconds: 500), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 20.h,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
    MainPresenter.to.isWaitingForReplyNotifier.value =
        false; // Set the flag to false after the non-sender replies
  }

  void _handleOptionSelected(String option) async {
    List<String> watchlist = MainPresenter.to.watchlist;
    if (watchlist.isNotEmpty) {
      MainPresenter.to.messages.add(option);
      PrefsService.to.prefs.setStringList(
          SharedPreferencesConstant.messages, MainPresenter.to.messages);

      if (option == Question.getQuestionText(Question.affecting)) {
        option = 'question1_trimmed'.tr;
      } else if (option == Question.getQuestionText(Question.challenges)) {
        option = 'question2_trimmed'.tr;
      }

      MainPresenter.to.isWaitingForReplyNotifier.value =
          true; // Set the flag to true when the SymbolAndName sends a message
      if (MainPresenter.to.firstQuestion.value) {
        MainPresenter.to.firstQuestion.value = false;
        if (MainPresenter.to.messages.length > 2) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 20.h,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 20.h,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      DateTime downloadStartTime =
          DateTime.now(); // Record the download start time
      String newsAnalytics = await CloudService()
          .getNewsAnalytics(symbols: watchlist.join(' '), question: option);
      DateTime downloadEndTime = DateTime.now(); // Record the download end time
      // Calculate the time difference
      Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
      int downloadTime = downloadDuration.inMilliseconds;
      MainPresenter.to.aiResponseTime.value = downloadTime;

      MainPresenter.to.messages.add(newsAnalytics);
      PrefsService.to.prefs.setStringList(
          SharedPreferencesConstant.messages, MainPresenter.to.messages);
      if (MainPresenter.to.messages.length > 2) {
        Timer(const Duration(milliseconds: 500), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 20.h,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
      MainPresenter.to.isWaitingForReplyNotifier.value =
          false; // Set the flag to false after the non-sender replies
    } else {
      Get.snackbar(
          'notice'.tr,
          colorText: AppColor.whiteColor,
          backgroundColor: AppColor.errorColor,
          icon: const Icon(Icons.error),
          'watchlistEmpty'.tr);
    }
  }

  Widget _buildChatBubble(String message, bool isQuestionObject) {
    return BubbleNormal(
      text: message,
      isSender: isQuestionObject,
      color:
          isQuestionObject ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
      tail: true,
      textStyle: TextStyle(
        fontSize: 5.sp,
        color: isQuestionObject ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildChatOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: MainPresenter.to.isWaitingForReply.value
                ? null
                : () => _handleOptionSelected(
                    Question.getQuestionText(Question.affecting)),
            child: Text(Question.getQuestionText(Question.affecting)),
          ),
          ElevatedButton(
            onPressed: MainPresenter.to.isWaitingForReply.value
                ? null
                : () => _handleOptionSelected(
                    Question.getQuestionText(Question.challenges)),
            child: Text(Question.getQuestionText(Question.challenges)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'news_ai_title'.tr,
              style: const TextTheme().sp7,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'power_by'.tr,
                    style: const TextTheme().sp4.greyColor,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColor.imageDefaultBgColor,
                    ),
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: Offset(0.0, 1.h),
                          child: Image.asset(
                            'images/google.png',
                            height: 6.h, // Adjust the height as needed
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Image.asset(
                            'images/gemini.png',
                            height: 6.h, // Adjust the height as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.h), // Thickness of the progress bar
          child: Obx(
            () => Visibility(
              visible: MainPresenter.to.isWaitingForReply
                  .value, // Show only when isLoading is true
              child: LinearProgressIndicator(
                backgroundColor: ThemeColor.secondary.value, // Background color
                valueColor: AlwaysStoppedAnimation<Color>(
                    ThemeColor.tertiary.value), // Progress color
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: MainPresenter.to.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = MainPresenter.to.messages[index];
                  final isQuestionObject = index % 2 ==
                      1; // Alternate alignment for demonstration purposes
                  return _buildChatBubble(message, isQuestionObject);
                },
              ),
            ),
            _buildChatOptions(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Autocomplete<SymbolAndName>(
                    displayStringForOption:
                        _ChatViewState._displayStringForOption,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<SymbolAndName>.empty();
                      }
                      return MainPresenter.to.listSymbolAndName
                          .where((SymbolAndName option) {
                        return option
                            .toString()
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (SymbolAndName selection) {
                      _sendMessage('${selection.symbol} ${selection.name}');
                      _controller.clear();
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _controller = textEditingController;
                      focusNode.addListener(() {
                        if (focusNode.hasFocus) {
                          setState(() {
                            bottomSizedBoxH = 40.h;
                          });
                        } else {
                          setState(() {
                            bottomSizedBoxH = 3.h;
                          });
                        }
                      });
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: (MainPresenter.to.listingErr.value != ''
                              ? MainPresenter.to.listingErr.value
                              : 'input_placeholder2'.tr),
                        ),
                        enabled: !MainPresenter.to.isWaitingForReply
                            .value, // Disable text field when waiting for a reply,
                      );
                    },
                  ),
                  Obx(() => MainPresenter.to.buildListingSourceRichText()),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 15.h,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.greyColor.withOpacity(0.5)),
                      child: IconButton(
                        onPressed: () =>
                            (MainPresenter.to.isWaitingForReply.value
                                ? null
                                : MainPresenter.to.clearMsg()),
                        icon: const Icon(
                          Icons.clean_hands_outlined,
                        ),
                        color: AppColor.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: bottomSizedBoxH)
          ],
        ),
      ),
    );
  }
}
