import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/models/post_model.dart';
import 'package:gemini_social_app/modules/add_comment/add_comment_screen.dart';
import 'package:gemini_social_app/modules/user/user_screen.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/styles/Iconly-Broken_icons.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state) {} ,
      builder: (context , state) {
        return ConditionalBuilder(
            condition: SocialCubit.get(context).posts.length > 0 && SocialCubit.get(context).userModel != null ,
            builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 15,
                    margin: EdgeInsets.all(10),
                    child: Image.network(
                      'https://mqalaat.net/images/8/81/%D8%B1%D9%85%D8%B2_%D8%A8%D8%B1%D8%AC_%D8%A7%D9%84%D8%AC%D9%88%D8%B2%D8%A7%D8%A1.jpg' ,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context , index) => buildPostItem(SocialCubit.get(context).posts[index] , context , index ),
                    separatorBuilder: (context , index) => SizedBox(height: 10,),
                    itemCount: SocialCubit.get(context).posts.length,
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),
            fallback: (context) => Center(
                child: CircularProgressIndicator(color: buttonsColor,)),
        );
      },
    );
  }

}
Widget buildPostItem(PostModel model , context , index ) {
  // bool isLiked = SocialCubit.get(context).isLiked(SocialCubit.get(context).postsId[index]);


  return Card(
    color: Theme.of(context).scaffoldBackgroundColor,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 15,
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  if(model.uId != SocialCubit.get(context).userModel!.uId){
                    navigateTo(context, UserScreen(model.uId));
                  }
                  else{
                    SocialCubit.get(context).changeBottomNav(3) ;
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
              ),
              SizedBox(width: 15,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    if(model.uId != SocialCubit.get(context).userModel!.uId){
                      navigateTo(context, UserScreen(model.uId));
                    }
                    else{
                      SocialCubit.get(context).changeBottomNav(3) ;
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${model.name}'),
                          SizedBox(width: 5,),
                          Icon(
                            Icons.check_circle,color: Colors.blue,
                            size: 16,
                          ),
                        ],
                      ),
                      Text('${model.date}',
                        style: Theme.of(context).textTheme.caption,

                      ),
                    ],
                  ),
                ),
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: myDivider(),
          ),
          Text(
            '${model.postText}'
            ,style: Theme.of(context).textTheme.bodyText1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              child: Wrap(
                children: [
                  // Padding(
                  //   padding: const EdgeInsetsDirectional.only(end : 8 ),
                  //   child: Container(
                  //     height: 25,
                  //     child: MaterialButton(onPressed: (){},
                  //       padding: EdgeInsets.zero,
                  //       minWidth: 1,
                  //       height: 25,
                  //       child: Text(
                  //         '#Flutter',style: TextStyle(color: Colors.blue),),
                  //     ),
                  //   ),
                  // ),
                ],),
            ),
          ),
          if(model.postImage != '')
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10 , horizontal: 0),
              child: Image.network(
                '${model.postImage}' ,
                fit: BoxFit.cover,
                height: 140,
                width: double.infinity,
              ),
            ),
          Row(
            children: [
              InkWell(
                child: Row(
                  children: [
                  //  SocialCubit.get(context).listOfIsLiked[index] ? Icon(Icons.favorite , color: Colors.red,) :
                    Icon(Icons.favorite_border),
                    SizedBox(width: 5,),
                    Text('${SocialCubit.get(context).likes[index]}',
                      style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
                    )
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                  SocialCubit.get(context).getComments(SocialCubit.get(context).postsId[index]);
                },
              ),
              Spacer(),
              InkWell(
                child: Row(
                  children: [
                    Icon(Iconly_Broken.Chat),
                    SizedBox(width: 5,),
                    Text('Comments',
                      style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
                    )
                  ],
                ),
                onTap: (){
                  navigateTo(context, AddCommentScreen(SocialCubit.get(context).postsId[index]));
                },
              ),
            ],
          ),
          SizedBox(height: 10,),
          myDivider(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: InkWell(
              onTap: (){
                navigateTo(context, AddCommentScreen(SocialCubit.get(context).postsId[index]));
                SocialCubit.get(context).getComments(SocialCubit.get(context).postsId[index]);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('${SocialCubit.get(context).userModel!.image}'),
                  ),
                  SizedBox(width: 15,),
                  Container(
                    child: Text('Write a Comment...',
                      style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ) ;
}
