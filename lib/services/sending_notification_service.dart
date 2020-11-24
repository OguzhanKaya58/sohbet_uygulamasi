import 'package:sohbet_uygulamasi/model/user.dart';
import 'package:sohbet_uygulamasi/model/message.dart';
import 'package:http/http.dart' as http;

class SendingNotificationService {
  // ignore: missing_return
  Future<bool> sendNotification(
      MessageModel sendMessages, UserModel sendUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firabaseKey =
        "AAAAPcGt5OM:APA91bFCmsJu6nMYU57RrrwaXTWuASJTYS9Pa-cXevOnQj0OxmnoRdpTbhE9eyHN3JY6MQTlALUd7-sjgcNvZHE6A39bPZPdcs9tBY6AUYcKtMPCwgBVoU9w-bsePKR6CmKRMpHbaQYw";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firabaseKey"
    };
    String json =
        '{ "to" : "$token", "data" : { "message" : "${sendMessages.message}", "title" : "${sendUser.userName}", "profileURL" : "${sendUser.profileUrl}", "sendUserID" : "${sendUser.userID}", "email" : "${sendUser.email}"  } }';
    http.Response response =
        await http.post(endURL, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("İşlem Başarılı");
    } else {
      print("İşlem Başarısız ${response.statusCode}");
      print("json : $json");
    }
  }
}
