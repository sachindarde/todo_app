class User {
  String username;
  String name;
  String imageUrl;
  bool emailVerified;

  User({this.username, this.name, this.imageUrl, this.emailVerified});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    emailVerified = json['emailVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['emailVerified'] = this.emailVerified;
    return data;
  }
}