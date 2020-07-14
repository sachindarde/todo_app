class FilesEnitity {
  String slug;
  String title;
  String username;
  String folderSlug;
  String contentbody;
  String folderTitle;
  bool isImportant;
  var createdOn;
  var updatedOn;

  FilesEnitity(
      {this.slug,
      this.title,
      this.username,
      this.folderSlug,
      this.contentbody,
      this.folderTitle,
      this.isImportant,
      this.createdOn,
      this.updatedOn});

  FilesEnitity.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    title = json['title'];
    username = json['username'];
    folderSlug = json['folderSlug'];
    contentbody = json['contentbody'];
    folderTitle = json['folderTitle'];
    isImportant = json['isImportant'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['username'] = this.username;
    data['folderSlug'] = this.folderSlug;
    data['contentbody'] = this.contentbody;
    data['folderTitle'] = this.folderTitle;
    data['isImportant'] = this.isImportant;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}
