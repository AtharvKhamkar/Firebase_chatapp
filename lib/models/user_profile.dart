class UserProfile {
  String? uid;
  String? name;
  String? email;
  String? pfpURL;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.pfpURL,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    pfpURL = json['pfpURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['email'] = email;
    data['uid'] = uid;
    return data;
  }
}
