import 'package:get/get.dart';
import 'package:protofilo/data/service/service.dart';
import '../data/model/about_model.dart';

class AboutController extends GetxController {
  final about        = Rxn<AboutModel>();
  final isLoading    = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbout();
  }

  Future<void> fetchAbout() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      about.value        = await AboutService.fetch();
    } catch (e) {
      errorMessage.value = 'Failed to load about: $e';
    } finally {
      isLoading.value = false;
    }
  }
}