import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';
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
  double _currentSliderValue =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.tolerance) ?? 100)
          .toDouble();
  double _currentDateValue =
      PrefsService.to.prefs.getDouble(SharedPreferencesConstant.dateRange) ?? 5;
  TextEditingController _textEditingController = TextEditingController();
  bool _autocomplete = true;
  List<SymbolAndName> listSymbolAndName = MainPresenter.to.listSymbolAndName;

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
    bool hasText = _textEditingController.text != '' ? true : false;
    final text = _textEditingController.text.toUpperCase();
    if (hasText) {
      bool textMatchesSymbol = listSymbolAndName
          .any((SymbolAndName symbolAndName) => symbolAndName.symbol == text);
      if (textMatchesSymbol) {
        PrefsService.to.prefs.setString(
            SharedPreferencesConstant.stockSymbol, _textEditingController.text);
        PrefsService.to.prefs
            .setDouble(SharedPreferencesConstant.dateRange, _currentDateValue);
        PrefsService.to.prefs.setInt(
            SharedPreferencesConstant.tolerance, _currentSliderValue.toInt());
        MainPresenter.to.searchCount.value++;
        MainPresenter.to.back();
      } else {
        Iterable<SymbolAndName> textMatchesName = MainPresenter
            .to.listSymbolAndName
            .where((SymbolAndName symbolAndName) =>
                symbolAndName.name.toUpperCase().contains(text));
        if (textMatchesName.length == 1) {
          PrefsService.to.prefs.setString(SharedPreferencesConstant.stockSymbol,
              textMatchesName.first.symbol);
          PrefsService.to.prefs.setDouble(
              SharedPreferencesConstant.dateRange, _currentDateValue);
          PrefsService.to.prefs.setInt(
              SharedPreferencesConstant.tolerance, _currentSliderValue.toInt());
          MainPresenter.to.searchCount.value++;
          MainPresenter.to.back();
        } else if (textMatchesName.length > 1) {
          Get.snackbar(
              "Alert!",
              colorText: AppColor.whiteColor,
              backgroundColor: AppColor.errorColor,
              icon: const Icon(Icons.error),
              "Too many matches. It is recommended to select the financial instrument from the drop-down list.");
        } else {
          Get.snackbar(
              "Alert!",
              colorText: AppColor.whiteColor,
              backgroundColor: AppColor.errorColor,
              icon: const Icon(Icons.error),
              "No match found. It is recommended to select the financial instrument from the drop-down list.");
        }
      }
    } else {
      Get.snackbar(
          "Alert!",
          colorText: AppColor.whiteColor,
          backgroundColor: AppColor.errorColor,
          icon: const Icon(Icons.error),
          'A financial instrument should be selected before the submission.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search 🔍',
          style: const TextTheme().sp7,
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trend Match Tolerance',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
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
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '50%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '100%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '150%',
                          style: const TextTheme().sp4,
                        ),
                        Text(
                          '200 %',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date Range',
                      style: const TextTheme().sp5.primaryTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
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
                          style: const TextTheme().sp4,
                        ),
                        // Text(
                        //   '10 Days',
                        //   style: const TextTheme().sp4,
                        // ),
                        // Text(
                        //   '15 Days',
                        //   style: const TextTheme().sp4,
                        // ),
                        Text(
                          '20 Days',
                          style: const TextTheme().sp4,
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Autocomplete<SymbolAndName>(
                    displayStringForOption:
                        _SearchViewState._displayStringForOption,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return listSymbolAndName;
                      }
                      if (_autocomplete) {
                        return listSymbolAndName
                            .where((SymbolAndName symbolAndName) {
                          return symbolAndName
                              .toString()
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      } else {
                        return const Iterable<SymbolAndName>.empty();
                      }
                    },
                    onSelected: (SymbolAndName selection) {
                      _autocomplete = false;
                      _textEditingController.text = selection.symbol;
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _textEditingController = textEditingController;
                      // focusNode.addListener(() {
                      //   if (!focusNode.hasFocus) {
                      //     // Clear the text field when losing focus if no selection was made
                      //     if (_autocomplete) {
                      //       _textEditingController.text = '';
                      //     }
                      //   }
                      // });
                      return TextField(
                        onChanged: (String value) {
                          _autocomplete = true;
                        },
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Type what you're interested in 😊",
                        ),
                      );
                    },
                  ),
                  buildRichTextWithImage(),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
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
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.w),
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

  Widget buildRichTextWithImage() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Image.asset(
          'images/nasdaq.png',
          height: 7.h, // Adjust the height as needed
        ),
      ),
    );
    final imageSpan2 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Image.asset(
          'images/nyse.png',
          height: 7.h, // Adjust the height as needed
        ),
      ),
    );
    final imageSpan3 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Image.asset(
            'images/amex.png',
            height: 13.h, // Adjust the height as needed
          ),
        ),
      ),
    );

    return RichText(
      text: TextSpan(
        text: 'Latest listings on',
        children: [imageSpan, imageSpan2, imageSpan3],
        style: const TextTheme().sp4.greyColor,
      ),
    );
  }
}
