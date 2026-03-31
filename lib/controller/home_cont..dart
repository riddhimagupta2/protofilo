import 'package:get/get.dart';
import 'package:protofilo/data/service/service.dart';
import '../data/model/project_model.dart';

class HomeController extends GetxController {

  final isVisible = false.obs;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 200), () => isVisible.value = true);
  }
}