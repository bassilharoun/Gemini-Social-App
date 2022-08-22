class LikeModel{
  dynamic senderId ;
  dynamic postId ;
  dynamic isLiked ;



  LikeModel({
    this.senderId,
    this.postId,
    this.isLiked,
});

  LikeModel.fromJson(Map<String , dynamic>? json){
    senderId = json!['senderId'];
    postId = json['postId'];
    isLiked = json['isLiked'];
  }

  Map<String , dynamic> toMap(){
    return {
      'senderId' : senderId,
      'postId' : postId ,
      'isLiked' : isLiked ,
    };
  }
}