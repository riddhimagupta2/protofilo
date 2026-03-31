import 'package:get/get.dart';
import 'package:protofilo/data/service/service.dart';
import '../data/model/skill_model.dart';

class SkillsController extends GetxController {
  final skills      = <SkillModel>[].obs;
  final isLoading   = true.obs;
  final errorMessage= ''.obs;

  Map<String, List<SkillModel>> get grouped {
    final Map<String, List<SkillModel>> map = {};
    for (final s in skills) {
      map.putIfAbsent(s.category, () => []).add(s);
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      skills.value       = await SkillsService.fetchAll();
    } catch (e) {
      errorMessage.value = 'Failed to load skills: $e';
    } finally {
      isLoading.value = false;
    }
  }
}