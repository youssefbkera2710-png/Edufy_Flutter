class Media {
  int? id;
  String? url;
  String? name;
  String? type;
  String? size;

  Media({this.id, this.url, this.name, this.type, this.size});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    name = json['name'];
    type = json['type'];
    size = json['size'];
  }
}