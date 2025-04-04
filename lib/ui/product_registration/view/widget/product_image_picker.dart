import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class ProductImagePicker extends StatelessWidget {
  final String? imagePath;
  final String? errorText;
  final VoidCallback onTap;

  const ProductImagePicker({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imagePath != null) {
      if (imagePath!.startsWith('data:image')) {
        // base64 이미지 처리
        try {
          final base64Str = imagePath!.split(',').last;
          final bytes = base64Decode(base64Str);
          imageWidget = Image.memory(
            bytes,
            key: ValueKey(imagePath),
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          );
        } catch (e) {
          imageWidget = const Center(child: Text('이미지 디코딩 실패'));
        }
      } else if (imagePath!.startsWith('http')) {
        // 네트워크 이미지
        imageWidget = Image.network(
          imagePath!,
          key: ValueKey(imagePath),
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(child: Text('이미지 로드 실패')),
        );
      } else if (File(imagePath!).existsSync()) {
        // 로컬 파일이 실제 존재하는 경우만
        imageWidget = Image.file(
          File(imagePath!),
          key: ValueKey(imagePath),
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        );
      } else {
        // 포맷 알 수 없음 or 파일 없음
        imageWidget = const Center(child: Text('지원하지 않는 이미지 형식'));
      }
    } else {
      imageWidget = const Center(child: Text('Image 선택'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey[300],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: imageWidget,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(errorText!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
