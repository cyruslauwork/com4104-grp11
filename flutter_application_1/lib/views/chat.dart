import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_application_1/models/listing_adapter.dart';
import 'package:flutter_application_1/presenters/main.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/utils/screen_utils.dart';

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
  List<String> messages = [];
  bool isWaitingForReply = false;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  void _sendMessage(String message) async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    String newsAnalysis = await CloudService().getNewsAnalysis(message);

    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.aiResponseTime.value = downloadTime;

    setState(() {
      messages.add(message);
      isWaitingForReply =
          true; // Set the flag to true when the SymbolAndName sends a message

      messages.add(newsAnalysis);

      Timer(const Duration(milliseconds: 500), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
      isWaitingForReply =
          false; // Set the flag to false after the non-sender replies
    });
  }

  void _handleOptionSelected(String option) async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    String newsAnalysis = await CloudService().getNewsAnalysis(option);

    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.aiResponseTime.value = downloadTime;

    setState(() {
      messages.add(option);
      isWaitingForReply =
          true; // Set the flag to true when the SymbolAndName sends a message

      messages.add(newsAnalysis);

      Timer(const Duration(milliseconds: 500), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
      isWaitingForReply =
          false; // Set the flag to false after the non-sender replies
    });
    // _sendMessage(option);
  }

  Widget _buildChatBubble(String message, bool isQuestionObject) {
    return BubbleNormal(
      text: message,
      isSender: isQuestionObject,
      color:
          isQuestionObject ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
      tail: true,
      textStyle: TextStyle(
        fontSize: 20,
        color: isQuestionObject ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildChatOptions() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ElevatedButton(
          onPressed: isWaitingForReply
              ? null
              : () => _handleOptionSelected(
                  'Are there any recent market news that may affecting the prices of stocks in my watchlist?'),
          child: const Text(
              'Are there any recent market news that may affecting the prices of stocks in my watchlist?'),
        ),
        ElevatedButton(
          onPressed: isWaitingForReply
              ? null
              : () => _handleOptionSelected(
                  'What are the major challenges facing the stocks in my watchlist?'),
          child: const Text(
              'What are the major challenges facing the stocks in my watchlist?'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index];
                final isQuestionObject = index % 2 ==
                    0; // Alternate alignment for demonstration purposes
                return _buildChatBubble(message, isQuestionObject);
              },
            ),
          ),
          _buildChatOptions(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Autocomplete<SymbolAndName>(
              displayStringForOption: _ChatViewState._displayStringForOption,
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
                // debugPrint(
                //     'You just selected ${_ChatViewState._displayStringForOption(selection)}');
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                _controller = textEditingController;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: "Type your interested stock and select ^_^",
                  ),
                  enabled:
                      !isWaitingForReply, // Disable text field when waiting for a reply
                  onSubmitted: (value) {
                    // _sendMessage(value);
                    // _controller.clear();
                  },
                );
              },
            ),
          ),
          SizedBox(height: 50.h)
        ],
      ),
    );
  }
}
