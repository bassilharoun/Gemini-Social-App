
abstract class SocialSignupStates {}

class SocialSignupInitialState extends SocialSignupStates {}
class SocialSignupLoadingState extends SocialSignupStates {}
class SocialSignupSuccessState extends SocialSignupStates {}
class SocialSignupErrorState extends SocialSignupStates {
  final String error ;
  SocialSignupErrorState(this.error);
}

class SocialCreateUserSuccessState extends SocialSignupStates {}
class SocialCreateUserErrorState extends SocialSignupStates {
  final String error ;
  SocialCreateUserErrorState(this.error);
}

class SocialChangePasswordVisibilitySignupState extends SocialSignupStates {}