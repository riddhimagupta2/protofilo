import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/about_model.dart';
import '../model/msg_model.dart';
import '../model/project_model.dart';
import '../model/skill_model.dart';

final _db = Supabase.instance.client;

class ProjectsService {
  static Future<List<ProjectModel>> fetchAll() async {
    final res = await _db
        .from('projects')
        .select()
        .order('created_at', ascending: false);
    return (res as List).map((e) => ProjectModel.fromJson(e)).toList();
  }

  static Future<List<ProjectModel>> fetchFeatured() async {
    final res = await _db
        .from('projects')
        .select()
        .eq('is_featured', true)
        .order('created_at', ascending: false);
    return (res as List).map((e) => ProjectModel.fromJson(e)).toList();
  }

  static Future<void> insert(ProjectModel project) async {
    await _db.from('projects').insert(project.toJson());
  }

  static Future<void> update(String id, ProjectModel project) async {
    await _db.from('projects').update(project.toJson()).eq('id', id);
  }

  static Future<void> delete(String id) async {
    await _db.from('projects').delete().eq('id', id);
  }
}

class SkillsService {
  static Future<List<SkillModel>> fetchAll() async {
    final res = await _db.from('skills').select().order('category');
    return (res as List).map((e) => SkillModel.fromJson(e)).toList();
  }
}

class AboutService {
  static Future<AboutModel?> fetch() async {
    final res = await _db.from('about').select().limit(1).maybeSingle();
    if (res == null) return null;
    return AboutModel.fromJson(res);
  }
}

class MessagesService {
  static Future<void> send(MessageModel msg) async {
    await _db.from('messages').insert(msg.toJson());
  }
}
