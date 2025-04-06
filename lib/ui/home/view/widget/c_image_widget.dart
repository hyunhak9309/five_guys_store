import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class CImageWidget extends StatelessWidget {
  const CImageWidget({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
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
      try {
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
          // Fallback: base64 시도
          return Image.memory(
            base64Decode(image.split(',').last),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
      } catch (e) {
        // fallback 처리.
        try {
          return Image.memory(
            base64Decode(image.split(',').last),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        } catch (_) {
          return const Icon(Icons.broken_image);
        }
      }
    }
  }
}