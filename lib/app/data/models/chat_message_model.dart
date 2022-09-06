class ChatMessage {
  String? id;
  String? user;
  String? chat;
  String? text;
  String? image;
  String? timeStamp;

  ChatMessage(
      {this.id, this.user, this.chat, this.text, this.image, this.timeStamp});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    chat = json['chat'];
    text = json['text'];
    image = json['image'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['chat'] = chat;
    data['text'] = text;
    data['image'] = image;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
