import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  // const SearchView({Key? key}) : super(key: key);

  // Singleton implementation
  static SearchView? _instance;
  factory SearchView({Key? key}) {
    _instance ??= SearchView._(key: key);
    return _instance!;
  }
  const SearchView._({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // DateTimeRange? selectedDateRange;
  // final TextEditingController _dateRangeController = TextEditingController();
  double _currentSliderValue = 100;
  double _currentDateValue = 5;
  TextEditingController _textEditingController = TextEditingController();
  bool autocomplete = true;

  // @override
  // void dispose() {
  //   // _dateRangeController.dispose();
  //   super.dispose();
  // }

  static String _displayStringForOption(SymbolAndName option) =>
      '${option.symbol} (${option.name.length >= 40 ? '${option.name.substring(0, 40)}...' : option.name})';

  void _resetForm() {
    setState(() {
      _currentSliderValue = 100;
      _currentDateValue = 5;
      _textEditingController.clear();
    });
  }

  void _submitForm() {
    if (_textEditingController.text != '') {
      PrefsService.to.prefs.setString(
          SharedPreferencesConstant.stockSymbol, _textEditingController.text);
      SharedPreferencesConstant.dateRange = _currentDateValue;
      SharedPreferencesConstant.tolerance = _currentSliderValue;
      MainPresenter.to.searchCount.value++;
      MainPresenter.to.back();
    } else {
      Get.snackbar(
          "Alert!",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error),
          'A Stock should be selected before the submission.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: const TextTheme().sp7,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trend Match Tolerance',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
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
                          '50%',
                          style: const TextTheme().sp3,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp3,
                        ),
                        Text(
                          '150%',
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date Range',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: _currentDateValue,
                          max: 20,
                          min: 2,
                          divisions: 18,
                          label: _currentDateValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentDateValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2 Days',
                          style: const TextTheme().sp3,
                        ),
                        // Text(
                        //   '10 Days',
                        //   style: const TextTheme().sp3,
                        // ),
                        // Text(
                        //   '15 Days',
                        //   style: const TextTheme().sp3,
                        // ),
                        Text(
                          '20 Days',
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
                    return MainPresenter.to.listSymbolAndName;
                  }
                  if (autocomplete) {
                    return MainPresenter.to.listSymbolAndName
                        .where((SymbolAndName option) {
                      return option
                          .toString()
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  } else {
                    return const Iterable<SymbolAndName>.empty();
                  }
                },
                onSelected: (SymbolAndName selection) {
                  autocomplete = false;
                  _textEditingController.text = selection.symbol;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  _textEditingController = textEditingController;
                  focusNode.addListener(() {
                    if (!focusNode.hasFocus) {
                      // Clear the text field when losing focus if no selection was made
                      if (autocomplete) {
                        _textEditingController.text = '';
                      }
                    }
                  });
                  return TextField(
                    onChanged: (String value) {
                      autocomplete = true;
                    },
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: Text(
                      'Reset',
                      style: const TextTheme().sp5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Submit',
                      style: const TextTheme().sp5,
                    ),
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
