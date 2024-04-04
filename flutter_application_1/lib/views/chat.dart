import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_application_1/models/listing_adapter.dart';
import 'package:flutter_application_1/presenters/main.dart';
import 'package:flutter_application_1/services/http_service.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/utils/screen_utils.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  bool isWaitingForReply = false;
  static late List<SymbolAndName> symbolAndNameList;
  final _scrollController = ScrollController();

  // static const List<SymbolAndName> _questionOptions = <SymbolAndName>[
  //   SymbolAndName(symbol: 'Alice', name: 'alice@example.com'),
  //   SymbolAndName(symbol: 'Bob', name: 'bob@example.com'),
  //   SymbolAndName(symbol: 'Charlie', name: 'charlie123@gmail.com'),
  // ];

  @override
  void initState() {
    super.initState();
    initListing();
  }

  void initListing() async {
    symbolAndNameList = await ListingAdapter().listListToSymbolAndName(
        ListingAdapter().csvToListList(getListingCSV()));
  }

  Future<String> getListingCSV() async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time
    final response = await HTTPService().fetchListingCSV();
    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.listingDownloadTime.value = downloadTime;
    if (response.statusCode == 200) {
      // print(response.body);
      // CSV object received, pass the data
      return response.body;
    } else {
      throw ArgumentError('Failed to fetch CSV data: ${response.statusCode}');
    }
  }

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  void _sendMessage(String message) async {
    String newsAnalysis = await CloudService().getNewsAnalysis(message);

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

  void _handleOptionSelected(String option) {
    _sendMessage(option);
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
                return _ChatViewState.symbolAndNameList
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
