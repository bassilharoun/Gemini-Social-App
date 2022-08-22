import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/layout/social_layout.dart';
import 'package:gemini_social_app/modules/signup/cubit/cubit.dart';
import 'package:gemini_social_app/modules/signup/cubit/states.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/shared/components/constants.dart';
import 'package:gemini_social_app/shared/network/local/cache_helper.dart';

class SignupScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialSignupCubit(),
      child: BlocConsumer<SocialSignupCubit , SocialSignupStates>(
        listener:(context , state) {
          if(state is SocialCreateUserSuccessState){
            SocialCubit.get(context).getUserData();
            CacheHelper.saveData(
                key: 'uId',
                value: uId).then((value) {
              navigateAndFinish(context, SocialLayout());
            });          }
        } ,
        builder:(context , state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signup',
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: textColor
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Register to be with our family !',
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 30,),
                        defaultTxtForm(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (value){
                              if(value!.isEmpty){
                                return "What\'s your name !";
                              }

                            },
                            label: 'Name',
                            prefix: Icons.person
                        ),
                        SizedBox(height: 15,),
                        defaultTxtForm(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (value){
                              if(value!.isEmpty){
                                return "We need your phone !";
                              }

                            },
                            label: 'Phone',
                            prefix: Icons.phone_iphone_outlined
                        ),
                        SizedBox(height: 15,),
                        defaultTxtForm(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value){
                              if(value!.isEmpty){
                                return "Your email can't be empty !";
                              }

                            },
                            label: 'Email',
                            prefix: Icons.email_outlined
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTxtForm(controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (value){
                              if(value!.isEmpty){
                                return "Password is too short !";
                              }
                            },
                            onSubmit: (value){
                              
                            },
                            label: 'Password',
                            isPassword: SocialSignupCubit.get(context).isPassword,
                            prefix: Icons.lock_open_outlined,
                            suffix: SocialSignupCubit.get(context).suffix,
                            onSuffixPressed: (){
                              SocialSignupCubit.get(context).changePasswordVisibility();
                            }
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialSignupLoadingState,
                          builder: (context) => defaultButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  SocialSignupCubit.get(context).userSignup(
                                    name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text
                                  );
                                }
                              },
                              text: 'Signup'
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator(color: buttonsColor,)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } ,
      ),
    );
  }
}
