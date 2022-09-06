class Chats {
  String? id;
  List<String>? users;
  String? userA;
  String? userB;
  String? lastMessage;
  String? lastMessageTime;
  String? lastMessageSentBy;
  List<String>? lastMessageSeenBy;

  Chats(
      {this.id,
      this.users,
      this.userA,
      this.userB,
      this.lastMessage,
      this.lastMessageTime,
      this.lastMessageSentBy,
      this.lastMessageSeenBy});

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    users = json['users'].cast<String>();
    userA = json['userA'];
    userB = json['userB'];
    lastMessage = json['lastMessage'];
    lastMessageTime = json['lastMessageTime'];
    lastMessageSentBy = json['lastMessageSentBy'];
    lastMessageSeenBy = json['lastMessageSeenBy'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['users'] = users;
    data['userA'] = userA;
    data['userB'] = userB;
    data['lastMessage'] = lastMessage;
    data['lastMessageTime'] = lastMessageTime;
    data['lastMessageSentBy'] = lastMessageSentBy;
    data['lastMessageSeenBy'] = lastMessageSeenBy;
    return data;
  }
}
