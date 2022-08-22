import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/models/post_model.dart';
import 'package:gemini_social_app/models/social_user_model.dart';
import 'package:gemini_social_app/modules/add_comment/add_comment_screen.dart';
import 'package:gemini_social_app/modules/feeds/feeds_screen.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/styles/Iconly-Broken_icons.dart';

class UserScreen extends StatelessWidget {

  dynamic userId ;
  UserScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).getAnotherUser(userId);
    SocialCubit.get(context).getSomeonePosts(userId);
    SocialCubit.get(context).getNumOfHomies(userId);
    SocialCubit.get(context).isIamHomie(userId);
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state) {
        if(state is SocialFollowSomeoneSuccessState){
          SocialCubit.get(context).myId = true ;
          SocialCubit.get(context).numHomies = SocialCubit.get(context).numHomies + 1 ;
        }
      } ,
      builder: (context , state) {
        var model = SocialCubit.get(context).anotherUserModel;
        return ConditionalBuilder(
          condition: state is!  SocialGetSomeonePostsLoadingState,
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(model!.name),),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 170,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image:  NetworkImage(
                                        model.cover) ,
                                    fit: BoxFit.cover

                                )
                            ),
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
                                backgroundImage: NetworkImage(
                                    model.image) ,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(model.name,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 24
                    ),
                  ),
                  Text(model.bio,
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
                                Text("${SocialCubit.get(context).numHomies}",
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
                            child: Container(
                              height: 45,
                                child: buildButton(context)
                            )
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
          ),
          fallback: (context) => Scaffold(body: Center(child: CircularProgressIndicator(color: buttonsColor,),)),
        );
      } ,
    );
  }
  Widget buildButton(context) =>  SocialCubit.get(context).myId ?
  OutlinedButton(
    onPressed: (){},
    child: Text('You can\'t lose your Homies !' ,style: TextStyle(color: Colors.red),),

  )
      : defaultButton(
      function: (){
        SocialCubit.get(context).followSomeone(userId);
        buildButton(context);
      }, text: 'Homie');
}
Widget buildSomeonePostItem(PostModel model , context , index) => Card(
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
                  Icon(Iconly_Broken.Heart),
                  SizedBox(width: 5,),
                  Text('${SocialCubit.get(context).someoneLikes[index]}',
                    style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
                  )
                ],
              ),
              onTap: (){
                SocialCubit.get(context).likePost(SocialCubit.get(context).someonePostsId[index]);
                SocialCubit.get(context).getComments(SocialCubit.get(context).someonePostsId[index]);
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
                navigateTo(context, AddCommentScreen(SocialCubit.get(context).someonePostsId[index]));
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
              navigateTo(context, AddCommentScreen(SocialCubit.get(context).someonePostsId[index]));
              SocialCubit.get(context).getComments(SocialCubit.get(context).someonePostsId[index]);
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
);

