import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/listing_adapter.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';

class SearchView extends StatefulWidget {
  // const SearchView({Key? key}) : super(key: key);

  // Singleton implementation
  static SearchView? _instance;
  factory SearchView({Key? key}) {
    _instance ??= SearchView._(key: key);
    return _instance!;
  }
  const SearchView._({Key? key}) : super(key: key);

  //DateTime? start;
  //DateTime? end;
/*class _NewPageState extends State<NewPage>{
   DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2022,11,5), 
    end: DateTime(2022, 12, 24),
  );*/

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  DateTimeRange? selectedDateRange;
  final TextEditingController _dateRangeController = TextEditingController();
  final TextEditingController _varienceController = TextEditingController();

  @override
  void dispose() {
    _dateRangeController.dispose();
    super.dispose();
  }

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _varienceController,
                maxLength: 3,
                decoration: const InputDecoration(
                  labelText: 'Enter Varience Value(%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Autocomplete<SymbolAndName>(
                displayStringForOption:
                    _SearchViewState._displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<SymbolAndName>.empty();
                  }
                  return MainPresenter.to.symbolAndNameList
                      .where((SymbolAndName option) {
                    return option
                        .toString()
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (SymbolAndName selection) {
                  MainPresenter.to
                      .futureListCandleData(stockSymbol: selection.symbol);
                  MainPresenter.to.searched.value = true;
                  PrefsService.to.prefs.setString(
                      SharedPreferencesConstant.stockSymbol, selection.symbol);
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "Type your interested stock and select ^_^",
                    ),
                  );
                },
              ),

              //       TextField(
              //         controller: _stockNameController,
              //         decoration:  InputDecoration(
              //           border: const OutlineInputBorder(),
              //           labelText: 'Enter Stock Name/Number',
              //                             suffixIcon: IconButton(
              //             icon: const Icon(Icons.search),
              //             onPressed: () {
              //               PrefsService.to.prefs
              // .setString(SharedPreferencesConstant.stockSymbol, _stockNameController.text);
              //             },
              //           ),
              //         ),
              //       ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _dateRangeController,
                decoration: const InputDecoration(
                  labelText: 'Select Date Range',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1990),
                    lastDate:
                        DateTime.now(), //restrict user to choose future date
                  );

                  if (range != null) {
                    setState(() {
                      selectedDateRange = range;
                      _dateRangeController.text =
                          '${range.start.day}/${range.start.month}/${range.start.year} - ${range.end.day}/${range.end.month}/${range.end.year}';
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
