import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:gemini_social_app/modules/feeds/feeds_screen.dart';
import 'package:gemini_social_app/modules/user/user_screen.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/styles/Iconly-Broken_icons.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state) {},
      builder: (context , state) {
        var userModel = SocialCubit.get(context).userModel ;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        SocialCubit.get(context).getNumOfHomies(userModel!.uId);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if(state is SocialUserUpdateLoadingState)
                  LinearProgressIndicator(
                    color: lightColor,
                  ),
                if(state is SocialUserUpdateLoadingState)
                  SizedBox(height: 5,),
                Container(
                  height: 170,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: coverImage == null ? NetworkImage(
                                          '${userModel.cover}') : FileImage(File(coverImage.path)) as ImageProvider,
                                      fit: BoxFit.cover

                                  )
                              ),
                            ),
                            IconButton(onPressed: (){
                              SocialCubit.get(context).getCoverImage();
                            },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.white,
                                    child: Icon(Iconly_Broken.Edit,color: textColor,)
                                )
                            )
                          ],
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 46,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              backgroundImage: profileImage == null ?NetworkImage(
                                  '${userModel.image}') : FileImage(File(profileImage.path)) as ImageProvider,
                            ),
                          ),
                          IconButton(onPressed: (){
                            SocialCubit.get(context).getProfileImage();
                          },
                              icon: CircleAvatar(
                                radius: 13,
                                  backgroundColor: Colors.white,
                                  child: Icon(Iconly_Broken.Camera,color: textColor,size: 20,)
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Text('${userModel.name}',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 24
                  ),
                ),
                Text('${userModel.bio}',
                  maxLines: 3,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 16
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text('Homies',style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontSize: 18
                              ),),
                              Text('${SocialCubit.get(context).numHomies}'
                                ,
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontSize: 18
                              ),),

                            ],
                          ),
                          onTap: (){},
                        ),
                      ),

                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: OutlinedButton(
                            onPressed: (){
                              navigateTo(context, EditProfileScreen());
                            },
                            child:Text('Edit Profile',style: TextStyle(color: buttonsColor),)  ,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context , index) => buildSomeonePostItem(SocialCubit.get(context).someonePosts[index] , context , index),
                      separatorBuilder: (context , index) => SizedBox(height: 10,),
                      itemCount: SocialCubit.get(context).someonePosts.length
                  ),
                SizedBox(height: 15,)
                  
                
              ],
            ),
          ),
        ) ;
      },
    );
  }
}
