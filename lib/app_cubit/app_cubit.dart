import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/models/comment_model.dart';
import 'package:gemini_social_app/models/message_model.dart';
import 'package:gemini_social_app/models/post_model.dart';
import 'package:gemini_social_app/models/social_user_model.dart';
import 'package:gemini_social_app/modules/chats/chats_screen.dart';
import 'package:gemini_social_app/modules/feeds/feeds_screen.dart';
import 'package:gemini_social_app/modules/search/search_screen.dart';
import 'package:gemini_social_app/modules/settings/settings_screen.dart';
import 'package:gemini_social_app/modules/users/users_screen.dart';
import 'package:gemini_social_app/shared/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates>{
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel ;

  void getUserData(){
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(uId)
        .get()
        .then((value) {
        print(value.data());
        userModel = UserModel.fromJson(value.data());
        emit(SocialGetUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
}

  int currentIndex = 0 ;

  List<Widget> screens = [
    FeedsScreen(),
    SearchScreen(),
    UsersScreen(),
    SettingsScreen(),
  ] ;

  List<String> titles = [
    'Gemini' ,
    'Search' ,
    'Location' ,
    'Profile'
  ];

  void changeBottomNav(int index){
    currentIndex = index ;
    if(currentIndex == 0){
      getPosts();
    }
    if(currentIndex == 3){
      getSomeonePosts(userModel!.uId);
    }
    if(currentIndex == 1){
      getUsers();
    }
    emit(SocialChangeBottomNavBarState());
  }

  dynamic profileImage ;
  var picker = ImagePicker() ;

  Future<void> getProfileImage()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      //emit(SocialProfileImagePickedSuccessState());
    }else{
      print('No image selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  dynamic coverImage ;
  Future<void> getCoverImage()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      coverImage = File(pickedFile.path);
      uploadCoverImage();
      //emit(SocialCoverImagePickedSuccessState());
    }else{
      print('No image selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }


  void uploadProfileImage(){
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
          value.ref.getDownloadURL().then((value) {
            print(value);
            updateUser(name: userModel!.name,
                phone: userModel!.phone,
                bio: userModel!.bio ,
              image: value
            );
          }).catchError((error){
            emit(SocialUploadProfileImageErrorState());
          });
    }).catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
  }


  void uploadCoverImage(){
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: userModel!.name,
            phone: userModel!.phone,
            bio: userModel!.bio ,
            cover: value
        );
      }).catchError((error){
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name ,
    required String phone ,
    required String bio ,
    String? image ,
    String? cover

}){
    emit(SocialUserUpdateLoadingState());
    UserModel model = UserModel(
        name: name ,
        phone: phone ,
        image: image??userModel!.image ,
        email: userModel!.email,
        cover: cover??userModel!.cover ,
        uId: userModel!.uId,
        bio: bio ,
        isEmailVerified: false
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
          getUserData();
    })
        .catchError((error){
          emit(SocialUserUpdateErrorState());
    });
  }

  dynamic postImage ;
  
  void removePostImage(){
    postImage = null ;
    emit(SocialRemovePostImageState());
  }
  
  Future<void> getPostImage()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    }else{
      print('No image selected');
      emit(SocialPostImagePickedErrorState());
    }
  }


  void uploadPostImage({
    required String date,
    required String postText,
    bool isAccountVerified = false
}){
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(date: date, postText: postText,postImage: value);
      }).catchError((error){
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String date,
    dynamic postImage,
    required String postText,
  }){
    emit(SocialUserUpdateLoadingState());
    PostModel model = PostModel(
        name: userModel!.name ,
        uId: userModel!.uId,
        image: userModel!.image,
        date: date,
        postImage: postImage??'',
        postText: postText
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          emit(SocialCreatePostSuccessState());
    })
        .catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [] ;
  List<String> postsId = [] ;
  List<int> likes = [] ;
  List<int> commentsSum = [] ;
  List<bool> listOfIsLiked = [] ;

  void getPosts(){
    posts = [] ;
    likes = [] ;
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            element.reference
                .collection('likes').get()
                .then((value) {
                  likes.add(value.docs.length);
                  postsId.add(element.id);
                  posts.add(PostModel.fromJson(element.data()));
                  // Check Like Post !!
                  // value.docs.forEach((element) {
                  //   if (element.id == userModel!.uId){
                  //     postLikedList.add(true) ;
                  //   }
                  //   postLikedList.add(false) ;
                  // });
                  // print(postLikedList);
                  // print('--------------------------');
                  listOfIsLiked.add(isLiked(element.id));

                  emit(SocialGetPostsSuccessState());

            })
                .catchError((error){
                  emit(SocialLikePostErrorState(error.toString()));
            });
            // element.reference.collection('comments').get().then((value) {
            //   commentsSum.add(value.docs.length);
            //
            // }).catchError((error){
            //
            // });

          });
          emit(SocialGetPostsSuccessState());
    }).catchError((error){
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like' : true ,
    })
        .then((value) {
        emit(SocialLikePostSuccessState());
    })
        .catchError((error){
      emit(SocialLikePostErrorState(error.toString()));
    });

  }

  List<UserModel> users = [] ;
  void getUsers(){
    users = [];
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {

        if(element.data()['uId'] != userModel!.uId)
          users.add(UserModel.fromJson(element.data()));

      });
      emit(SocialGetAllUserSuccessState());
    }).catchError((error){
      emit(SocialGetAllUserErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text ,
}){
    MessageModel model = MessageModel(
      text: text ,
      senderId: userModel!.uId ,
      receiverId: receiverId ,
      dateTime: dateTime
    );

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
          emit(SocialSendMessageSuccessState());
    }).catchError((error){
          emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error){
      emit(SocialSendMessageErrorState());
    });

  }

  List<MessageModel> messages =[];

  void getMessages({
  required String receiverId
}){
    
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
          event.docs.forEach((element) {
              messages.add(MessageModel.fromJson(element.data()));
          });
          emit(SocialGetMessagesSuccessState());
    });
  }

  void commentOnPost({
    required String postId,
    required String dateTime,
    required String text ,
  }){
    CommentModel model = CommentModel(
        text: text ,
        senderId: userModel!.uId ,
        postId: postId ,
        dateTime: dateTime,
        senderName: userModel!.name,
        senderImage: userModel!.image
    );
      emit(SocialCommentLoadingState());
    FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(SocialCommentSuccessState());
    }).catchError((error){
      emit(SocialCommentErrorState());
    });

  }
  List<CommentModel> comments =[];

  void getComments(postId){
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore
        .instance
        .collection('posts')
        .doc(postId)
        .collection("comments")
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
      });
      emit(SocialGetCommentsSuccessState());
    });
  }

  UserModel? anotherUserModel ;
  void getAnotherUser(
      String userId
      ){
    emit(SocialGetAnotherUserLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(userId)
        .get()
        .then((value) {
      print(value.data());
      anotherUserModel = UserModel.fromJson(value.data());
      emit(SocialGetAnotherUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SocialGetAnotherUserErrorState());
    });
  }

  List<PostModel> someonePosts = [] ;
  List<String> someonePostsId = [] ;
  List<int> someoneLikes = [] ;
  List<int> someoneCommentsSum = [] ;

  void getSomeonePosts(String userId){
    emit(SocialGetSomeonePostsLoadingState());
    someonePosts = [] ;
    someoneLikes = [] ;
    someonePostsId = [] ;
    someoneCommentsSum = [];
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.get('uId') == userId){
          element.reference.collection('likes').get()
              .then((value) {
            someoneLikes.add(value.docs.length);
            someonePostsId.add(element.id);
            someonePosts.add(PostModel.fromJson(element.data()));
            emit(SocialGetSomeonePostsSuccessState());

          })
              .catchError((error){
            emit(SocialLikePostErrorState(error.toString()));
          });
        }


      });
      emit(SocialGetSomeonePostsSuccessState());
    }).catchError((error){
      emit(SocialGetSomeonePostsErrorState(error.toString()));
    });
  }

  void followSomeone(String userId){
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('homies')
        .doc(userModel!.uId)
        .set({
      'homie' : true ,
    })
        .then((value) {
      emit(SocialFollowSomeoneSuccessState());
    })
        .catchError((error){
      emit(SocialFollowSomeoneErrorState(error.toString()));
    });

  }
  var numHomies ;
  int? getNumOfHomies(
      String userId
      ){
    numHomies = 0 ;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('homies')
        .get()
        .then((value) {
         numHomies = value.docs.length ;
    });
  }
  var myId ;
  bool? isIamHomie(String userId){
    myId = false ;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('homies')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            if (element.id == userModel!.uId){
              myId = true;
            }
          });

          print('is I am Homie ? ${myId}');
    });

  }

  dynamic isLiked(String postId){
   var myLike = false ;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.id == userModel!.uId){
          myLike = true;
        }
      });

      print('is I Liked ? ${myLike}');
      return myLike ;
    });


  }


  List<UserModel> search = [] ;
  void getSearch(String name)async{
    search = [];
    users.forEach((element) {
      if(element.name.toLowerCase().startsWith(name.toLowerCase())){
        search.add(element);
      }
      print(search);
    });
      emit(SocialGetSearchUserSuccessState());
  }






}