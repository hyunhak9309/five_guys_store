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
              child:
                  imagePath != null
                      ? (imagePath!.startsWith('http')
                          ? Image.network(
                            imagePath!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Center(child: Text('이미지 로드 실패')),
                          )
                          : Image.file(
                            File(imagePath!),
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ))
                      : const Center(child: Text('Image 선택')),
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
