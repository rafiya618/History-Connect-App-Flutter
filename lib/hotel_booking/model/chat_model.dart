class ChatModel {
  late bool isMe;
  late String message;

  ChatModel({required this.isMe, required this.message});

  ChatModel.fromJson(Map<String, dynamic> json) {
    isMe = json['is_me'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_me'] = isMe;
    data['message'] = message;
    return data;
  }
}
