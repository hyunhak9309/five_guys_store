import 'package:fiveguysstore/ui/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// Start of Selection

class ProductRegistrationPage extends HookConsumerWidget {
  const ProductRegistrationPage({super.key});
  static const path = '/product_registration';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productName = useState('');
    final productPrice = useState(0.0);
    final productDescription = useState('');
    final productImage = useState<String?>(null);

    final nameController = useTextEditingController();
    final priceController = useTextEditingController();
    final descriptionController = useTextEditingController();

    //TODO : 이미지 패쓰 가져오면 호출
    void setProductImage(String imageUrl) {
      productImage.value = imageUrl;
    }

    //TODO : 준비가 완료되면(emptㅛ 값이 없으면), 생성 함수 호출
    void registerProduct() {
      final viewModelFC = ref.read(homeViewModelProvider.notifier);
      viewModelFC.addProduct(
        name: productName.value,
        price: productPrice.value,
        description: productDescription.value,
        imageUrl: productImage.value ?? '',
      );
      context.pop();
    }

    useEffect(() {
      nameController.addListener(() {
        productName.value = nameController.text;
      });
      priceController.addListener(() {
        final priceText = priceController.text;
        productPrice.value = double.tryParse(priceText) ?? 0.0;
      });
      descriptionController.addListener(() {
        productDescription.value = descriptionController.text;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
   
          ],
        ),
      ),
    );
  }
}
