import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);
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
  final TextEditingController _stockNameController = TextEditingController();

  @override
  void dispose() {
    _dateRangeController.dispose();
    super.dispose();
  }

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
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _stockNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Stock Name/Number',
                ),
              ),
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
