import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_social_app/app_cubit/app_cubit.dart';
import 'package:gemini_social_app/app_cubit/app_states.dart';
import 'package:gemini_social_app/layout/social_layout.dart';
import 'package:gemini_social_app/modules/login/login_screen.dart';
import 'package:gemini_social_app/shared/bloc_observer.dart';
import 'package:gemini_social_app/shared/components/components.dart';
import 'package:gemini_social_app/shared/components/constants.dart';
import 'package:gemini_social_app/shared/network/local/cache_helper.dart';
import 'package:gemini_social_app/styles/themes.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  showToast(text: 'on background Message', state: ToastStates.SUCCESS);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(text: 'on Message', state: ToastStates.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(text: 'on Message opened App', state: ToastStates.SUCCESS);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();

  uId = CacheHelper.getData(key: 'uId');
  Widget widget ;
  if(uId != null){
    widget = SocialLayout();
  }else {
    widget = LoginScreen() ;
  }

  runApp(MyApp(
      startWidget : widget,
  ));
}

class MyApp extends StatelessWidget{
  final Widget? startWidget ;
  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SocialCubit()..getUserData()..getPosts(),),
      ],
      child: BlocConsumer<SocialCubit , SocialStates>(
        listener: (context , state){},
        builder: (context , state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light ,
            home: startWidget,
          );
        },
      ),
    );
  }

}
