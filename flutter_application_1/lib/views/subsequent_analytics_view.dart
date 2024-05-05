import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:flutter_application_1/presenters/presenters.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_application_1/views/herophotoview_routewrapper.dart';

class SubsequentAnalyticsView extends StatelessWidget {
  final BuildContext? context;

  // const SubsequentAnalyticsView({super.key, required this.context});

  // Singleton implementation
  static SubsequentAnalyticsView? _instance;
  factory SubsequentAnalyticsView({Key? key, BuildContext? context}) {
    _instance ??= SubsequentAnalyticsView._(
      key: key,
      context: context,
    );
    return _instance!;
  }
  const SubsequentAnalyticsView._({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    return Center(child: MainPresenter.to.showSa());
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
        SizedBox(height: 5.h),
      ],
    );
  }

  Widget showSaDevChart() {
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
                      MainPresenter.to.img9Bytes.value,
                    ),
                    minScale: 0.77,
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img9',
              child: Image.memory(MainPresenter.to.img9Bytes.value)),
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
        GestureDetector(
          onTap: () {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return Dialog(
                  child: HeroPhotoViewRouteWrapper(
                    imageProvider: MemoryImage(
                      MainPresenter.to.img8Bytes.value,
                    ),
                    minScale: 0.48,
                  ),
                );
              },
            );
          },
          child: Hero(
              tag: 'img8',
              child: Image.memory(MainPresenter.to.img8Bytes.value)),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }

  Widget showError() {
    return Text(
      MainPresenter.to.subsequentAnalyticsErr.value,
      style: const TextTheme().sp5,
    );
  }

  Widget showCircularProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LoadingAnimationWidget.discreteCircle(
          color: ThemeColor.primary.value,
          secondRingColor: ThemeColor.secondary.value,
          thirdRingColor: ThemeColor.tertiary.value,
          size: 20.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text('sub_analyzing'.tr, style: const TextTheme().sp5),
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}
