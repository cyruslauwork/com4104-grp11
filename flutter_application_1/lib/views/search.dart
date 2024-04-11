import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/styles/styles.dart';

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
  double _currentSliderValue = 100;

  @override
  void dispose() {
    _dateRangeController.dispose();
    super.dispose();
  }

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  void _resetSlider() {
    setState(() {
      _currentSliderValue = 100;
    });
  }

  void _submitForm() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  children: [
                    Text(
                      'Trend Match Tolerance %',
                      style: const TextTheme().sp7,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentSliderValue,
                          max: 200,
                          min: 5,
                          divisions: 39,
                          label: '${_currentSliderValue.round().toString()}%',
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: const TextTheme().sp3,
                        ),
                        Text(
                          '200 %',
                          style: const TextTheme().sp3,
                        ),
                      ],
                    ),
                  ],
                )),
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
                      border: OutlineInputBorder(),
                      labelText: "Type your interested stock and select ^_^",
                    ),
                  );
                },
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _resetSlider,
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
