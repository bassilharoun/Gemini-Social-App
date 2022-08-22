import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/layout/social_layout.dart';
import 'package:gemini_social_app/modules/login/cubit/cubit.dart';
import 'package:gemini_social_app/modules/login/cubit/states.dart';
import 'package:gemini_social_app/modules/signup/signup_screen.dart';
import 'package:gemini_social_app/shared/colors.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit , SocialLoginStates>(
        listener: (context , state) {
          if(state is SocialLoginErrorState){
            showToast(text: state.error,
                state: ToastStates.ERROR
            );
          }
          if(state is SocialLoginSuccessState){
            SocialCubit.get(context).getUserData();
            CacheHelper.saveData(
                key: 'uId',
                value: state.uId).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context , state) {
          return Scaffold(
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
                          'LOGIN.',
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: textColor
                          ),
                        ),
                        SizedBox(height: 30,),
                        Center(child: Container(
                          height: 220,
                            width: 220,
                            child: Image(image: AssetImage('assets/images/gemini-messenger.png')))),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Let's Start our Journey, around the world !",
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 30,),
                        defaultTxtForm(controller: emailController,
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
                              if(formKey.currentState!.validate()){
                                // SocialLoginCubit.get(context).userLogin(
                                //     email: emailController.text,
                                //     password: passwordController.text
                                // );
                              }
                            },
                            label: 'Password',
                            isPassword: SocialLoginCubit.get(context).isPassword,
                            prefix: Icons.lock_open_outlined,
                            suffix: SocialLoginCubit.get(context).suffix,
                            onSuffixPressed: (){
                              SocialLoginCubit.get(context).changePasswordVisibility();
                            }
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  SocialLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text
                                  );
                                }
                              },
                              text: 'Login'
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator(color: buttonsColor,)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account ?",
                              style: TextStyle(fontSize: 16),
                            ),
                            defaultTextButton(function: (){
                              navigateTo(context , SignupScreen());
                            }, text: 'Signup'),

                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ) ;
        },
      ),
    );
  }
}
