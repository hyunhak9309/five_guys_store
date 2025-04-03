import 'dart:io';

import 'package:fiveguysstore/ui/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProductRegistrationPage extends HookConsumerWidget {
  const ProductRegistrationPage({super.key});
  static const path = '/product_registration';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productName = useState('');
    final productPrice = useState(0.0);
    final productDescription = useState('');
    final productImagePath = useState<String?>(null);

    final nameController = useTextEditingController();
    final priceController = useTextEditingController();
    final descriptionController = useTextEditingController();

    final nameError = useState<String?>(null);
    final priceError = useState<String?>(null);
    final descriptionError = useState<String?>(null);
    final imageError = useState<String?>(null);

    final picker = ImagePicker();

    Future<void> pickImage() async {
      showModalBottomSheet(
        context: context,
        builder:
            (_) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('갤러리에서 선택'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        productImagePath.value = pickedFile.path;
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('랜덤 이미지 가져오기'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      // Unsplash 랜덤 이미지 URL
                      final randomImageUrl =
                          'https://picsum.photos/600/400?random=${DateTime.now().millisecondsSinceEpoch}';
                      productImagePath.value = randomImageUrl;
                    },
                  ),
                ],
              ),
            ),
      );
    }

    void registerProduct() {
      // 초기화
      nameError.value = null;
      priceError.value = null;
      descriptionError.value = null;
      imageError.value = null;

      bool isValid = true;

      if (productName.value.trim().isEmpty) {
        nameError.value = '상품 이름을 입력해주세요.';
        isValid = false;
      }

      if (productPrice.value <= 0) {
        priceError.value = '0보다 큰 숫자를 입력해주세요.';
        isValid = false;
      }

      if (productDescription.value.trim().isEmpty) {
        descriptionError.value = '상품 설명을 입력해주세요.';
        isValid = false;
      }

      if (productImagePath.value == null) {
        imageError.value = '상품 이미지를 선택해주세요.';
        isValid = false;
      }

      if (!isValid) return;

      final viewModelFC = ref.read(homeViewModelProvider.notifier);
      viewModelFC.addProduct(
        name: productName.value,
        price: productPrice.value,
        description: productDescription.value,
        imageUrl: productImagePath.value ?? '',
      );

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('등록 완료'),
              content: const Text('상품이 성공적으로 등록되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pop();
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
      );
    }

    useEffect(() {
      nameController.addListener(() {
        productName.value = nameController.text;
        if (nameError.value != null && nameController.text.trim().isNotEmpty) {
          nameError.value = null;
        }
      });
      priceController.addListener(() {
        final priceText = priceController.text;
        final parsed = double.tryParse(priceText);
        productPrice.value = parsed ?? 0.0;
        if (priceError.value != null && parsed != null && parsed > 0) {
          priceError.value = null;
        }
      });
      descriptionController.addListener(() {
        productDescription.value = descriptionController.text;
        if (descriptionError.value != null &&
            descriptionController.text.trim().isNotEmpty) {
          descriptionError.value = null;
        }
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('상품 등록')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 빈 공간 터치 시 키보드 닫기
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child:
                        productImagePath.value != null
                            ? (productImagePath.value!.startsWith('http')
                                ? Image.network(
                                  productImagePath.value!,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => const Center(
                                        child: Text('이미지 로드 실패'),
                                      ),
                                )
                                : Image.file(
                                  File(productImagePath.value!),
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ))
                            : const Center(child: Text('Image 선택')),
                  ),
                ),
              ),
              if (imageError.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    imageError.value!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '상품 이름',
                  border: const OutlineInputBorder(),
                  errorText: nameError.value,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '상품 가격',
                  border: const OutlineInputBorder(),
                  errorText: priceError.value,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '상품 설명',
                  border: const OutlineInputBorder(),
                  errorText: descriptionError.value,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: registerProduct,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('등록하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
