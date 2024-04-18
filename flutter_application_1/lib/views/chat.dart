import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/styles/styles.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // To run codes after the UI is built
      MainPresenter.to.thisScrollExtent.value +=
          _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        MainPresenter.to.thisScrollExtent.value,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  void _sendMessage(String message) async {
    MainPresenter.to.messages.add(message);
    MainPresenter.to.isWaitingForReply.value =
        true; // Set the flag to true when the SymbolAndName sends a message

    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    String newsAnalysis = await CloudService().getNewsAnalysis(message);
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.aiResponseTime.value = downloadTime;

    MainPresenter.to.messages.add(newsAnalysis);
    Timer(const Duration(milliseconds: 1000), () {
      MainPresenter.to.thisScrollExtent.value +=
          _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        MainPresenter.to.thisScrollExtent.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    MainPresenter.to.isWaitingForReply.value =
        false; // Set the flag to false after the non-sender replies
  }

  void _handleOptionSelected(String option) async {
    MainPresenter.to.messages.add(option);
    MainPresenter.to.isWaitingForReply.value =
        true; // Set the flag to true when the SymbolAndName sends a message

    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    String newsAnalysis = await CloudService().getNewsAnalysis(option);
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.aiResponseTime.value = downloadTime;

    MainPresenter.to.messages.add(newsAnalysis);
    Timer(const Duration(milliseconds: 500), () {
      MainPresenter.to.thisScrollExtent.value +=
          _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        MainPresenter.to.thisScrollExtent.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    MainPresenter.to.isWaitingForReply.value =
        false; // Set the flag to false after the non-sender replies
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
                    'Are there any recent market news that may affecting the prices of stocks in my watchlist?'),
            child: const Text(
                'Are there any recent market news that may affecting the prices of stocks in my watchlist?'),
          ),
          ElevatedButton(
            onPressed: MainPresenter.to.isWaitingForReply.value
                ? null
                : () => _handleOptionSelected(
                    'What are the major challenges facing the stocks in my watchlist?'),
            child: const Text(
                'What are the major challenges facing the stocks in my watchlist?'),
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
              'Chat with News AI',
              style: const TextTheme().sp7,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Powered by',
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
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: (MainPresenter.to.listingErr.value != ''
                              ? MainPresenter.to.listingErr.value
                              : "Type and select your interest 😊"),
                        ),
                        enabled: !MainPresenter.to.isWaitingForReply
                            .value, // Disable text field when waiting for a reply,
                      );
                    },
                  ),
                  MainPresenter.to.buildListingSourceRichText(),
                ],
              ),
            ),
            SizedBox(height: 50.h)
          ],
        ),
      ),
    );
  }
}
