class Messages {
  String? msg;
  String? read;
  String? told;
  String? fromid;
  String? sent;
  late final Typess type;

  Messages({this.msg, this.read, this.told, required this.type, this.fromid, this.sent});

  Messages.fromJson(Map<String, dynamic> json) {
    if (json["msg"] is String) {
      msg = json["msg"].toString();
    }
    if (json["read"] is String) {
      read = json["read"].toString();
    }
    if (json["told"] is String) {
      told = json["told"].toString();
    }
    if (json["type"] is String) {
      type = json["type"].toString() == Typess.image.name ? Typess.image : Typess.text;
    }
    if (json["fromid"] is String) {
      fromid = json["fromid"].toString();
    }
    if (json["sent"] is String) {
      sent = json["sent"].toString();
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["msg"] = msg.toString();
    data["read"] = read;
    data["told"] = told;

    data["type"] = type.name;

    data["fromid"] = fromid;
    data["sent"] = sent;
    return data;
  }
}

enum Typess { text, image }
