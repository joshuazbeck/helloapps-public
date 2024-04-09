class Session {
  int id;
  String name;
  String colorHex;
  String? socketId;

  Session(this.id, this.name, this.colorHex, this.socketId);

  Session.fromJson(Map<String, dynamic> json)
      : id = json['session_id'] as int,
        name = json['name'] as String,
        colorHex = json['color_hex'] as String,
        socketId = json['socket_id'] as String?;

  Map<String, dynamic> toJson() => {
        'session_id': id,
        'name': name,
        'color_hex': colorHex,
        'socket_id': socketId
      };
}
