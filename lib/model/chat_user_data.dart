class chat_user_data {
  late String image;
  late String about;
  late String name;
  late String createdAt;
 late bool isOnline;
  late String lastActive;
  late String id;
  late String pushToken;
  late String email;

  chat_user_data(
      {required this.image,
      required this.about,
      required this.name,
      required this.createdAt,
      required this.isOnline,
      required this.lastActive,
     required this.id,
     required this.pushToken,
     required this.email});

  chat_user_data.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about']?? '';
    name = json['name']?? '';
    createdAt = json['created_at']?? '';
    isOnline = json['is_online']?? '';
    lastActive = json['last_active']?? '';
    id = json['id']?? '';
    pushToken = json['push_token']?? '';
    email = json['email']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image']  = this.image;
    data['about'] = this.about;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['is_online'] = this.isOnline;
    data['last_active'] = this.lastActive;
    data['id'] = this.id;
    data['push_token'] = this.pushToken;
    data['email'] = this.email;
    return data;
  }
}