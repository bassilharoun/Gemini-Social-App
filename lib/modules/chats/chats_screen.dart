import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/models/social_user_model.dart';
import 'package:gemini_social_app/modules/chats/chat_details_screen.dart';
import 'package:gemini_social_app/modules/user/user_screen.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/styles/Iconly-Broken_icons.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state){},
      builder: (context , state){
        return  Scaffold(
          appBar: AppBar(),
          body:  ConditionalBuilder(
            condition: SocialCubit.get(context).users.length > 0,
            builder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context , index) => buildChatItem(SocialCubit.get(context).users[index] , context),
                separatorBuilder: (context , index) => myDivider(),
                itemCount: SocialCubit.get(context).users.length
            ),
            fallback: (Context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              Icon(
                Iconly_Broken.Close_Square,size: 100, color: Colors.grey,) , Text('No Chats !' , style: TextStyle(fontSize: 50 , color: Colors.grey),)],)),
          ),
        );
      },
    );
  }


}
Widget buildChatItem(UserModel model , context) => InkWell(
  onTap: (){
    navigateTo(context, ChatDetailsScreen(userModel: model,));
    },
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('${model.image}'),
        ),
        SizedBox(width: 15,),
        Row(
          children: [
            Text('${model.name}' , style: TextStyle(fontSize: 18),),
            SizedBox(width: 5,),
          ],
        ),
      ],
    ),
  ),
);

Widget buildSearchItem(UserModel model , context) => InkWell(
  onTap: (){
    navigateTo(context, UserScreen(model.uId));
  },
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('${model.image}'),
        ),
        SizedBox(width: 15,),
        Row(
          children: [
            Text('${model.name}' , style: TextStyle(fontSize: 18),),
            SizedBox(width: 5,),
          ],
        ),
      ],
    ),
  ),
);
