import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/modules/chats/chats_screen.dart';
import 'package:gemini_social_app/modules/newPost/new_post_screen.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/styles/Iconly-Broken_icons.dart';

class SocialLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state) {},
      builder: (context , state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              navigateTo(context, NewPostScreen());
            },
          child: Icon(Iconly_Broken.Paper_Plus),

          ),

          appBar: AppBar(
            actions: [
              IconButton(onPressed: (){},
                  icon: Icon(Iconly_Broken.Heart)),
              IconButton(onPressed: (){
                SocialCubit.get(context).getUsers();
                navigateTo(context, ChatsScreen());
              },
                  icon: Icon(Iconly_Broken.Send)),
            ],
            centerTitle: true,
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Iconly_Broken.Home),
                label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Iconly_Broken.Search),
              label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Iconly_Broken.Location)
              , label: 'Location'),
              BottomNavigationBarItem(icon: Icon(Iconly_Broken.Profile)
              ,label: 'Profile'),
            ],

          ),
          body: cubit.screens[cubit.currentIndex],
        );
      }
    );
  }
}
