import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class ProductImagePicker extends StatefulWidget {
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
  State<ProductImagePicker> createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  late Widget imageWidget;

  @override
  void didUpdateWidget(covariant ProductImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _buildImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _buildImage();
  }

  void _buildImage() {
    try {
      if (widget.imagePath != null) {
        if (widget.imagePath!.startsWith('data:image')) {
          final base64Str = widget.imagePath!.split(',').last;
          final bytes = base64Decode(base64Str);
          imageWidget = Image.memory(
            bytes,
            key: const ValueKey('memory'),
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          );
        } else if (widget.imagePath!.startsWith('http')) {
          imageWidget = Image.network(
            widget.imagePath!,
            key: const ValueKey('network'),
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => const Center(child: Text('이미지 로드 실패')),
          );
        } else if (File(widget.imagePath!).existsSync()) {
          imageWidget = Image.file(
            File(widget.imagePath!),
            key: const ValueKey('file'),
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          );
        } else {
          imageWidget = const Center(child: Text('지원하지 않는 이미지 형식'));
        }
      } else {
        imageWidget = const Center(child: Text('Image 선택'));
      }
    } catch (e) {
      imageWidget = const Center(child: Text('이미지 처리 중 오류 발생'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onTap,
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
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
