import 'package:get/get.dart';
import '../data/model/msg_model.dart';
import '../data/service/service.dart';

class ContactController extends GetxController {
  final isSending = false.obs;
  final isSent    = false.obs;
  final error     = ''.obs;

  final nameCtrl    = TextEditingControllerWrapper();
  final emailCtrl   = TextEditingControllerWrapper();
  final messageCtrl = TextEditingControllerWrapper();

  Future<void> sendMessage() async {
    final name    = nameCtrl.text.trim();
    final email   = emailCtrl.text.trim();
    final message = messageCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      error.value = 'All fields are required.';
      return;
    }
    if (!GetUtils.isEmail(email)) {
      error.value = 'Please enter a valid email.';
      return;
    }

    try {
      isSending.value = true;
      error.value     = '';
      await MessagesService.send(MessageModel(
        name: name, email: email, message: message,
      ));
      isSent.value = true;
      nameCtrl.clear();
      emailCtrl.clear();
      messageCtrl.clear();
    } catch (e) {
      error.value = 'Failed to send message. Please try again.';
    } finally {
      isSending.value = false;
    }
  }

  void resetSent() => isSent.value = false;
}

class TextEditingControllerWrapper {
  final _text = ''.obs;
  String get text => _text.value;
  void updateText(String v) => _text.value = v;
  void clear() => _text.value = '';
}