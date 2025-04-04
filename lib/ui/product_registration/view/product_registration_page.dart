import 'dart:convert';

import 'package:fiveguysstore/ui/home/view_model/home_view_model.dart';
import 'package:fiveguysstore/ui/product_registration/view/widget/product_image_picker.dart';
import 'package:fiveguysstore/ui/product_registration/view/widget/product_text_field.dart';
import 'package:fiveguysstore/ui/product_registration/view/widget/register_button.dart';
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
                      context.pop();

                      try {
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          final bytes = await pickedFile.readAsBytes();

                          // MIME 타입 추정 (확장자 보고)
                          final extension =
                              pickedFile.path.split('.').last.toLowerCase();
                          String mimeType = 'image/jpeg'; // 기본값

                          if (extension == 'png') {
                            mimeType = 'image/png';
                          } else if (extension == 'webp') {
                            mimeType = 'image/webp';
                          }

                          final base64Image = base64Encode(bytes);
                          productImagePath.value =
                              'data:$mimeType;base64,$base64Image';
                        }
                      } catch (e) {
                        // 예외 처리 추가
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이미지를 불러오는 데 실패했어요.')),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('랜덤 이미지 가져오기'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      // 0~999 사이의 ID를 랜덤으로 생성
                      final randomId =
                          DateTime.now().millisecondsSinceEpoch % 1000;
                      final fixedImageUrl =
                          'https://picsum.photos/id/$randomId/600/400';
                      productImagePath.value = fixedImageUrl;
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
          title: const Text(
            '상품 등록',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProductImagePicker(
                imagePath: productImagePath.value,
                errorText: imageError.value,
                onTap: pickImage,
              ),
              const SizedBox(height: 16),
              ProductTextField(
                controller: nameController,
                label: '상품 이름',
                errorText: nameError.value,
              ),
              const SizedBox(height: 12),
              ProductTextField(
                controller: priceController,
                label: '상품 가격',
                errorText: priceError.value,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ProductTextField(
                controller: descriptionController,
                label: '상품 설명',
                errorText: descriptionError.value,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              RegisterButton(onPressed: registerProduct),
            ],
          ),
        ),
      ),
    );
  }
}
