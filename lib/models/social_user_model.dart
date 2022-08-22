class UserModel{
  dynamic name ;
  String? email ;
  dynamic phone ;
  dynamic  uId;
  dynamic  image;
  dynamic  cover;
  dynamic  bio;
  bool? isEmailVerified ;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.bio,
    this.isEmailVerified
});

  UserModel.fromJson(Map<String , dynamic>? json){
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String , dynamic> toMap(){
    return {
      'name' : name,
      'email' : email ,
      'phone' : phone ,
      'uId' : uId ,
      'image' : image ,
      'cover' : cover ,
      'bio' : bio ,
      'isEmailVerified' : isEmailVerified
    };
  }
}