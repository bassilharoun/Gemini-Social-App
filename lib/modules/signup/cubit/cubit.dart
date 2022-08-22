import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/models/social_user_model.dart';
import 'package:gemini_social_app/modules/signup/cubit/states.dart';
import 'package:gemini_social_app/shared/components/constants.dart';

class SocialSignupCubit extends Cubit<SocialSignupStates>{
  SocialSignupCubit() : super(SocialSignupInitialState());

  static SocialSignupCubit get(context) => BlocProvider.of(context);


  void userSignup({
    required String email ,
    required String name ,
    required String phone ,
    required String password
}){
    emit(SocialSignupLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          email: email,
          name: name,
          phone: phone,
          uId: value.user!.uid);
      uId = value.user!.uid;
    }).catchError((error){
      emit(SocialSignupErrorState(error));
    });
  }

  void userCreate({
    required String email ,
    required String name ,
    required String phone ,
    required String uId ,
}){
    UserModel model = UserModel(
      name: name ,
      email: email ,
      phone: phone ,
      uId: uId ,
      image: 'https://i.pinimg.com/564x/92/a8/6c/92a86c8fa88acc7432a4c3fcfeedd003.jpg' ,
      cover: 'https://i.pinimg.com/564x/48/77/10/4877107db152d077b13b2c7b21623dfb.jpg' ,
      bio: 'Hey iam New Gemini !' ,
      isEmailVerified: false
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
          emit(SocialCreateUserSuccessState());
    }).catchError((error){
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined ;
  bool isPassword = true ;

  void changePasswordVisibility(){
    isPassword = !isPassword ;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;
   emit(SocialChangePasswordVisibilitySignupState());
  }
}