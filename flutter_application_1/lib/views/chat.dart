import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../models/listing_adapter.dart';
import '../presenters/main.dart';
import '../services/http_service.dart';
import '../utils/screen_utils.dart';

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
    MainPresenter.to.candledownloadTime.value = downloadTime;
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

  void _sendMessage(String message) {
    setState(() {
      messages.add(message);
      isWaitingForReply =
          true; // Set the flag to true when the SymbolAndName sends a message
    });

    // Simulate non-sender replying with "hi" after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.add("hi");
        isWaitingForReply =
            false; // Set the flag to false after the non-sender replies
      });
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
          onPressed:
              isWaitingForReply ? null : () => _handleOptionSelected('Alice'),
          child: const Text('Alice'),
        ),
        ElevatedButton(
          onPressed:
              isWaitingForReply ? null : () => _handleOptionSelected('Bob'),
          child: const Text('Bob'),
        ),
        ElevatedButton(
          onPressed:
              isWaitingForReply ? null : () => _handleOptionSelected('Charlie'),
          child: const Text('Charlie'),
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
                _sendMessage(selection.symbol);
                _controller.clear();
                debugPrint(
                    'You just selected ${_ChatViewState._displayStringForOption(selection)}');
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
                    hintText: 'Type a name',
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
          SizedBox(height: 100.h)
        ],
      ),
    );
  }
}
