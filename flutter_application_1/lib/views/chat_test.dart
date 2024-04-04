import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);
  //DateTime? start;
  //DateTime? end;
/*class _NewPageState extends State<NewPage>{
   DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2022,11,5), 
    end: DateTime(2022, 12, 24),
  );*/

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  DateTimeRange? selectedDateRange;
  final TextEditingController _dateRangeController = TextEditingController();
  // final TextEditingController _varienceController = TextEditingController();
  // final TextEditingController _stockNameController = TextEditingController();

  @override
  void dispose() {
    _dateRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        /*title: TextField(
          decoration: InputDecoration(
            hintText: 'Search here...',
          ),
        ),*/
      ),
      /*body: Center(
        child: Text(
          'This is a search page!',
          style: TextStyle(fontSize: 20),
        ),
      ),*/
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // BubbleNormalImage(
                //   id: 'id001',
                //   image: _image(),
                //   color: Colors.purpleAccent,
                //   tail: true,
                //   delivered: true,
                // ),
                // BubbleNormalAudio(
                //   color: Color(0xFFE8E8EE),
                //   duration: duration.inSeconds.toDouble(),
                //   position: position.inSeconds.toDouble(),
                //   isPlaying: isPlaying,
                //   isLoading: isLoading,
                //   isPause: isPause,
                //   onSeekChanged: _changeSeek,
                //   onPlayPauseButtonClick: _playAudio,
                //   sent: true,
                // ),
                BubbleNormal(
                  text: 'bubble normal with tail',
                  isSender: false,
                  color: const Color(0xFF1B97F3),
                  tail: true,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                BubbleNormal(
                  text: 'bubble normal with tail',
                  isSender: true,
                  color: const Color(0xFFE8E8EE),
                  tail: true,
                  sent: true,
                ),
                // DateChip(
                //   date: new DateTime(now.year, now.month, now.day - 2),
                // ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          // MessageBar(
          //   onSend: (_) => print(_),
          //   actions: [
          //     InkWell(
          //       child: Icon(
          //         Icons.add,
          //         color: Colors.black,
          //         size: 24,
          //       ),
          //       onTap: () {},
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(left: 8, right: 8),
          //       child: InkWell(
          //         child: Icon(
          //           Icons.camera_alt,
          //           color: Colors.green,
          //           size: 24,
          //         ),
          //         onTap: () {},
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),

      /* Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              child: Text(
                'Date Range Picker',
                //style: textStyle,
              ),
              onPressed: () async {
                final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020, 01),
                    lastDate: DateTime(2100, 12));
                debugPrint(range.toString());
              },
            ),
        ],
      ),*/

      /*Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Text('Date Range Picker',
                style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(start?.toIso8601String() ?? "-"),
                const Text('to'),
                Text(end?.toIso8601String() ?? "-"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await showDateRangePicker(
                      context: context, 
                      firstDate: DateTime(1900), 
                      lastDate: DateTime.now().add(const Duration(days: 356),
                      ),
                      );
                      if(result != null){
                        setState((){
                          start = result.start;
                          end = result.end;
                        });
                      }
                  }, 
                  child: const Text("Date Range Picker"),
                  ),
              ],
              ),
            ),*/
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      //   child: TextFormField(
      //     controller: _dateRangeController,
      //     decoration: const InputDecoration(
      //       labelText: 'Select Date Range',
      //       suffixIcon: Icon(Icons.calendar_today),
      //       border: OutlineInputBorder(),
      //     ),
      //     readOnly: true,
      //     onTap: () async {
      //       final range = await showDateRangePicker(
      //         context: context,
      //         firstDate: DateTime(1990),
      //         lastDate:
      //             DateTime.now(), //restrict user to choose future date
      //       );

      //       if (range != null) {
      //         setState(() {
      //           selectedDateRange = range;
      //           _dateRangeController.text =
      //               '${range.start.day}/${range.start.month}/${range.start.year} - ${range.end.day}/${range.end.month}/${range.end.year}';
      //         });
      //       }
      //     },
      //   ),
      // ),
      // ],
    );
    //   ),
    // );
  }
}
