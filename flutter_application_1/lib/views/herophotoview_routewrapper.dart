import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    super.key,
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final double? minScale;
  final double? maxScale;

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: imageProvider,
      backgroundDecoration: backgroundDecoration ??
          BoxDecoration(
            color: Colors.white.withOpacity(0.5),
          ),
      minScale: minScale ?? 0.6,
      maxScale: maxScale ?? 5.0,
      tightMode: true,
    );
  }
}
