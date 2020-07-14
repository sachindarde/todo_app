class FoldersEntity {
  String slug;
  String title;
  String username;
  String colorCode;
  var createdOn;
  var updatedOn;

  FoldersEntity(
      {this.slug,
      this.title,
      this.username,
      this.colorCode,
      this.createdOn,
      this.updatedOn});

  FoldersEntity.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    title = json['title'];
    username = json['username'];
    colorCode = json['colorCode'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['username'] = this.username;
    data['colorCode'] = this.colorCode;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}
