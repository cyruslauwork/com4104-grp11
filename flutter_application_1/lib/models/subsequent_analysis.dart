import 'dart:convert';

import '../presenters/presenters.dart';

class SubsequentAnalysis {
  // Singleton implementation
  static final SubsequentAnalysis _instance = SubsequentAnalysis._();
  factory SubsequentAnalysis() => _instance;
  SubsequentAnalysis._();

  void parseJson(Map<String, dynamic> jsonResponse) {
    // Get the CSV files and image data from the JSON response
    var csvFiles = jsonResponse['csv_files'];
    String img1 = csvFiles['img1'];
    String img2 = csvFiles['img2'];
    String img3 = csvFiles['img3'];
    String img4 = csvFiles['img4'];
    String img5 = csvFiles['img5'];
    String img6 = csvFiles['img6'];
    String img7 = csvFiles['img7'];

    // Convert the base64-encoded image data to bytes
    MainPresenter.to.img1Bytes.value = base64Decode(img1);
    MainPresenter.to.img2Bytes.value = base64Decode(img2);
    MainPresenter.to.img3Bytes.value = base64Decode(img3);
    MainPresenter.to.img4Bytes.value = base64Decode(img4);
    MainPresenter.to.img5Bytes.value = base64Decode(img5);
    MainPresenter.to.img6Bytes.value = base64Decode(img6);
    MainPresenter.to.img7Bytes.value = base64Decode(img7);

    MainPresenter.to.subsequentAnalysis.value = true;
  }
}
