import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/models/message_model.dart';
import 'package:gemini_social_app/models/social_user_model.dart';
import 'package:gemini_social_app/shared/colors.dart';

class ChatDetailsScreen extends StatelessWidget {

  UserModel? userModel ;
  ChatDetailsScreen({this.userModel});

  var chatMessageController = TextEditingController() ;
  var scrollController = ScrollController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).getMessages(receiverId: userModel!.uId);
    return Builder(builder: (BuildContext context){
      return  BlocConsumer<SocialCubit , SocialStates>(
        listener: (context , state){
          if(state is SocialGetMessagesSuccessState && SocialCubit.get(context).messages.length > 0){
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
            });
          }
          if(state is SocialSendMessageSuccessState){
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        } ,
        builder: (context , state){
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userModel!.image),
                ),
                SizedBox(width: 15,),
                Text(userModel!.name , style: TextStyle(fontSize: 18),),
                SizedBox(width: 5,),
              ],),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ConditionalBuilder(
                          condition: SocialCubit.get(context).messages.length > 0,
                          builder:(context) => ListView.separated(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context , index){
                                var message = SocialCubit.get(context).messages[index];
                                if(SocialCubit.get(context).userModel!.uId == message.senderId)
                                  return buildMyMessage(message);

                                return buildMessage(message);
                              },
                              separatorBuilder: (context , index) => SizedBox(height: 5,),
                              itemCount: SocialCubit.get(context).messages.length
                          ) ,
                          fallback: (context) => Center(child: Text('No Messages'),),
                        ),
                      ),
                    ),
                    Row(children: [
                      Expanded(child:
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1
                            ),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            validator: (value){
                              if(value!.isEmpty){
                                return 'What you will say !' ;
                              }
                            },
                            controller: chatMessageController,
                            decoration: InputDecoration(
                                hintText: "What you would Say ...",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none
                            ),
                          ),
                        ),
                      ),),
                      SizedBox(width: 5,),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50) , color: buttonsColor,),
                        child: MaterialButton(
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              SocialCubit.get(context).sendMessage(
                                  receiverId: userModel!.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: chatMessageController.text
                              );
                              chatMessageController.text = '';
                              scrollController.jumpTo(scrollController.position.maxScrollExtent);
                            }
                          },
                          minWidth: 1,
                          child: Icon(Icons.send , color: Colors.white,),
                        ),
                      )
                    ],)
                  ],
                ),
              ),
            )
          );
        } ,
      );
    });
  }

  Widget buildMyMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
          color: buttonsColor,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),

          )
      ),
      padding: EdgeInsets.symmetric(
          vertical: 5 ,
          horizontal: 10
      ),
      child: Text(
        model.text,
        style: TextStyle(color: Colors.white),

      ),
    ),
  );
  Widget buildMessage(MessageModel model) =>  Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),

          )
      ),
      padding: EdgeInsets.symmetric(
          vertical: 5 ,
          horizontal: 10
      ),
      child: Text(
        model.text,
        style: TextStyle(color: Colors.black),

      ),
    ),
  );
}
