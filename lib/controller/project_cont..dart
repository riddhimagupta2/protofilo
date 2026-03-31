import 'package:get/get.dart';
import 'package:protofilo/data/service/service.dart';
import '../data/model/project_model.dart';

class ProjectsController extends GetxController {
  final projects     = <ProjectModel>[].obs;
  final isLoading    = true.obs;
  final errorMessage = ''.obs;
  final filter       = 'All'.obs;

  List<ProjectModel> get filtered => filter.value == 'All'
      ? projects
      : projects.where((p) => p.techStack.contains(filter.value)).toList();

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      projects.value     = await ProjectsService.fetchAll();
    } catch (e) {
      errorMessage.value = 'Failed to load projects: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String tag) => filter.value = tag;
}