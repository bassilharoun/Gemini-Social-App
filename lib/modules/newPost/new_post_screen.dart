import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/models/social_user_model.dart';
import 'package:gemini_social_app/modules/feeds/feeds_screen.dart';
import 'package:gemini_social_app/modules/settings/settings_screen.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/styles/Iconly-Broken_icons.dart';
import 'package:intl/intl.dart';

class NewPostScreen extends StatelessWidget {

  var postTextController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener:(context , state){} ,
      builder:(context , state){
        var model = SocialCubit.get(context).userModel;
        return Scaffold(
          appBar: defaultAppBar(
              color: Theme.of(context).scaffoldBackgroundColor,
              context: context,
              title: 'New Post',
              titleColor: textColor,
              actions: [defaultTextButton(
                  function: (){
                    if(formKey.currentState!.validate()){
                      var now = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
                      if(SocialCubit.get(context).postImage == null){
                        SocialCubit.get(context).createPost(
                            date: now.toString(),
                            postText: postTextController.text
                        );
                      }else{
                        SocialCubit.get(context).uploadPostImage(
                          date: now.toString(),
                          postText: postTextController.text,
                        );
                      }
                      showToast(text: 'Post Uploaded Done', state: ToastStates.SUCCESS);
                      postTextController.text = '';
                    }
                  },
                  text: 'Post',
                  color: Colors.blue
              )]
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if(state is SocialCreatePostLoadingState)
                    LinearProgressIndicator(
                    color: lightColor,),
                  if(state is SocialCreatePostLoadingState)
                    SizedBox(height: 10,),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(model!.image),
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(model.name),
                                SizedBox(width: 5,),
                              ],
                            ),
                            Text('Public',
                              style: Theme.of(context).textTheme.caption,

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value){
                          if(value!.isEmpty){
                            return 'What\'s in your Mind !' ;
                          }
                              },
                      controller: postTextController,
                      decoration: InputDecoration(
                          hintText: "What's in your mind, ${model.name} ?",
                      border: InputBorder.none,
                        focusedBorder: InputBorder.none
                      ),
                        ),
                  ),
                  SizedBox(height: 20,),
                  if(SocialCubit.get(context).postImage != null)
                     Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image:  FileImage(File(SocialCubit.get(context).postImage.path)) as ImageProvider,
                                fit: BoxFit.cover

                            )
                        ),
                      ),
                      IconButton(onPressed: (){
                        SocialCubit.get(context).removePostImage();
                      },
                          icon: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.close,color: textColor,)
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(onPressed: (){
                          SocialCubit.get(context).getPostImage();
                        },

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconly_Broken.Image),
                            SizedBox(width: 5,),
                            Text('Photos')
                          ],
                        )),
                      ),
                      Expanded(
                        child: TextButton(onPressed: (){},
                            child: Text('# Tags')
                          ),
                      ),
                    ],
                  )
                ],),
            ),
          ),
        );
      } ,
    );
  }
}
