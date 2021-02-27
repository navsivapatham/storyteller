class UserModel {
  User user;
  List<User> datas = [];

  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    user = User(parsedJson);
  }
  UserModel.fromJsonList(Map<String, dynamic> parsedJson) {
    List<User> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      User data = User(parsedJson['data'][i]);
      temp.add(data);
    }
    datas = temp;
  }
  User get data => user;
}

class User {
  int id;
  String name;
  String email;
  String password;
  String bio;
  String avatar;
  String follow;
  int photocount;
  int follower;
  int following;
  String createdat;
  String updatedat;

  User(parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    email = parsedJson['email'];
    bio = parsedJson['bio'];
    avatar = parsedJson['avatar'];
    follow = parsedJson['follow'];
    photocount = parsedJson['photo_count'];
    follower = parsedJson['follower'];
    following = parsedJson['following'];
    createdat = parsedJson['created_at'];
    updatedat = parsedJson['updated_at'];
  }
  User.signup(String name, String email, String password) {
    this.name = name;
    this.email = email;
    this.password = password;
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["email"] = email;
    map["password"] = password;
    map["bio"] = bio;
    map["avatar"] = avatar;
    map["follow"] = follow;
    map["follower"] = follow;
    map["following"] = follow;
    map["photo_count"] = follow;

    return map;
  }

  User.edit(String name, String email, String bio, String avatar) {
    this.name = name;
    this.email = email;
    this.bio = bio;
    this.avatar = avatar;
  }

  User.editNoPhoto(String name, String email, String bio) {
    this.name = name;
    this.email = email;
    this.bio = bio;
  }
}
