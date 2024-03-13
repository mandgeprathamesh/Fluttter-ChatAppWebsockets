import 'package:chat_app_nodejs/models/message_model.dart';
import 'package:get/get.dart';

class chatcontroller extends GetxController {
  var chatmessages = <Message>[].obs;
  var connecteduser = 1.obs;
}
