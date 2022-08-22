class PostModel{
  dynamic name ;
  String?  uId;
  dynamic  image;
  dynamic  date;
  dynamic  postText;
  dynamic  postImage;
  bool? isAccountVerified ;

  PostModel({
    this.name,
    this.uId,
    this.image,
    this.isAccountVerified,
    this.postText,
    this.postImage,
    this.date
  });

  PostModel.fromJson(Map<String , dynamic>? json){
    name = json!['name'];
    postText = json['postText'];
    postImage = json['postImage'];
    uId = json['uId'];
    image = json['image'];
    date = json['date'];
    isAccountVerified = json['isAccountVerified'];
  }

  Map<String , dynamic> toMap(){
    return {
      'name' : name,
      'postText' : postText ,
      'postImage' : postImage ,
      'uId' : uId ,
      'image' : image ,
      'date' : date ,
      'isAccountVerified' : isAccountVerified
    };
  }
}