import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class CImageWidget extends StatefulWidget {
  const CImageWidget({super.key, required this.image});
  final String image;

  @override
  State<CImageWidget> createState() => _CImageWidgetState();
}

class _CImageWidgetState extends State<CImageWidget> {
  late final Widget _cachedImage;

  @override
  void initState() {
    super.initState();
    _cachedImage = _buildImage(widget.image);
  }

  Widget _buildImage(String image) {
    try {
      if (image.startsWith('data:image')) {
        return Image.memory(
          base64Decode(image.split(',').last),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else if (image.startsWith('http')) {
        return Image.network(
          image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else if (image.startsWith('content://')) {
        return Image.file(
          File.fromUri(Uri.parse(image)),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        final file = File(Uri.parse(image).toFilePath());
        if (file.existsSync()) {
          return Image.file(
            file,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } else {
          return Image.memory(
            base64Decode(image.split(',').last),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
      }
    } catch (_) {
      return const Icon(Icons.broken_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _cachedImage;
  }
}
