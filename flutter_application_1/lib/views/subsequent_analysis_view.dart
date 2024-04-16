import 'package:flutter/material.dart';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/views/herophotoview_routewrapper.dart';

class SubsequentAnalysisView extends StatelessWidget {
  final BuildContext? context;

  // const SubsequentAnalysisView({super.key, required this.c});

  // Singleton implementation
  static SubsequentAnalysisView? _instance;
  factory SubsequentAnalysisView({Key? key, BuildContext? context}) {
    _instance ??= SubsequentAnalysisView._(key: key, context: context);
    return _instance!;
  }
  const SubsequentAnalysisView._({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    return MainPresenter.to.showSa();
  }

  Widget showSaChart() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img1Bytes.value,
                    ),
                    minScale: 0.48,
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img1',
              child: Image.memory(MainPresenter.to.img1Bytes.value)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img2Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img2',
              child: Image.memory(MainPresenter.to.img2Bytes.value)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img3Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img3',
              child: Image.memory(MainPresenter.to.img3Bytes.value)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img4Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img4',
              child: Image.memory(MainPresenter.to.img4Bytes.value)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img5Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img5',
              child: Image.memory(MainPresenter.to.img5Bytes.value)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img6Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img6',
              child: Image.memory(MainPresenter.to.img6Bytes.value)),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img7Bytes.value,
                    ),
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img7',
              child: Image.memory(MainPresenter.to.img7Bytes.value)),
        ),
      ],
    );
  }

  Widget showError() {
    return Text(
      MainPresenter.to.subsequentAnalysisErr.value,
      style: const TextTheme().sp5,
    );
  }

  Widget showCircularProgressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40.w,
          height: 40.h,
          child: const CircularProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text('Awaiting subsequent trend analysis result...',
              style: const TextTheme().sp5),
        ),
      ],
    );
  }
}
